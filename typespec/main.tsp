import "@typespec/http";
import "@typespec/openapi";

using TypeSpec.Http;
using TypeSpec.OpenAPI;
@server(
  "{url}",
  "Teldrive Server URL",
  {
    url: string,
  }
)
@service({
  title: "Teldrive",
})
@route("/api")
namespace Teldrive;

@error
model Error {
  code: integer;
  message: string;
}
model InternalServerError is Response<500>;
model ErrorResponse<T> {
  ...Error;
  ...T;
}

model InternalServerErrorResponse is ErrorResponse<InternalServerError>;
model NotFoundErrorResponse is ErrorResponse<NotFoundResponse>;
model ConflictErrorResponse is ErrorResponse<ConflictResponse>;
model BadRequestErrorResponse is ErrorResponse<BadRequestResponse>;

model Session {
  name: string;
  userName: string;
  userId: integer;
  isPremium: boolean;
  hash: string;
  expires: string;
  session?: string;
}

@route("/auth")
@tag("Auth")
interface Auth {
  @route("/session")
  @summary("Get session information")
  @get
  session(): Session | null;

  @route("/login")
  @summary("Login")
  @post
  login(...Session): OkResponse | InternalServerErrorResponse;

  @route("/logout")
  @summary("Logout")
  @useAuth(BearerAuth)
  @post
  logout(): OkResponse | InternalServerErrorResponse;

  @route("/ws")
  @summary("Websocket QR Login")
  @get
  ws(): Response<101>;
}

enum Category {
  archive,
  audio,
  document,
  image,
  other,
  video,
}

@withOptionalProperties
model FileQuery {
  @query
  name?: string;

  @query
  query?: string;

  @query
  searchType?: "text" | "regex" = "text";

  @query
  type?: string;

  @query
  path?: string;

  @query
  `op`?: "list" | "find" = "list";

  @query
  deepSearch?: boolean;

  @query
  shared?: boolean;

  @query
  @format("uuid")
  parentId?: string;

  @query
  category?: Category;

  @query
  updatedAt?: string;

  @query
  sort?: "name" | "updatedAt" | "size" = "name";

  @query
  order?: "asc" | "desc" = "asc";

  @query
  @maxValue(1000)
  @minValue(1)
  limit?: integer = 500;

  @query
  @minValue(1)
  page?: integer = 1;
}

model Part {
  id: integer;
  salt?: string;
}
model File {
  @format("uuid")
  id?: string;
  name: string;
  type: string;
  parts?: Part[];
  mimeType?: string;
  channelId: integer;
  path?: string;
  @format("uuid")
  parentId?: string;
  size: integer;
  encrypted?: boolean;
  updatedAt?: utcDateTime;
  parentPath?: string;
}

model Meta {
  count?: integer;
  totalPages?: integer;
  currentPage?: integer;
}
model FileShareCreate {
  password?: string;
  expiresAt?: utcDateTime;
}

model FileShare {
  protected: boolean;
  userId?: integer;
  type: string;
  name: string;
  expiresAt?: utcDateTime;
}

model FileOperation {
  files: string[];
  destination?: string;
}

model DeleteOperation {
  files?: string[];
  source?: string;
}

@route("/files")
@tag("Files")
@useAuth(BearerAuth)
interface Files {
  @route("")
  @get
  @summary("List all files")
  list(...FileQuery):
    | {
        files: File[];
        meta: Meta;
      }
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("")
  @post
  @summary("Create a new file")
  create(...File):
    | {...File,@statusCode _: 201}
    | NotFoundErrorResponse
    | ConflictErrorResponse
    | BadRequestErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}")
  @get
  @summary("Get file by ID")
  getById(
    @path id: string,
  ): File | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/{id}")
  @patch
  @summary("Update file")
  update(
    @path id: string,
    @bodyRoot body: {
      name?: string;
      parts?: Part[];
      size?: integer;
      updatedAt?: utcDateTime;
    },
  ):
    | File
    | NotFoundErrorResponse
    | ConflictErrorResponse
    | BadRequestErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/parts")
  @put
  @summary("Update file parts")
  updateParts(
    @path id: string,
    @body body: {
      parts?: Part[];
      uploadId?: string;
      updatedAt: utcDateTime;
      size: integer;
      channelId: integer;
    },
  ): NoContentResponse | NotFoundErrorResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @delete
  @summary("Delete share")
  deleteShare(
    @path id: string,
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @get
  @summary("Get share by file ID")
  shareByid(@path id: string): FileShare | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @patch
  @summary("Edit share")
  editShare(
    @path id: string,
    @bodyRoot body: FileShareCreate,
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @post
  @summary("Create a share for the file")
  createShare(
    @path id: string,
    @body body: FileShareCreate,
  ): CreatedResponse | InternalServerErrorResponse;

  @route("/{id}/copy")
  @post
  @summary("Copy file")
  copy(
    @path id: string,
    @body body: {
      name: string;
      destination: string;
    },
  ): File | NotFoundErrorResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/{id}/stream/{name}")
  @get
  @summary("Stream file by ID")
  stream(@path id: string, @path name: string, @query hash?: string):
    | OkResponse
    | Response<206>
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/download/{name}")
  @get
  @summary("Download file by ID")
  download(@path id: string, @path name: string, @query hash?: string):
    | OkResponse
    | Response<206>
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/categories")
  @get
  @summary("Get category stats")
  categoryStats(): {
    totalFiles: integer;
    totalSize: integer;
    category: string;
  } | InternalServerErrorResponse;

  @route("/move")
  @post
  @summary("Move files")
  move(...FileOperation): NoContentResponse | InternalServerErrorResponse;

  @route("/folders")
  @post
  @summary("Make a new directory")
  mkdir(
    @body body: {
      path: string;
    },
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/folders/move")
  @post
  @summary("Move directory")
  movedir(
    @body body: {
      source: string;
      destination: string;
    },
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/delete")
  @post
  @summary("Bulk Delete files")
  bulkDelete(
    @body body: {
      files: string[];
      source: string;
    },
  ): NoContentResponse | InternalServerErrorResponse;
}

model UploadQuery {
  @query
  partName: string;

  @query
  fileName: string;

  @query
  partNo: integer;

  @query
  channelId?: integer;

  @query
  encrypted?: boolean;
}

model UploadPart {
  name: string;
  partId: integer;
  partNo: integer;
  channelId: integer;
  size: integer;
  encrypted: boolean;
  salt?: string;
}

model UploadStats {
  uploadDate: string;
  totalUploaded: integer;
}

@route("/uploads")
@tag("Uploads")
@useAuth(BearerAuth)
interface Uploads {
  @route("/{id}")
  @post
  @summary("Upload file")
  upload(
    @path id: string,
    @header contentType: "application/octet-stream",
    @bodyRoot body: bytes,
    ...UploadQuery,
  ): UploadPart | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/{id}")
  @get
  @summary("Get uploaded parts by ID")
  partsById(@path id: string): UploadPart[] | InternalServerErrorResponse;

  @route("/{id}")
  @delete
  @summary("Delete uploaded file")
  delete(@path id: string): NoContentResponse | InternalServerErrorResponse;

  @route("/stats")
  @get
  @summary("Get upload stats")
  stats(@query days: integer): UploadStats[] | InternalServerErrorResponse;
}

model TgSession {
  hash: string;
  createdAt: string;
  location?: string;
  officialApp?: boolean;
  appName?: string;
  valid: boolean;
  current: boolean;
}

model Channel {
  channelName: string;
  channelId: integer;
}

@route("/users")
@tag("Users")
@useAuth(BearerAuth)
interface Users {
  @route("/profile")
  @get
  @summary("Get user profile photo")
  profileImage(
  ): OkResponse | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/config")
  @get
  @summary("Get user config")
  stats(): {
    channelId: integer;
    bots: string[];
  } | InternalServerErrorResponse;

  @route("/channels")
  @get
  @summary("List user channels")
  listChannels(): Channel[] | InternalServerErrorResponse;

  @route("/channels")
  @patch
  @summary("Update user channel")
  updateChannel(...Channel): NoContentResponse | InternalServerErrorResponse;

  @route("/sessions")
  @get
  @summary("List user sessions")
  listSessions(): TgSession[] | InternalServerErrorResponse;

  @route("/bots")
  @post
  @summary("Add bots to user account")
  addBots(
    @bodyRoot body: {
      bots: string[];
    },
  ): NoContentResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/bots")
  @delete
  @summary("Remove bots from user account")
  removeBots(): NoContentResponse | InternalServerErrorResponse;

  @route("/sessions/{id}")
  @delete
  @summary("Remove user session")
  removeSession(
    @path id: string,
  ): NoContentResponse | InternalServerErrorResponse;
}

@route("/shares")
@tag("Shares")
interface Shares {
  @route("/{id}")
  @get
  @summary("Get share by ID")
  getById(
    @path id: string,
  ): File | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/{id}/files")
  @get
  @summary("List files in share")
  listFiles(@path id: string):
    | {
        files: File[];
        meta: Meta;
      }
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/files/{fileId}/stream/{name}")
  @get
  @summary("Stream shared file")
  streamFile(@path id: string, @path fileId: string, @path name: string):
    | OkResponse
    | Response<206>
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/files/{fileId}/download/{name}")
  @get
  @summary("Download shared file")
  downloadFile(@path id: string, @path fileId: string, @path name: string):
    | OkResponse
    | Response<206>
    | NotFoundErrorResponse
    | InternalServerErrorResponse;
}

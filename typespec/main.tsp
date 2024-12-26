import "@typespec/http";

using TypeSpec.Http;
@server("{url}", "Teldrive Server URL", {
  url: string;
})
@service({
  title: "Teldrive",
})
@route("/api")
namespace Teldrive;

alias ApiAuth = ApiKeyAuth<ApiKeyLocation.cookie, "user-session"> | BearerAuth;

@error
model Error {
  code: int32;
  message?: string;
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
  name:     string;
	userName:  string;
	userId:    int64; 
	isPremium: boolean;   
	hash:      string; 
	expires:   string ;
  session?:  string;
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
  login(...Session): OkResponse |  InternalServerErrorResponse;
  @route("/logout")
  @summary("Logout")
  @useAuth(ApiAuth)
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
  video
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
  "op"?: "list" | "find" = "list";
  @query
  deepSearch?: boolean;
  @query
  shared?: boolean;
  @query
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
  limit?: int16 = 500;
  @query
  @minValue(1)
  page?: int32 = 1;
}


model Part {
  id: int64;
  salt?: string;
}
model File {
  name: string;
  type: string;
  parts?: Part[];
  mimeType?: string;
  channelId: int64;
  path?: string;
  parentId?: string;
  size: int64;
  encrypted?: boolean;
}

model FileOut extends File{
  id: string;
  updatedAt: utcDateTime;
  parentPath?: string;
}

model  Meta {
  count?: int64;
  totalPages?: int32;
  currentPage?: int32;
}
model FileShareCreate {
  password?: string;
  expiresAt?: utcDateTime;
}

model FileShare {
  protected: boolean;
  userId?: int64;
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
@useAuth(ApiAuth)
interface Files {
@route("")
@get
@summary("List all files")
op list(...FileQuery): {
  files: FileOut[];
  meta: Meta;
} | ConflictErrorResponse | NotFoundErrorResponse | InternalServerErrorResponse;

@route("")
@post
@summary("Create a new file")
op create(...File): FileOut | NotFoundErrorResponse | ConflictErrorResponse 
| BadRequestErrorResponse | InternalServerErrorResponse;

@route("/{id}")
@get
@summary("Get file by ID")
op getById(@path id: string): FileOut | NotFoundErrorResponse | InternalServerErrorResponse;

@route("/{id}")
@patch
@summary("Update file")
op update(
  @path id: string,
    @bodyRoot body: {
    name?: string;
    parts?: Part[];
    size?: int64;
    updatedAt?: utcDateTime;
  },
): FileOut | NotFoundErrorResponse | ConflictErrorResponse | BadRequestErrorResponse 
| InternalServerErrorResponse;

@route("/{id}/parts")
@put
@summary("Update file parts")
op updateParts(
  @path id: string,
  @body body: {
    parts?: Part[];
    uploadId?: string;
    updatedAt: utcDateTime;
    size: int64;
    channelId: int64;
  },
): OkResponse | NotFoundErrorResponse | InternalServerErrorResponse;

@route("/{id}/share")
@delete
@summary("Delete share")
op deleteShare(@path id: string): NoContentResponse | InternalServerErrorResponse;

@route("/{id}/share")
@get
@summary("Get share by file ID")
op shareByid(@path id: string): FileShare | InternalServerErrorResponse;

@route("/{id}/share")
@patch
@summary("Edit share")
op editShare(
  @path id: string,
  @bodyRoot body: FileShareCreate,
):  OkResponse | InternalServerErrorResponse;

@route("/{id}/share")
@post
@summary("Create a share for the file")
op createShare(
  @path id: string,
  @body body: FileShareCreate,
): CreatedResponse | InternalServerErrorResponse;

@route("/{id}/copy")
@post
@summary("Copy file")
op copy(
  @path id: string,
  @body body: {
    name:string;
    destination: string;
  },
): FileOut | BadRequestErrorResponse | InternalServerErrorResponse;

@route("/{id}/stream/{name}")
@get
@summary("Stream file by ID")
op stream(@path id: string, @path name: string,@query hash?:string): OkResponse | Response<206>
| NotFoundErrorResponse | InternalServerErrorResponse;

@route("/{id}/download/{name}")
@get
@summary("Download file by ID")
op download(@path id: string, @path name: string,@query hash?:string): OkResponse | Response<206>
| NotFoundErrorResponse | InternalServerErrorResponse;

@route("/categories")
@get
@summary("Get category stats")
op categoryStats(): {
  totalFiles: int64;
  totalSize: int64;
  category: string;
} | InternalServerErrorResponse;

@route("/move")
@post
@summary("Move files")
op move(
  ...FileOperation
): NoContentResponse | InternalServerErrorResponse;

@route("/folders")
@post
@summary("Make a new directory")
op mkdir(
  @body body: {
    path:string;
  },
): NoContentResponse | InternalServerErrorResponse;

@route("/folders/move")
@post
@summary("Move directory")
op movedir(
  @body body: {
    source: string;
    destination: string;
  },
): NoContentResponse | InternalServerErrorResponse;

@route("/delete")
@post
@summary("Bulk Delete files")
op bulkDelete(
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
  partNo: int32;
  @query
  channelId?: int64;
  @query
  encrypted?: boolean;
}

model UploadPart {
  name: string;
  partId: int32;
  partNo: int32;
  channelId: int64;
  size: int64;
  encrypted: boolean;
  salt?: string;
}

model UploadStats {
  uploadDate: string;
  totalUploaded: int64;
}

@route("/uploads")
@tag("Uploads")
@useAuth(ApiAuth)
interface Uploads {
@route("/{id}")
@post
@summary("Upload file")
op upload(
  @path id: string,
  @header contentType: "application/octet-stream",
  @bodyRoot body: bytes,
  ...UploadQuery
): UploadPart | BadRequestErrorResponse | InternalServerErrorResponse;

@route("/{id}")
@get
@summary("Get uploaded parts by ID")
op partsById(@path id: string): UploadPart[] | InternalServerErrorResponse;

@route("/{id}")
@delete
@summary("Delete uploaded file")
op delete(@path id: string): NoContentResponse | InternalServerErrorResponse;

@route("/stats")
@get
@summary("Get upload stats")
op stats(@query days: int16): UploadStats[] | InternalServerErrorResponse;
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
  channelName:string;
  channelId: string;
}

@route("/users")
@tag("Users")
@useAuth(ApiAuth)
interface Users {
@route("/profile")
@get
@summary("Get user profile photo")
op profileImage(): OkResponse | NotFoundErrorResponse | InternalServerErrorResponse;

@route("/config")
@get
@summary("Get user config")
op stats(): {channelId: int64; bots: string[]} | InternalServerErrorResponse;

@route("/channels")
@get
@summary("List user channels")
op listChannels(): Channel[] | InternalServerErrorResponse;

@route("/channels")
@patch
@summary("Update user channel")
op updateChannel(
 ...Channel
): NoContentResponse | InternalServerErrorResponse;

@route("/sessions")
@get
@summary("List user sessions")
op listSessions(): TgSession[] | InternalServerErrorResponse;

@route("/bots")
@post
@summary("Add bots to user account")
op addBots(
  @bodyRoot body: {
    bots: string[];
  },
): NoContentResponse |  BadRequestErrorResponse | InternalServerErrorResponse;

@route("/bots")
@delete
@summary("Remove bots from user account")
op removeBots():  NoContentResponse  | InternalServerErrorResponse;

@route("/sessions/{id}")
@delete
@summary("Remove user session")
op removeSession(@path id: string): NoContentResponse  | InternalServerErrorResponse;
}

@route("/shares")
@tag("Sharing")
interface Share {
@route("/{id}")
@get
@summary("Get share by ID")
op getById(@path id: string): FileOut | NotFoundErrorResponse | InternalServerErrorResponse;
@route("/{id}/files")
@get
@summary("List files in share")
op listFiles(@path id: string): {
  files: FileOut[];
  meta: Meta;
} | ConflictErrorResponse | NotFoundErrorResponse | InternalServerErrorResponse;

@route("/{id}/files/{fileId}/stream/{name}")
@get
@summary("Stream shared file")
op streamFile(
  @path id: string,
  @path fileId: string,
  @path name: string,
): OkResponse | Response<206>| NotFoundErrorResponse | InternalServerErrorResponse;

@route("/{id}/files/{fileId}/download/{name}")
@get
@summary("Download shared file")
op downloadFile(
  @path id: string,
  @path fileId: string,
  @path name: string,
): OkResponse | Response<206> | NotFoundErrorResponse | InternalServerErrorResponse;
}
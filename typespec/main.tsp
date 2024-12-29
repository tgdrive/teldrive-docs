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

@doc("File streaming response")
model FileStream {
  @doc("The file content as binary data")
  @body
  content: bytes;

  @statusCode
  statusCode: 200 | 206;

  @header("Accept-Ranges")
  @doc("Indicates server supports range requests")
  @example("bytes")
  acceptRanges: "bytes";

  @header("Content-Type")
  @doc("The MIME type of the file")
  @example("application/octet-stream")
  contentType: "application/octet-stream";

  @header("Content-Length")
  @doc("Size of the response body in bytes")
  @example("1048576")
  contentLength: string;

  @header("Content-Disposition")
  @doc("File attachment information")
  @example("attachment; filename=\"example.pdf\"")
  contentDisposition: string;

  @header("Content-Range")
  @doc("Range of bytes being sent")
  @example("bytes 0-1048575/2097152")
  contentRange?: string;

  @header("ETag")
  @doc("Entity tag for cache validation")
  @example("5e8d1a2b-3c4d-5e6f-7a8b-9c0d1e2f3a4b")
  eTag: string;

  @header("Last-Modified")
  @doc("Last modification timestamp")
  lastModified: utcDateTime;
}

@error
@doc("Standard error response")
model ApiError {
  @doc("Error code")
  @example(500)
  code?: integer;

  @doc("Error message")
  @example("Internal server error occurred")
  message: string;
}

model ErrorResponse<T> {
  ...ApiError;
  ...T;
}

model InternalServerErrorResponse is ErrorResponse<Response<500>>;
model NotFoundErrorResponse is ErrorResponse<NotFoundResponse>;
model ConflictErrorResponse is ErrorResponse<ConflictResponse>;
model BadRequestErrorResponse is ErrorResponse<BadRequestResponse>;
model RangeNotSatisfied is ErrorResponse<Response<416>>;

@doc("User session information containing authentication and profile details")
model Session {
  @doc("User's display name or full name")
  @example("John Doe")
  name: string;

  @doc("Telegram username without @ symbol")
  @example("johndoe")
  userName: string;

  @doc("Telegram user ID (unique identifier)")
  @example(123456789)
  @minValue(1)
  userId: int64;

  @doc("Premium subscription status")
  @example(true)
  isPremium: boolean;

  @doc("Session hash for verification and security")
  @example("a1b2c3d4e5f6g7h8i9j0")
  hash: string;

  @doc("Session expiration date")
  expires: utcDateTime;

  @doc("Optional session token for client identification")
  @visibility(Lifecycle.Create)
  session: string;
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

@doc("Supported file categories")
enum Category {
  @doc("Archive files (.zip, .rar, etc)")
  archive,

  @doc("Audio files (.mp3, .wav, etc)")
  audio,

  @doc("Document files (.pdf, .doc, etc)")
  document,

  @doc("Image files (.jpg, .png, etc)")
  image,

  @doc("Other file types")
  other,

  @doc("Video files (.mp4, .mov, etc)")
  video,
}

@doc("File query parameters")
@withOptionalProperties
model FileQuery {
  @query
  @doc("File name filter")
  @example("video.mp4")
  name?: string;

  @query
  @doc("Search query")
  @example("report 2023")
  query?: string;

  @query
  @doc("Search type")
  @example("text")
  searchType?: "text" | "regex" = "text";

  @query
  @doc("File type")
  @example("file")
  type?: "folder" | "file";

  @query
  @doc("File path")
  @example("/documents/2023/")
  path?: string;

  @query
  @doc("Operation")
  @example("list")
  operation?: "list" | "find" = "list";

  @query
  @doc("Enable deep search")
  @example(false)
  deepSearch?: boolean;

  @query
  @doc("Show shared files")
  @example(false)
  shared?: boolean;

  @query
  @doc("Parent folder ID")
  @example("123e4567-e89b-12d3-a456-426614174000")
  parentId?: string;

  @query
  @doc("File category")
  @example(Category.document)
  category?: Category;

  @query
  @doc("Last update time")
  updatedAt?: utcDateTime;

  @query
  @doc("Sort field")
  @example("name")
  sort?: "name" | "updatedAt" | "size" = "name";

  @query
  @doc("Sort order")
  @example("asc")
  order?: "asc" | "desc" = "asc";

  @query
  @doc("Items per page")
  @example(50)
  @maxValue(1000)
  @minValue(1)
  limit?: integer = 500;

  @query
  @doc("Page number")
  @example(1)
  @minValue(1)
  page?: integer = 1;
}

@doc("File part information")
model Part {
  @doc("Part ID")
  @example(1)
  id: integer;

  @doc("Encryption salt")
  @example("abc123")
  salt?: string;
}
@doc("File metadata")
model File {
  @doc("File ID")
  @example("123e4567-e89b-12d3-a456-426614174000")
  @visibility(Lifecycle.Read)
  id?: string;

  @doc("File name")
  @example("document.pdf")
  name: string;

  @doc("File type")
  @example("file")
  type: "folder" | "file";

  @doc("File parts")
  parts?: Part[];

  @doc("MIME type")
  @example("application/pdf")
  mimeType?: string;

  @doc("File category")
  @example(Category.document)
  @visibility(Lifecycle.Read)
  category?: Category;

  @doc("Channel ID")
  @example(123456789)
  channelId?: int64;

  @doc("File path")
  @example("/documents/2023/")
  @visibility(Lifecycle.Create)
  path?: string;

  @doc("Parent folder ID")
  @example("123e4567-e89b-12d3-a456-426614174000")
  parentId?: string;

  @doc("File size in bytes")
  @example(1048576)
  size?: int64;

  @doc("Encryption status")
  @example(false)
  encrypted?: boolean;

  @doc("Last update time")
  @visibility(Lifecycle.Read)
  updatedAt?: utcDateTime;

  @doc("Parent folder path")
  @example("/documents/")
  @visibility(Lifecycle.Read)
  parentPath?: string;
}

@doc("Pagination metadata containing count, page information")
model Meta {
  @doc("Total number of items matching the query")
  @example(1250)
  @minValue(0)
  count?: integer;

  @doc("Total number of available pages based on limit")
  @example(25)
  @minValue(1)
  totalPages?: integer;

  @doc("Current page number in the pagination")
  @example(1)
  @minValue(1)
  currentPage?: integer;
}

@doc("File share creation request")
model FileShareCreate {
  @doc("Share password")
  @example("securepass123")
  password?: string;

  @doc("Share expiration date")
  expiresAt?: utcDateTime;
}

@doc("File sharing information and settings")
model FileShare {
  @doc("Indicates if the shared file requires password protection")
  @example(true)
  protected: boolean;

  @doc("ID of the user who created the share")
  @example(123456789)
  userId?: int64;

  @doc("File type")
  @example("file")
  type: "folder" | "file";

  @doc("Name of the shared file or folder")
  name: string;

  @doc("Expiration date and time of the share link")
  expiresAt?: utcDateTime;
}

@doc("Paginated file listing response with metadata")
model FileList {
  @doc("Array of file entries in the current page")
  @minItems(0)
  @maxItems(1000)
  files: File[];

  @doc("Pagination metadata and total count information")
  meta: Meta;
}

@doc("File update request")
model FileUpdate {
  @doc("File name")
  @example("document.pdf")
  name?: string;

  @doc("File parts")
  parts?: Part[];

  @doc("File size in bytes")
  @example(1048576)
  size?: int64;

  @doc("Last update time")
  updatedAt?: utcDateTime;
}

@doc("File parts update request")
model FilePartsUpdate {
  @doc("Channel ID")
  @example(123456)
  channelId: int64;

  @doc("Upload ID")
  uploadId?: string;

  @doc("File parts")
  parts?: Part[];

  @doc("File size in bytes")
  @example(1048576)
  size: int64;

  @doc("Last update time")
  updatedAt: utcDateTime;
}

@doc("File Copy request")
@example(#{ newName: "document_copy.pdf", destination: "/Documents/2023/" })
model FileCopy {
  @doc("New file name")
  newName?: string;

  @doc("Destination path for the copied file")
  destination: string;
}

model FolderCreate {
  @doc("Directory path to create")
  @example("/Documents/2023/")
  path: string;
}

@doc("Move multiple files by ids or path")
@example(#{
  ids: #["123e4567-e89b-12d3-a456-426614174000"],
  destination: "/Documents/2023/",
})
model FileMove {
  @doc("Array of file or folders ids to be moved")
  ids?: string[];

  @doc("Source path to move files from")
  source?: string;

  @doc("Destination path where files will be moved to")
  destination: string;
}

@doc("Delete operation request")
@example(#{
  ids: #["123e4567-e89b-12d3-a456-426614174000"],
  destination: "/Documents/2023/",
})
model FileDelete {
  @doc("Array of file or folders ids to be deleted")
  ids?: string[];

  @doc("Source file path to be deleted")
  source?: string;

  @doc("Destination path where files will be moved to")
  destination: string;
}

@doc("Request to create directories")
@example(#{ paths: #["/Documents/2023/", "/Documents/2024/"] })
model FileMkDir {
  @doc("Directory path(s) to be created")
  paths: string[];
}

@doc("Statistics for files by category")
@example(#{
  totalFiles: 1250,
  totalSize: 104857600,
  category: Category.document,
})
model CategoryStats {
  @doc("Total number of files")
  totalFiles: int64;

  @doc("Total size of files in bytes")
  totalSize: int64;

  @doc("Category name")
  category: Category;
}

@route("/files")
@tag("Files")
interface Files {
  @route("")
  @get
  @useAuth(BearerAuth)
  @summary("List all files")
  list(
    ...FileQuery,
  ): FileList | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("")
  @post
  @useAuth(BearerAuth)
  @summary("Create a new file")
  create(...File):
    | {
        ...File;
        @statusCode _: 201;
      }
    | NotFoundErrorResponse
    | ConflictErrorResponse
    | BadRequestErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}")
  @get
  @useAuth(BearerAuth)
  @summary("Get file by ID")
  getById(
    @path id: string,
  ): File | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/{id}")
  @patch
  @useAuth(BearerAuth)
  @summary("Update file")
  update(@path id: string, @body body: FileUpdate):
    | File
    | NotFoundErrorResponse
    | ConflictErrorResponse
    | BadRequestErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/parts")
  @put
  @useAuth(BearerAuth)
  @summary("Update file parts")
  updateParts(@path id: string, @body body: FilePartsUpdate):
    | NoContentResponse
    | NotFoundErrorResponse
    | BadRequestErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/share")
  @delete
  @useAuth(BearerAuth)
  @summary("Delete share")
  deleteShare(
    @path id: string,
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @get
  @useAuth(BearerAuth)
  @summary("Get share by file ID")
  shareByid(
    @path id: string,
  ): FileShare | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @patch
  @useAuth(BearerAuth)
  @summary("Edit share")
  editShare(
    @path id: string,
    @bodyRoot body: FileShareCreate,
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/{id}/share")
  @post
  @useAuth(BearerAuth)
  @summary("Create a share for the file")
  createShare(
    @path id: string,
    @body body: FileShareCreate,
  ): CreatedResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/{id}/copy")
  @post
  @useAuth(BearerAuth)
  @summary("Copy file")
  copy(@path id: string, @body body: FileCopy):
    | File
    | NotFoundErrorResponse
    | BadRequestErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/stream/{name}")
  @get
  @summary("Stream file by ID")
  stream(@path id: string, @path name: string, @query hash?: string):
    | FileStream
    | RangeNotSatisfied
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/download/{name}")
  @get
  @summary("Download file by ID")
  download(@path id: string, @path name: string, @query hash?: string):
    | FileStream
    | RangeNotSatisfied
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/delete")
  @post
  @useAuth(BearerAuth)
  @summary("Delete files")
  delete(
    @body body: FileDelete,
  ): NoContentResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/move")
  @post
  @useAuth(BearerAuth)
  @summary("Move files")
  move(
    @body body: FileMove,
  ): NoContentResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/mkdir")
  @post
  @useAuth(BearerAuth)
  @summary("Create Folders")
  mkdir(
    @body body: FileMkDir,
  ): NoContentResponse | BadRequestErrorResponse | InternalServerErrorResponse;

  @route("/categories")
  @get
  @useAuth(BearerAuth)
  @summary("Get category stats")
  categoryStats(): CategoryStats[] | InternalServerErrorResponse;
}

@doc("Query parameters for file upload")
@example(#{
  partName: "part1",
  fileName: "document.pdf",
  partNo: 1,
  channelId: 123456789,
  encrypted: false,
})
model UploadQuery {
  @doc("Name of the part being uploaded")
  @query
  partName: string;

  @doc("Original file name")
  @query
  fileName: string;

  @doc("Part number in sequence")
  @query
  partNo: integer;

  @doc("Optional channel identifier for upload")
  @query
  channelId?: int64;

  @doc("Whether the upload content is encrypted")
  @query
  encrypted?: boolean = false;
}

@doc("Details of an uploaded part")
model UploadPart {
  @doc("Name identifier of the part")
  name: string;

  @doc("Telegram Message ID")
  partId: integer;

  @doc("Sequential number of the part")
  partNo: integer;

  @doc("Channel identifier associated with the upload")
  channelId: int64;

  @doc("Size of the part in bytes")
  size: int64;

  @doc("Indicates if the part is encrypted")
  encrypted: boolean;

  @doc("Salt value used for encryption, required if encrypted is true")
  salt?: string;
}

@doc("Statistics about the upload")
model UploadStats {
  @doc("Date and time when the upload occurred")
  uploadDate: utcDateTime;

  @doc("Total number of bytes uploaded")
  totalUploaded: int64;
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

@doc("User session information")
@example(#{
  hash: "a1b2c3d4e5f6g7h8i9j0",
  createdAt: "2023-10-21T07:28:00Z",
  location: "New York, USA",
  officialApp: true,
  appName: "Telegram",
  valid: true,
  current: true,
})
model UserSession {
  @doc("Unique hash identifier for the session")
  hash: string;

  @doc("Session creation timestamp")
  @format("date-time")
  createdAt: string;

  @doc("Geographic location where session was created")
  location?: string;

  @doc("Indicates if session is from an official Telegram app")
  officialApp?: boolean;

  @doc("Name of the application used for session")
  appName?: string;

  @doc("Indicates if the session is still valid")
  valid: boolean;

  @doc("Indicates if this is the currently active session")
  current: boolean;
}

@doc("Telegram channel information")
@example(#{ channelName: "Channel Name", channelId: 123456789 })
model Channel {
  @doc("Name of the Telegram channel")
  channelName: string;

  @doc("Unique numeric identifier of the channel")
  channelId: int64;
}

model AddBots {
  @doc("List of bot tokens")
  bots: string[];
}

@doc("User configuration for channel and bot settings")
@example(#{ channelId: 123456789, bots: #["bot1", "bot2"] })
model UserConfig {
  @doc("Channel identifier associated with the user")
  channelId: int64;

  @doc("List of bot tokens")
  bots: string[];
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
  stats(): UserConfig | InternalServerErrorResponse;

  @route("/channels")
  @get
  @summary("List user channels")
  listChannels(): Channel[] | InternalServerErrorResponse;

  @route("/channels")
  @patch
  @summary("Update user channel")
  updateChannel(
    @body body: Channel,
  ): NoContentResponse | InternalServerErrorResponse;

  @route("/sessions")
  @get
  @summary("List user sessions")
  listSessions(): UserSession[] | InternalServerErrorResponse;

  @route("/bots")
  @post
  @summary("Add bots to user account")
  addBots(
    @body body: AddBots,
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
  listFiles(
    @path id: string,
  ): FileList | NotFoundErrorResponse | InternalServerErrorResponse;

  @route("/{id}/files/{fileId}/stream/{name}")
  @get
  @summary("Stream shared file")
  streamFile(@path id: string, @path fileId: string, @path name: string):
    | FileStream
    | RangeNotSatisfied
    | NotFoundErrorResponse
    | InternalServerErrorResponse;

  @route("/{id}/files/{fileId}/download/{name}")
  @get
  @summary("Download shared file")
  downloadFile(@path id: string, @path fileId: string, @path name: string):
    | FileStream
    | RangeNotSatisfied
    | NotFoundErrorResponse
    | InternalServerErrorResponse;
}

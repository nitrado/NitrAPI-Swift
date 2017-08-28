import ObjectMapper

open class FileEntry: Mappable {
    
    public enum FileType: String {
        /// This entry is a file.
        case FILE = "file"
        /// This entry is a directory.
        case DIR = "dir"
    }
    
    // MARK: - Attributes
    
    open fileprivate(set) var type: FileType?
    open fileprivate(set) var path: String?
    open fileprivate(set) var name: String?
    open fileprivate(set) var size: Int?
    open fileprivate(set) var owner: String?
    open fileprivate(set) var group: String?
    /// Access rights of this file in chmod notation.
    open fileprivate(set) var chmod: String?
    open fileprivate(set) var createdAt: Int? // TODO: change these to date someday?
    open fileprivate(set) var modifiedAt: Int?
    open fileprivate(set) var accessedAt: Int?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    public init (name: String, path: String) {
        self.name = name
        self.path = path
        self.type = .DIR
    }
    
    open func mapping(map: Map) {
        type        <- (map["type"], EnumTransform<FileType>())
        path        <- map["path"]
        name        <- map["name"]
        size        <- map["size"]
        owner       <- map["owner"]
        group       <- map["group"]
        chmod       <- map["chmod"]
        createdAt   <- map["created_at"]
        modifiedAt  <- map["modified_at"]
        accessedAt  <- map["accessed_at"]
    }
    
    
}

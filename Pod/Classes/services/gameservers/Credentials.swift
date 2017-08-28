import ObjectMapper

/// Credentials for a MySQL or FTP-Service
open class Credentials: Mappable {
    
    // MARK: - Attributes
    
    open fileprivate(set) var hostname: String?
    open fileprivate(set) var port: Int?
    open fileprivate(set) var username: String?
    open fileprivate(set) var password: String?
    /// Database for MySQL-databases
    open fileprivate(set) var database: String?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        hostname    <- map["hostname"]
        port        <- map["port"]
        username    <- map["username"]
        password    <- map["password"]
        database    <- map["database"]
    }
    
    
}

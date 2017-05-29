import ObjectMapper

open class Logs: Mappable {
    
    /// An entry in the server log.
    open class LogEntry: Mappable {
        
        // MARK: - Attributes
        
        open fileprivate(set) var user: String!
        open fileprivate(set) var category: String!
        open fileprivate(set) var message: String!
        open fileprivate(set) var createdAt: Date!
        open fileprivate(set) var ip: String!
        open fileprivate(set) var admin: Bool!
        
        // MARK: - Initialization
        public required init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            user        <- map["user"]
            category    <- map["category"]
            message     <- map["message"]
            createdAt   <- (map["created_at"], Nitrapi.dft)
            ip          <- map["ip"]
            admin       <- map["admin"]
        }
        
        
    }
    
    
    
    
    // MARK: - Attributes
    
    open fileprivate(set) var currentPage: Int!
    open fileprivate(set) var logsPerPage: Int!
    open fileprivate(set) var pageCount: Int!
    open fileprivate(set) var logCount: Int!
    open fileprivate(set) var logs: [LogEntry]!
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        currentPage <- map["current_page"]
        logsPerPage <- map["logs_per_page"]
        pageCount   <- map["page_count"]
        logCount    <- map["log_count"]
        logs        <- map["logs"]
    }
}



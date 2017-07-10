import ObjectMapper

/// This class represents an AccessToken.
open class AccessToken: Mappable {
    
    /// Returns user.
    open fileprivate(set) var user: User?
    /// Returns expiresAt.
    open fileprivate(set) var expiresAt: Int?
    /// Returns validUntil.
    open fileprivate(set) var validUntil: Date?
    /// Returns scopes.
    open fileprivate(set) var scopes: [String]?
    /// Returns employee.
    open fileprivate(set) var employee: Bool?
    
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        user <- map["user"]
        expiresAt <- map["expires_at"]
        validUntil <- (map["valid_until"], Nitrapi.dft)
        scopes <- map["scopes"]
        employee <- map["employee"]
    }
    
    /// This class represents an user.
    open class User: Mappable {
        /// Returns id.
        open fileprivate(set) var id: Int?
        /// Returns username.
        open fileprivate(set) var username: String?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            id <- map["id"]
            username <- map["username"]
        }
    }
}

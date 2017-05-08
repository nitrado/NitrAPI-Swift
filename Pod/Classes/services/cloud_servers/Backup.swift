import ObjectMapper

/// This class represents a Backup.
open class Backup: Mappable {
    
    /// Returns id.
    open fileprivate(set) var id: String!
    /// Returns name.
    open fileprivate(set) var name: String!
    /// Returns createdAt.
    open fileprivate(set) var createdAt: Date!
    /// TODO enum
    open fileprivate(set) var type: String!
    /// Returns setId.
    open fileprivate(set) var setId: String!
    /// TODO enum
    open fileprivate(set) var status: String!
    
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        createdAt <- (map["created_at"], Nitrapi.dft)
        type <- map["type"]
        setId <- map["set_id"]
        status <- map["status"]
    }
    
}

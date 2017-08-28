import ObjectMapper

open class RemoteToolkit: Mappable {
    
    // MARK: - Attributes
    open fileprivate(set) var enabled: Bool?
    open fileprivate(set) var username: String?
    open fileprivate(set) var password: String?
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        enabled     <- map["enabled"]
        username    <- map["username"]
        password    <- map["password"]
    }
    
}

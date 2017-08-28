import ObjectMapper

open class McMyAdmin: Mappable {
    
    // MARK: - Attributes
    open fileprivate(set) var enabled: Bool?
    open fileprivate(set) var url: String?
    open fileprivate(set) var username: String?
    open fileprivate(set) var password: String?
    open fileprivate(set) var language: String?
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        enabled     <- map["enabled"]
        url         <- map["url"]
        username    <- map["username"]
        password    <- map["password"]
        language    <- map["language"]
    }
    
    
}

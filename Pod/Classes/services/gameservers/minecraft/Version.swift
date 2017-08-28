import ObjectMapper

open class Version: Mappable {
    
    // MARK: - Attributes
    open fileprivate(set) var version: String?
    open fileprivate(set) var name: String?
    open fileprivate(set) var md5: String?
    open fileprivate(set) var installed: Bool?
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        version     <- map["version"]
        name        <- map["name"]
        md5         <- map["md5"]
        installed   <- map["installed"]
    }
    
    
}

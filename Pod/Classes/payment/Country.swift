import ObjectMapper

open class Country: Mappable, CustomStringConvertible {
    open fileprivate(set) var isoCode: String?
    open fileprivate(set) var name: String?
    
    public required init?(map: Map) {
    }
    
    open func mapping(map: Map) {
        isoCode <- map["short"]
        name    <- map["name"]
    }
    open var description: String {
        return name ?? ""
    }
}

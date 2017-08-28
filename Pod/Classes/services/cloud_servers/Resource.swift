import ObjectMapper

/// This class represents a Resource.
open class Resource: Mappable {
    
    /// Returns type.
    open fileprivate(set) var type: String?
    /// Returns datapoints.
    open fileprivate(set) var datapoints: [String: Float]?
    
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        type <- map["type"]
        datapoints <- map["datapoints"]
    }
    
}

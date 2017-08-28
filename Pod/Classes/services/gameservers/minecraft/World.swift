import ObjectMapper

open class World: Mappable {
    
    // MARK: - Attributes
    open fileprivate(set) var game: String?
    open fileprivate(set) var world: String?
    open fileprivate(set) var timestamp: Int?
    open fileprivate(set) var size: Int?
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        game        <- map["game"]
        world       <- map["world"]
        timestamp   <- map["timestamp"]
        size        <- map["size"]
    }
    
    
}

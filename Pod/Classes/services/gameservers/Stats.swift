import ObjectMapper

open class Stats: Mappable {
    
    // MARK: - Attributes
    
    open fileprivate(set) var currentPlayers: [[Int?]]?
    open fileprivate(set) var cpuUsage: [[Int?]]?
    open fileprivate(set) var memoryUsage: [[Int?]]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        currentPlayers  <- map["currentPlayers"]
        cpuUsage        <- map["cpuUsage"]
        memoryUsage     <- map["memoryUsage"]
    }
    
    
}

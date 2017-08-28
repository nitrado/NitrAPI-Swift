import ObjectMapper

open class GameList: Mappable {
    
    // MARK: - Attributes
    open fileprivate(set) var currentlyInstalled: Int?
    open fileprivate(set) var maximumInstalled: Int?
    /// List of all games.
    open fileprivate(set) var games: [Game]!
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        currentlyInstalled  <- map["installed_currently"]
        maximumInstalled    <- map["installed_maximum"]
        games               <- map["games"]
    }
    
    
}

import ObjectMapper

open class GlobalGameList: Mappable {
    
    open class Location: Mappable {
        open fileprivate(set) var id: Int?
        open fileprivate(set) var country: String?
        open fileprivate(set) var city: String?
        public required init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            id      <- map["id"]
            country <- map["country"]
            city    <- map["city"]
        }
        
    }
    
    // MARK: - Attributes
    open fileprivate(set) var steamId: String?
    open fileprivate(set) var locations: [Location]?

    /// List of all games.
    open fileprivate(set) var games: [Game]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        steamId     <- map["steam_id"]
        locations   <- map["locations"]
        games       <- map["games"]
    }
    
    
}

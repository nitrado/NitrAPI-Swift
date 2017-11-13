import ObjectMapper

open class Location: Mappable, CustomStringConvertible {
    open fileprivate(set) var id: Int!
    open fileprivate(set) var country: String?
    open fileprivate(set) var city: String?
    open fileprivate(set) var bouncer: Bool?
    open fileprivate(set) var cloudServer: Bool?
    open fileprivate(set) var cloudServerDynamic: Bool?
    open fileprivate(set) var gameserver: Bool?
    open fileprivate(set) var mumble: Bool?
    open fileprivate(set) var musicbot: Bool?
    open fileprivate(set) var teamspeak3: Bool?
    open fileprivate(set) var ventrilo: Bool?
    open fileprivate(set) var webspace: Bool?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        id          <- map["id"]
        country     <- map["country"]
        city        <- map["city"]
        bouncer     <- map["products.bouncer"]
        cloudServer <- map["products.cloud_server"]
        cloudServerDynamic <- map["products.cloud_server_dynamic"]
        gameserver  <- map["products.gameserver"]
        mumble      <- map["products.mumble"]
        musicbot    <- map["products.musicbot"]
        teamspeak3  <- map["products.teamspeak3"]
        ventrilo    <- map["products.ventrilo"]
        webspace    <- map["products.webspace"]
    }
    
    open func hasService(_ type: String) -> Bool {
        switch (type) {
            case "bouncer":
                return bouncer ?? false
            case "cloud_server":
                return cloudServer ?? false
            case "cloud_server_dynamic":
                return cloudServerDynamic ?? false
            case "gameserver":
                return gameserver ?? false
            case "mumble":
                return mumble ?? false
            case "musicbot":
                return musicbot ?? false
            case "teamspeak3":
                return teamspeak3 ?? false
            case "ventrilo":
                return ventrilo ?? false
            case "webspace":
                return webspace ?? false
            default:
                return false
        }
    }
    
    open var description: String {
        return "\(city ?? "") (\(country ?? ""))"
    }
}

import ObjectMapper

/// The query of a gameserver.
open class Query: Mappable {
    
    /// A Player on a gameserver.
    open class Player: Mappable {
        open fileprivate(set) var id: Int?
        open fileprivate(set) var name: String?
        /// Is this player a bot?
        open fileprivate(set) var bot: Bool?
        open fileprivate(set) var score: Int?
        open fileprivate(set) var frags: Int?
        open fileprivate(set) var deaths: Int?
        /// Time the player has spend on the server in seconds.
        open fileprivate(set) var time: Int?
        open fileprivate(set) var ping: Int?
        
        public required init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            id      <- map["id"]
            name    <- map["name"]
            bot     <- map["bot"]
            score   <- map["score"]
            frags   <- map["frags"]
            deaths  <- map["deaths"]
            time    <- map["time"]
            ping    <- map["ping"]
        }
    }
    
    // MARK: - Attributes
    
    
    open fileprivate(set) var serverName: String?
    /// IP and Port used to connect to this server.
    open fileprivate(set) var connectIp: String?
    open fileprivate(set) var map: String?
    open fileprivate(set) var version: String?
    open fileprivate(set) var playerCurrent: Int?
    open fileprivate(set) var playerMax: Int?
    /// List of the players currently on this server.
    open fileprivate(set) var players: [Player]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        serverName      <- map["server_name"]
        connectIp       <- map["connect_ip"]
        self.map        <- map["map"]
        version         <- map["version"]
        playerCurrent   <- map["player_current"]
        playerMax       <- map["player_max"]
        players         <- map["players"]
    }
    
    open func update(_ query: Query) {
        if let serverName = query.serverName {
            self.serverName = serverName
        }
        if let connectIp = query.connectIp {
            self.connectIp = connectIp
        }
        if let version = query.version {
            self.version = version
        }
        if let playerCurrent = query.playerCurrent {
            self.playerCurrent = playerCurrent
        }
        if let playerMax = query.playerMax {
            self.playerMax = playerMax
        }
        if let players = query.players {
            self.players = players
        }
    }
    
    
}

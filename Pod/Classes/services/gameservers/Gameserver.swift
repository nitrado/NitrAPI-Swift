import ObjectMapper

open class Gameserver: Service {
    /// Represents the type of the gameserver
    public enum GameserverType: String {
        case GAMESERVER = "Gameserver"
        case GAMESERVER_BASIC = "Gameserver_Basic"
        case GAMESERVER_EPS = "Gameserver_EPS"
    }
    
    /// Represents the type of memory of a gameserver
    public enum MemoryType: String {
        case STANDARD = "Standard"
        case ADVANCES = "Advanced"
        case PROFESSIONAL = "Proressional"
        case ULTIMATE = "Ultimate"
    }
    
    /// Represents the status of the gameserver
    public enum GameserverStatus: String {
        /// Will be returned if the gameserver is currently running.
        case STARTED = "started"
        /// The server is currently stopped.
        case STOPPED = "stopped"
        /// The server will be stopped now.
        case STOPPING = "stopping"
        /// The server is currently performing a restart.
        case RESTARTING = "restarting"
        /// Will be returned if the server is suspended, which means it needs to be reactivated on the website.
        case SUSPENDED = "suspended"
        /// If your services are guardian protected, you are currently outside of the allowed times.
        case GUARDIAN_LOCKED = "guardian_locked"
        /// The server is currently performing a game switching action.
        case GS_INSTALLATION = "gs_installation"
        /// A backup will be restored now.
        case BACKUP_RESTORE = "backup_restore"
        /// A new backup will be created now.
        case BACKUP_CREATION = "backup_creation"
        /// The server is running a chunkfix. (only available for Minecraft)
        case CHUNKFIX = "chunkfix"
        /// The server is currently rendering the overviewmap. (only available for Minecraft)
        case OVERVIEWMAP_RENDER = "overviewmap_render"
        /// The host of this gameserver is currently unreachable.
        case HOST_DOWN = "hostdown"
    }
    
    // MARK: - Attributes

    open internal(set) var gameserverStatus: GameserverStatus!
    /// Token you need to connect to the websocket.
    open fileprivate(set) var websocketToken: String!
    /// Is this server in minecraft mode?
    open fileprivate(set) var minecraftMode: Bool!
    open fileprivate(set) var ip: String!
    open fileprivate(set) var port: Int!
    /// Label of this gameserver.
    /// You need the label to connect to the websocket.
    open fileprivate(set) var label: String!
    open fileprivate(set) var gameserverType: GameserverType!
    open fileprivate(set) var memory: MemoryType!
    open fileprivate(set) var memoryTotal: Int!
    open fileprivate(set) var game: String?
    open fileprivate(set) var gameReadable: String!
    open fileprivate(set) var modpacks: [String: Modpack]!
    open fileprivate(set) var slots: Int!
    open fileprivate(set) var location: String!
    open fileprivate(set) var credentials: [String: Credentials]!
    open fileprivate(set) var settings: [String: [String: String]]!
    open fileprivate(set) var quota: Quota!
    open fileprivate(set) var query: Query!
    
    // game specific
    open fileprivate(set) var path: String?
    open fileprivate(set) var pathAvailable: Bool?
    open fileprivate(set) var hasBackups: Bool!
    open fileprivate(set) var hasApplicationServer: Bool!
    open fileprivate(set) var hasFileBrowser: Bool!
    open fileprivate(set) var hasFtp: Bool!
    open fileprivate(set) var hasExpertMode: Bool!
    open fileprivate(set) var hasPluginSystem: Bool!
    open fileprivate(set) var hasRestartMessageSupport: Bool!
    open fileprivate(set) var hasDatabase: Bool!
    open fileprivate(set) var logFiles: [String]!
    open fileprivate(set) var configFiles: [String]!
    

    /// Inner class to fill the new infomation into the parent object
    class GameserverInfo: Mappable {
        weak var parent: Gameserver!
        // MARK: - Initialization
        init() {
        }
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            parent.ip                           <-  map["ip"]
            parent.gameserverStatus             <- (map["status"], EnumTransform<GameserverStatus>())
            parent.websocketToken               <-  map["websocket_token"]
            parent.minecraftMode                <-  map["minecraft_mode"]
            parent.port                         <-  map["port"]
            parent.label                        <-  map["label"]
            parent.gameserverType               <- (map["type"], EnumTransform<GameserverType>())
            parent.memory                       <- (map["memory"], EnumTransform<MemoryType>())
            parent.memoryTotal                  <-  map["memory_total"]
            parent.game                         <-  map["game"]
            parent.gameReadable                 <-  map["game_human"]
            parent.modpacks                     <-  map["modpacks"]
            parent.slots                        <-  map["slots"]
            parent.location                     <-  map["location"]
            parent.credentials                  <-  map["credentials"]
            parent.settings                     <-  map["settings"]
            parent.quota                        <-  map["quota"]
            parent.query                        <-  map["query"]
            parent.path                         <-  map["game_specific.path"]
            parent.pathAvailable                <-  map["game_specific.path_available"]
            parent.hasBackups                   <-  map["game_specific.features.has_backups"]
            parent.hasApplicationServer         <-  map["game_specific.features.has_application_server"]
            parent.hasFileBrowser               <-  map["game_specific.features.has_file_browser"]
            parent.hasFtp                       <-  map["game_specific.features.has_ftp"]
            parent.hasExpertMode                <-  map["game_specific.features.has_expert_mode"]
            parent.hasPluginSystem              <-  map["game_specific.features.has_plugin_system"]
            parent.hasRestartMessageSupport     <-  map["game_specific.features.has_restart_message_support"]
            parent.hasDatabase                  <-  map["game_specific.features.database"]
            parent.logFiles                     <-  map["game_specific.log_files"]
            parent.configFiles                  <-  map["game_specific.config_files"]
        }
    }
    
    open func isMinecraftGame() -> Bool {
        if let game = game {
            return game.hasPrefix("mcr") && game != "mcrpocket" // mcr pocket has no minecraft features
        }
        return false
    }
    
    
    
    
    // MARK: - Actions
    
    open func doRestart() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/restart", parameters: ["message": "Server restart requested (iOS app)"])
    }
    
    open func doStop() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/stop", parameters: ["message": "Server stop requested (iOS app)"])
    }
    
    open func doRestart(message: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/restart", parameters: ["restart_message": message, "message": "Server restart requested (iOS app)"])
    }

    open func doStop(message: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/stop", parameters: ["stop_message": message, "message": "Server stop requested (iOS app)"])
    }
    
 
    
    open func changeFTPPassword(_ password: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/ftp/password", parameters: ["password": password])
    }
    
    open func changeMySQLPassword(_ password: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/mysql/password", parameters: ["password": password])
    }
    
    /// Truncates the MySQL database of the gameserver.
    open func resetMySQLDatabase() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/mysql/reset", parameters: [:])
    }
    
    
    // MARK: Gameswitching
    open func getGames() throws -> GameList? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/games", parameters: [:])
        let gamelist =  Mapper<GameList>().map(JSON: data as! [String : Any])
        return gamelist
    }
    
    /// - parameter game: folderShort of the game
    open func installGame (_ game: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/install", parameters: ["game": game])
    }
    
    /// - parameter game: folderShort of the game
    /// - parameter modpack: filename of the modpack
    open func installGame(_ game: String, modpack: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/install", parameters: ["game": game, "modpack": modpack])
    }
    
    /// - parameter game: folderShort of the game
    open func uninstallGame(_ game: String) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/gameservers/games/uninstall", parameters: ["game": game])
    }
    
    /// Starts an already installed game.
    /// - parameter game: folderShort of the game
    open func startGame(_ game: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/start", parameters: ["game": game])
    }
    
    // MARK: Other Modules
    open func getFileServer() -> FileServer {
        return FileServer(service: self, nitrapi: nitrapi)
    }
    
    open func getPluginSystem() -> PluginSystem {
        return PluginSystem(id: id, nitrapi: nitrapi)
    }
    
    open func getDDoSHistory() throws -> [DDoSAttack]? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/ddos", parameters: [:])
        return Mapper<DDoSAttack>().mapArray(JSONArray: data?["history"] as! [[String : Any]])
    }

    open func getTaskManager() -> TaskManager {
        return TaskManager(id: id, nitrapi: nitrapi)
    }
    
    open func getMinecraft() throws -> Minecraft? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/games/minecraft", parameters: [:])
        let mc = Mapper<Minecraft>().map(JSON: data?["minecraft"] as! [String : Any])
        mc?.postInit(nitrapi, id: id)
        return mc
    }
    
    open func getStats() throws -> Stats? {
        return try getStats(24)
    }
    
    open func getStats(_ hours: Int) throws -> Stats? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/stats", parameters: ["hours": String(hours)])
        return Mapper<Stats>().map(JSON: data?["stats"] as! [String : Any])
    }
    

    
    
    /// You have to ping the application server to send outputs for three minutes to the websocket.
    open func pingAppServer() throws {
        _ = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/app_server", parameters: [:])
    }
    
    /// Sends a command to the server.
    /// Output will be send to the websocket if activated.
    open func sendCommand(_ command: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/app_server/command", parameters: ["command": command])
    }
    
    // MARK: Websockets
    
    open func openWebsocket() {
    
    }
    
    open func closeWebsocket() {
        
    }
    
    
    
    
    open func refresh() throws {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers", parameters: [:])
        let infos = GameserverInfo()
        infos.parent = self
        _ = Mapper<GameserverInfo>().map(JSON: data?["gameserver"] as! [String : Any], toObject: infos)
    }

    
    
    
    // MARK: - Internally Used
    
    /// update the status of this service (if received via websocket)
    open func updateStatus(_ status: GameserverStatus) {
        self.gameserverStatus = status
    }
    
    open func updateQuery(_ query: Query) {
        self.query.update(query)
    }
    
    override func postInit(_ nitrapi: Nitrapi) throws {
        try super.postInit(nitrapi)
        
        if (status == .ACTIVE) {
            try refresh()
        }
    }
    
}

import ObjectMapper

open class Minecraft: Mappable {
    fileprivate var nitrapi: Nitrapi!
    /// service id
    fileprivate var id: Int!
    
    // MARK: - Attributes
    /// Is there a task running and no other task can be started? e.g. overviewmap rendering
    open fileprivate(set) var taskRunning: Bool?
    open fileprivate(set) var currentWorld: String?
    open fileprivate(set) var allWorlds: [World]?
    open fileprivate(set) var worldBackups: [World]?
    open fileprivate(set) var binaryMD5: String?
    open fileprivate(set) var binary: String?
    open fileprivate(set) var overviewmap: Overviewmap?
    open fileprivate(set) var mcmyadmin: McMyAdmin?
    open fileprivate(set) var bungeecord: BungeeCord?
    open fileprivate(set) var remoteToolkit: RemoteToolkit?
    open fileprivate(set) var versions: [Version]?
    
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        taskRunning     <- map["task_running"]
        currentWorld    <- map["current_world"]
        allWorlds       <- map["all_worlds"]
        worldBackups    <- map["world_backups"]
        binaryMD5       <- map["binary_md5"]
        binary          <- map["binary"]
        overviewmap     <- map["overviewmap"]
        mcmyadmin       <- map["mcmyadmin"]
        bungeecord      <- map["bungeecord"]
        remoteToolkit   <- map["rtk"]
        versions        <- map["versions"]
    }
    
    // MARK: - Actions
    open func changeBungeeCord(_ enabled: Bool, only: Bool, firewall: BungeeCord.FirewallStatus, firewallIp: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/bungeecord", parameters: [
            "enabled": (enabled ? "1":"0"),
            "only": (only ?"1":"0"),
            "firewall": firewall.rawValue,
            "firewall_ip": firewallIp
            ])
    }
    
    open func doChunkfix(_ world: String, limit: Int) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/chunkfix", parameters: [
            "world": world,
            "limit": String(limit)
            ])
    }
    
    open func changeMcMyAdmin(_ enabled: Bool, username: String, password: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/mcmyadmin", parameters: [
            "enabled" : (enabled ? "1":"0"),
            "username": username,
            "password": password
            ])
    }
    
    open func changeRemoteToolkit(_ enabled: Bool, username: String, password: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/rtk", parameters: [
            "enabled" : (enabled ? "1":"0"),
            "username": username,
            "password": password
            ])
    }
    
    open func changeOverviewMap(_ enabled: Bool, signs: Bool, reset: Bool, ipsonly: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/overviewmap", parameters: [
            "enabled": (enabled ? "1":"0"),
            "signs": (signs ?"1":"0"),
            "reset": (reset ?"1":"0"),
            "ipsonly": ipsonly
            ])
    }
    
    open func renderOverviewMap() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/overviewmap_render", parameters: [:])
    }
    
    open func getOverviewMapLogs() throws -> String? {
        return try nitrapi.client.dataGet("services/\(id as Int)/gameservers/games/minecraft/overviewmap_log", parameters: [:])?["log"] as? String
    }
    
    open func changeVersion(_ md5: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/change_version", parameters: [
            "md5": md5
            ])
    }
    
    open func getUserUUID(_ username: String) throws -> String? {
        
        
        return (try nitrapi.client.dataGet("services/\(id as Int)/gameservers/games/minecraft/uuid", parameters: ["username": username])?["user"] as? [String: Any])?["uuid"] as? String
    }
    
    open func getUserAvatar(_ username: String) throws -> String? {
        return (try nitrapi.client.dataGet("services/\(id as Int)/gameservers/games/minecraft/avatar", parameters: ["username": username])?["user"] as? [String: Any])?["avatar"] as? String
    }
    
    open func getPlugins() throws -> [Plugin]? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/plugins", parameters: [:])
        return Mapper<Plugin>().mapArray(JSONArray: data?["plugins"] as! [[String : Any]])
    }
    
    // MARK: - Backup specific
    open func createBackup(_ world: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/backup", parameters: [
            "world": world
            ])
    }
    
    open func restoreBackup(_ timestamp: Int) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/games/minecraft/backup/\(timestamp)/restore", parameters: [:])
    }
    
    open func destroyBackup(_ timestamp: Int) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/gameservers/games/minecraft/backup/\(timestamp)", parameters: [:])
    }
    
    
    // MARK: - Internally Used
    func postInit(_ nitrapi: Nitrapi, id: Int) {
        self.nitrapi = nitrapi
        self.id = id
    }
}

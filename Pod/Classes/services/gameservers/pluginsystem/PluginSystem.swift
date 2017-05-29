import ObjectMapper

open class PluginSystem {
    
    fileprivate var nitrapi: Nitrapi!
    /// service id
    fileprivate var id: Int!

    // MARK: - Initialization
    public required init(id: Int, nitrapi: Nitrapi) {
        self.id = id
        self.nitrapi = nitrapi
    }
    
    // MARK: - Getters
    
    open func info() throws -> PluginSystemInfo? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/plugin_system/info", parameters: [:])
        return Mapper<PluginSystemInfo>().map(JSON: data as! [String : Any])
    }
    
    // MARK: - Actions
    
    open func doInstall() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/plugin_system/install", parameters: [:])
    }
    
    open func doUninstall() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/plugin_system/uninstall", parameters: [:])
    }
    
    open func doRestart() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/plugin_system/restart", parameters: [:])
    }

    open func doStop() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/plugin_system/stop", parameters: [:])
    }

}

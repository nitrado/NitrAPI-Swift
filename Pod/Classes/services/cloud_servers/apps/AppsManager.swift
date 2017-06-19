import ObjectMapper

/// This class represents an AppsManager.
open class AppsManager: Mappable {
    fileprivate var nitrapi: Nitrapi!
    fileprivate var id: Int!
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
    }
    
    /// This class represents an App.
    open class App: Mappable {
        /// Returns appName.
        open fileprivate(set) var appName: String?
        /// Returns appType.
        open fileprivate(set) var appType: String?
        /// Returns description.
        open fileprivate(set) var description: String?
        /// Returns tODO enum?.
        open fileprivate(set) var status: String?
        /// Returns systemdPath.
        open fileprivate(set) var systemdPath: String?
        /// Returns systemdConfig.
        open fileprivate(set) var systemdConfig: String?
        /// Returns systemdModified.
        open fileprivate(set) var systemdModified: Bool?
        /// Returns cmd.
        open fileprivate(set) var cmd: String?
        /// Returns parsedCmd.
        open fileprivate(set) var parsedCmd: String?
        /// Returns parameters.
        open fileprivate(set) var parameters: [String: String]?
        /// Returns configurations.
        open fileprivate(set) var configurations: [String: String]?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            appName <- map["app_name"]
            appType <- map["app_type"]
            description <- map["description"]
            status <- map["status"]
            systemdPath <- map["systemd_path"]
            systemdConfig <- map["systemd_config"]
            systemdModified <- map["systemd_modified"]
            cmd <- map["cmd"]
            parsedCmd <- map["parsed_cmd"]
            parameters <- map["parameters"]
            configurations <- map["configurations"]
        }
    }
    
    /// This class represents a Port.
    open class Port: Mappable {
        /// Returns name.
        open fileprivate(set) var name: String?
        /// Returns description.
        open fileprivate(set) var description: String?
        /// Returns recommended.
        open fileprivate(set) var recommended: Int?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            name <- map["name"]
            description <- map["description"]
            recommended <- map["recommended"]
        }
    }
    
    /// This class represents an AppDescription.
    open class AppDescription: Mappable {
        /// Returns appType.
        open fileprivate(set) var appType: String?
        /// Returns category.
        open fileprivate(set) var category: String?
        /// Returns description.
        open fileprivate(set) var description: String?
        /// Returns supportsIpBinding.
        open fileprivate(set) var supportsIpBinding: Bool?
        /// Returns ports.
        open fileprivate(set) var ports: [Port]?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            appType <- map["app_type"]
            category <- map["category"]
            description <- map["description"]
            supportsIpBinding <- map["supports_ip_binding"]
            ports <- map["ports"]
        }
    }
    
    /// Returns the list of installed apps.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - returns: [App]
    open func getInstalledApps() throws -> [App]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/apps/", parameters: [:])
        
        let apps = Mapper<App>().mapArray(JSONArray: data?["apps"] as! [[String : Any]])
        return apps
    }
    
    /// Returns a list of available apps.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - returns: [AppDescription]
    open func getAvailableApps() throws -> [AppDescription]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/apps/available", parameters: [:])
        
        let apps = Mapper<AppDescription>().mapArray(JSONArray: data?["apps"] as! [[String : Any]])
        return apps
    }
    
    /// Installs an app.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - parameter appType: Valid application type from available list.
    /// - parameter appName: Name for the new application, only /^[a-zA-Z0-9\_]{1,16}$/ allowed.
    /// - parameter ports: ports
    open func install(_ appType: String, appName: String, ports: [String: String]) throws {
        var params = [
            "app_type": String(describing: appType),
            "app_name": String(describing: appName)
        ]
        
        for (key, value) in ports {
            params["ports[\(key)"] = value
        }
        
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/apps/", parameters: params)
    }
    
    /// Uninstalls the application.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - parameter appName: appName
    open func uninstall(_ appName: String) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/cloud_servers/apps/\(appName)", parameters: [:])
    }
    
    /// Configures the application.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - parameter appName: appName
    /// - parameter cmd: the application start command line
    /// - parameter parameters: parameters
    open func configure(_ appName: String, cmd: String, parameters: [String: String]) throws {
        var params = [
            "cmd": String(describing: cmd),
        ]
        for (key, value) in parameters {
            params["parameters[\(key)]"] = value
        }

        _ = try nitrapi.client.dataPut("services/\(id as Int)/cloud_servers/apps/\(appName)", parameters: params)
    }
    
    /// Installs the latest application version on your server.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - parameter appName: appName
    open func update(_ appName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/apps/\(appName)/update", parameters: [:])
    }
    
    /// Restarts the application.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - parameter appName: appName
    open func restart(_ appName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/apps/\(appName)/restart", parameters: [:])
    }
    
    /// Stopps the application.
    /// needs permission ROLE_WEBINTERFACE_GENERAL_CONTROL
    /// - parameter appName: appName
    open func stop(_ appName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/apps/\(appName)/stop", parameters: [:])
    }
    
    // MARK: - Internally used
    func postInit(_ nitrapi: Nitrapi, id: Int) {
        self.nitrapi = nitrapi
        self.id = id
    }
}

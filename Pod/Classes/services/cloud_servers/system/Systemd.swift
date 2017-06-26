import ObjectMapper

/// This class represents a Systemd.
open class Systemd: Mappable {
    fileprivate var nitrapi: Nitrapi!
    fileprivate var id: Int!
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
    }
    
    /// This class represents an Unit.
    open class Unit: Mappable {
        /// Returns objectPath.
        open fileprivate(set) var objectPath: String?
        /// Returns unitState.
        open fileprivate(set) var unitState: String?
        /// Returns description.
        open fileprivate(set) var description: String?
        /// Returns jobId.
        open fileprivate(set) var jobId: Int?
        /// Returns loadState.
        open fileprivate(set) var loadState: String?
        /// Returns filename.
        open fileprivate(set) var filename: String?
        /// Returns jobType.
        open fileprivate(set) var jobType: String?
        /// Returns jobObjectPath.
        open fileprivate(set) var jobObjectPath: String?
        /// Returns name.
        open fileprivate(set) var name: String?
        /// Returns todo enum.
        open fileprivate(set) var activeState: String?
        /// Returns todo enum.
        open fileprivate(set) var subState: String?
        /// Returns leader.
        open fileprivate(set) var leader: String?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            objectPath <- map["object_path"]
            unitState <- map["unit_state"]
            description <- map["description"]
            jobId <- map["job_id"]
            loadState <- map["load_state"]
            filename <- map["filename"]
            jobType <- map["job_type"]
            jobObjectPath <- map["job_object_path"]
            name <- map["name"]
            activeState <- map["active_state"]
            subState <- map["sub_state"]
            leader <- map["leader"]
        }
    }
    
    /// Lists all the units Systemd manages.
    /// - returns: [Unit]
    open func getUnits() throws -> [Unit]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/system/units/", parameters: [:])
        
        let units = Mapper<Unit>().mapArray(JSONArray: data?["units"] as! [[String : Any]])
        return units
    }
    
    /// Returns a SSE (server-send event) stream URL, which will stream changes on the Systemd services.
    /// - returns: String
    open func getChangeFeedUrl() throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/system/units/changefeed", parameters: [:])
        
        let tokenurl = (data?["token"] as! [String: Any]) ["url"] as? String
        return tokenurl
    }
    
    /// Resets all units in failure state back to normal.
    open func resetAllFailedUnits() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/reset_all_failed", parameters: [:])
    }
    
    /// Reload the Systemd daemon.
    open func reloadDeamon() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/daemon_reload", parameters: [:])
    }
    
    /// Returns details for one Systemd unit.
    /// - parameter unitName: unitName
    /// - returns: Unit
    open func getUnit(_ unitName: String) throws -> Unit? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/system/units/\(unitName)", parameters: [:])
        
        let unit = Mapper<Unit>().map(JSON: data?["unit"] as! [String : Any])
        return unit
    }
    
    /// Enables a unit so it is automatically run on startup.
    /// - parameter unitName: unitName
    open func enableUnit(_ unitName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/enable", parameters: [:])
    }
    
    /// Disables a unit so it won't automatically run on startup.
    /// - parameter unitName: unitName
    open func disableUnit(_ unitName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/disable", parameters: [:])
    }
    
    /// Send a POSIX signal to the process(es) running in a unit.
    /// - parameter unitName: unitName
    /// - parameter who: who
    /// - parameter signal: signal
    open func killUnit(_ unitName: String, who: String, signal: Int) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/kill", parameters: [
            "who": String(describing: who),
            "signal": String(describing: signal)
            ])
    }
    
    /// Masks a unit, preventing its use altogether.
    /// - parameter unitName: unitName
    open func maskUnit(_ unitName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/mask", parameters: [:])
    }
    
    /// Unmasks a unit.
    /// - parameter unitName: unitName
    open func unmaskUnit(_ unitName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/unmask", parameters: [:])
    }
    
    /// Reload a unit.
    /// - parameter unitName: unitName
    /// - parameter replace: Replace a job that is already running
    open func reloadUnit(_ unitName: String, replace: Bool) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/reload", parameters: [
            "replace": String(describing: replace)
            ])
    }
    
    /// Resets the failure state of a unit back to normal.
    /// - parameter unitName: unitName
    open func resetUnitFailedState(_ unitName: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/reset_failed", parameters: [:])
    }
    

    /// Restarts a unit.
    /// - parameter unitName: unitName
    /// - parameter replace: Replace a job that is already running
    open func restartUnit(_ unitName: String, replace: Bool) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/restart", parameters: [
            "replace": String(describing: replace)
            ])
    }
    
    /// Starts a unit.
    /// - parameter unitName: unitName
    /// - parameter replace: Replace a job that is already running
    open func startUnit(_ unitName: String, replace: Bool) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/start", parameters: [
            "replace": String(describing: replace)
            ])
    }
    
    /// Stopps a unit.
    /// - parameter unitName: unitName
    /// - parameter replace: Replace a job that is already running
    open func stopUnit(_ unitName: String, replace: Bool) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/system/units/\(unitName)/stop", parameters: [
            "replace": String(describing: replace)
            ])
    }
    
    // MARK: - Internally used
    func postInit(_ nitrapi: Nitrapi, id: Int) {
        self.nitrapi = nitrapi
        self.id = id
    }
}

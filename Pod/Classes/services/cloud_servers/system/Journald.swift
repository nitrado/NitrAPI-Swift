import ObjectMapper

/// This class represents a Journald.
open class Journald: Mappable {
    fileprivate var nitrapi: Nitrapi!
    fileprivate var id: Int!
    init() {
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
    }
    
    /// This class represents a JournalEntry.
    open class JournalEntry: Mappable {
        /// Returns cursor.
        open fileprivate(set) var cursor: String?
        /// Returns realtimeTimestamp.
        open fileprivate(set) var realtimeTimestamp: Int?
        /// Returns monotonicTimestamp.
        open fileprivate(set) var monotonicTimestamp: Int?
        /// Returns bootId.
        open fileprivate(set) var bootId: String?
        /// Returns priority.
        open fileprivate(set) var priority: Int?
        /// Returns uid.
        open fileprivate(set) var uid: Int?
        /// Returns gid.
        open fileprivate(set) var gid: Int?
        /// Returns systemdSlice.
        open fileprivate(set) var systemdSlice: String?
        /// Returns machineId.
        open fileprivate(set) var machineId: String?
        /// Returns hostname.
        open fileprivate(set) var hostname: String?
        /// Returns transport.
        open fileprivate(set) var transport: String?
        /// Returns syslogFacility.
        open fileprivate(set) var syslogFacility: Int?
        /// Returns syslogIdentifier.
        open fileprivate(set) var syslogIdentifier: String?
        /// Returns comm.
        open fileprivate(set) var comm: String?
        /// Returns exe.
        open fileprivate(set) var exe: String?
        /// Returns cmdline.
        open fileprivate(set) var cmdline: String?
        /// Returns systemdCGroup.
        open fileprivate(set) var systemdCGroup: String?
        /// Returns systemdUnit.
        open fileprivate(set) var systemdUnit: String?
        /// Returns message.
        open fileprivate(set) var message: String?
        /// Returns pid.
        open fileprivate(set) var pid: Int?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            cursor <- map["__CURSOR"]
            realtimeTimestamp <- map["__REALTIME_TIMESTAMP"]
            monotonicTimestamp <- map["__MONOTONIC_TIMESTAMP"]
            bootId <- map["_BOOT_ID"]
            priority <- map["PRIORITY"]
            uid <- map["_UID"]
            gid <- map["_GID"]
            systemdSlice <- map["_SYSTEMD_SLICE"]
            machineId <- map["_MACHINE_ID"]
            hostname <- map["_HOSTNAME"]
            transport <- map["_TRANSPORT"]
            syslogFacility <- map["SYSLOG_FACILITY"]
            syslogIdentifier <- map["SYSLOG_IDENTIFIER"]
            comm <- map["_COMM"]
            exe <- map["_EXE"]
            cmdline <- map["_CMDLINE"]
            systemdCGroup <- map["_SYSTEMD_CGROUP"]
            systemdUnit <- map["_SYSTEMD_UNIT"]
            message <- map["MESSAGE"]
            pid <- map["_PID"]
        }
    }
    
    /// - parameter unit: Filter by unit name. All journal messages are returned if unset.
    /// - parameter cursor: Initial cursor reference obtained from a log event. Seeks to tail if unspecified.
    /// - parameter backlog: Offset from the current log tail, must be >= 0
    /// - parameter count: Number of messages to return, starting at the cursor position specified by backlog. -1 returns all messages and continuously streams any new ones.
    open func getUrl(unit: String? = nil, cursor: String? = nil, backlog: Int = 20, count: Int = -1) throws -> String? {
        var params = [
            "backlog": String(describing: backlog),
            "count": String(describing: count)
        ]
        
        if let unit = unit {
            params["unit"] = unit
        }
        
        if let cursor = cursor {
            params["cursor"] = cursor
        }
        
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/system/journal/", parameters: params)
        
        let tokenurl = (data?["token"] as! [String: Any]) ["url"] as? String
        return tokenurl
    }
    
    // MARK: - Internally used
    func postInit(_ nitrapi: Nitrapi, id: Int) {
        self.nitrapi = nitrapi
        self.id = id
    }
}

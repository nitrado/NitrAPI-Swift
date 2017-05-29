import ObjectMapper

/// This class represents a CloudServer.
open class CloudServer: Service {
    
    /// The Status of the CloudServer.
    public enum CloudserverStatus: String {
        /// The Server is running.
        case RUNNING = "running"
        /// The Server is stopped.
        case STOPPED = "stopped"
        /// The Server is currently installing. This can take some minutes.
        case INSTALLING = "installing"
        /// The Server is currently re-installing. This can take some minutes.
        case REINSTALLING = "reinstalling"
        /// The Server is currently processing a up- or downgrade.
        case FLAVOUR_CHANGE = "flavour_change"
        /// The server is currently restoring a Backup. This can take some minutes.
        case RESTORING = "restoring"
        /// A error while the up- or downgrade is occurred. The support has been informed.
        case ERROR_FC = "error_fc"
        /// A error while deleting the Server is occurred. The support has been informed.
        case ERROR_DELETE = "error_delete"
        /// A error while installing the Server is occurred. The support has been informed.
        case ERROR_INSTALL = "error_install"
        /// A error while re-installing the Server is occurred. The support has been informed.
        case ERROR_REINSTALL = "error_reinstall"
    }
    
    /// The Status of the CloudServer.
    open fileprivate(set) var cloudserverStatus: CloudserverStatus!
    /// Returns hostname.
    open fileprivate(set) var hostname: Date!
    /// Returns dynamic.
    open fileprivate(set) var dynamic: Bool!
    /// Returns hardware.
    open fileprivate(set) var hardware: Hardware!
    /// Returns ips.
    open fileprivate(set) var ips: [Ip]!
    /// The currently installed image.
    open fileprivate(set) var image: Image!
    /// True if the Cloud Server has a Nitrapi Daemon instance running.
    open fileprivate(set) var daemonAvailable: Bool!
    /// Returns passwordAvailable.
    open fileprivate(set) var passwordAvailable: Bool!
    /// Returns bandwidthLimited.
    open fileprivate(set) var bandwidthLimited: Bool!
    
    class CloudServerData : Mappable {
        weak var parent: CloudServer!
        init() {
        }
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            parent.cloudserverStatus <- (map["status"], EnumTransform<CloudserverStatus>())
            parent.hostname <- (map["hostname"], Nitrapi.dft)
            parent.dynamic <- map["dynamic"]
            parent.hardware <- map["hardware"]
            parent.ips <- map["ips"]
            parent.image <- map["image"]
            parent.daemonAvailable <- map["daemon_available"]
            parent.passwordAvailable <- map["password_available"]
            parent.bandwidthLimited <- map["bandwidth_limited"]
        }
    }
    
    open class Hardware: Mappable {
        /// Returns cpu.
        open fileprivate(set) var cpu: Int!
        /// Returns ram.
        open fileprivate(set) var ram: Int!
        /// Returns windows.
        open fileprivate(set) var windows: Bool!
        /// Returns ssd.
        open fileprivate(set) var ssd: Int!
        /// Returns ipv4.
        open fileprivate(set) var ipv4: Int!
        /// The amount of high speed traffic in TB.
        open fileprivate(set) var traffic: Int!
        /// Returns backup.
        open fileprivate(set) var backup: Int!
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            cpu <- map["cpu"]
            ram <- map["ram"]
            windows <- map["windows"]
            ssd <- map["ssd"]
            ipv4 <- map["ipv4"]
            traffic <- map["traffic"]
            backup <- map["backup"]
        }
        
    }
    
    open class Ip: Mappable {
        /// Returns address.
        open fileprivate(set) var address: String!
        /// The ip version (4 or 6).
        open fileprivate(set) var version: Int!
        /// Returns mainIp.
        open fileprivate(set) var mainIp: Bool!
        /// Returns mac.
        open fileprivate(set) var mac: String!
        /// Returns ptr.
        open fileprivate(set) var ptr: String!
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            address <- map["address"]
            version <- map["version"]
            mainIp <- map["main_ip"]
            mac <- map["mac"]
            ptr <- map["ptr"]
        }
        
    }
    
    open class Image: Mappable {
        /// Returns id.
        open fileprivate(set) var id: Int!
        /// Returns name.
        open fileprivate(set) var name: String!
        /// Returns windows.
        open fileprivate(set) var windows: Bool!
        /// Returns daemon.
        open fileprivate(set) var daemon: Bool!
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            id <- map["id"]
            name <- map["name"]
            windows <- map["is_windows"]
            daemon <- map["daemon"]
        }
        
    }    
    
    /// Returns a list of all backups.
    /// - returns: a list of all backups.
    open func getBackups() throws -> [Backup]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/backups", parameters: [:])
        
        let backups = Mapper<Backup>().mapArray(JSONArray: data?["backups"] as! [[String : Any]])
        return backups
    }
    
    /// Creates a new backup.
    open func createBackup() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/backups", parameters: [:])
    }
    
    /// Restores the backup with the given id.
    /// - parameter backupId:
    open func restoreBackup(_ backupId: Int) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/backups/\(backupId)/restore", parameters: [:])
    }
    
    /// Deletes the backup with the given id.
    /// - parameter backupId:
    open func deleteBackup(_ backupId: Int) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/cloud_servers/backups/\(backupId)", parameters: [:])
    }
    
    open func doBoot() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/boot", parameters: [:])
    }
    
    /// - parameter hostname:
    open func changeHostame(_ hostname: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/hostname", parameters: [
            "hostname": String(hostname)
            ])
    }
    
    /// - parameter ipAddress:
    /// - parameter hostname:
    open func changePTREntry(_ ipAddress: String, hostname: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/ptr/\(ipAddress)", parameters: [
            "hostname": String(hostname)
            ])
    }
        
    /// - parameter imageId:
    open func doReinstall(_ imageId: Int) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/reinstall", parameters: [
            "image_id": String(imageId)
            ])
    }
    
    open func doReboot() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/reboot", parameters: [:])
    }
    
    /// A hard reset will turn of your Cloud Server instantly. This can cause data loss or file system corruption. Only trigger if the instance does not respond to normal reboots.
    open func doReset() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/reset", parameters: [:])
    }
    
    /// Returns resource stats.
    /// - parameter time:  valid time parameters: 1h, 4h, 1d, 7d
    /// - returns:
    open func getResourceUsage(_ time: Int) throws -> [Resource]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/resources", parameters: [
            "time": String(time)
            ])
        
        let resources = Mapper<Resource>().mapArray(JSONArray: data?["resources"] as! [[String : Any]])
        return resources
    }
    
    /// - parameter lines:
    /// - returns:
    open func getConsoleLogs(_ lines: Int) throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/console_logs", parameters: [
            "lines": String(lines)
            ])
        
        let console_logs = data?["console_logs"] as? String
        return console_logs
    }
    
    /// - returns:
    open func getNoVNCUrl() throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/console", parameters: [:])
        
        let consoleurl = (data?["console"] as! [String: Any]) ["url"] as? String
        return consoleurl
    }
    
    /// - returns:
    open func getInitialPassword() throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/password", parameters: [:])
        
        let password = data?["password"] as? String
        return password
    }
    
    open func doShutdown() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/shutdown", parameters: [:])
    }
    
    
    open func refresh() throws {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers", parameters: [:])
        let datas = CloudServerData()
        datas.parent = self
        _ = Mapper<CloudServerData>().map(JSON: data?["cloud_server"] as! [String : Any], toObject: datas)
    }
}

import ObjectMapper

/// This class represents a CloudServer.
open class CloudServer: Service {
    
    /// This enum represents the status of a CloudServer.
    public enum CloudserverStatus: String {
        /// The Server is running.
        case RUNNING = "running"
        /// The Server is stopped.
        case STOPPED = "stopped"
        /// The Server is currently installing. This can take some minutes.
        case INSTALLING = "installing"
        /// The Server is currently re-installing. This can take some minutes.
        case REINSTALLING = "reinstalling"
        /// The Server is currently processing an up- or downgrade.
        case FLAVOUR_CHANGE = "flavour_change"
        /// The Server is currently restoring a backup. This can take some minutes.
        case RESTORING = "restoring"
        /// An error occurred while up- or downgrading. The support has been informed.
        case ERROR_FC = "error_fc"
        /// An error occurred while deleting the Server. The support has been informed.
        case ERROR_DELETE = "error_delete"
        /// An error occurred while installing the Server. The support has been informed.
        case ERROR_INSTALL = "error_install"
        /// An error occurred while reinstalling the Server. The support has been informed.
        case ERROR_REINSTALL = "error_reinstall"
    }
    
    /// Returns the status of the CloudServer.
    open fileprivate(set) var cloudserverStatus: CloudserverStatus?
    /// Returns hostname.
    open fileprivate(set) var hostname: String?
    /// Returns dynamic.
    open fileprivate(set) var dynamic: Bool?
    /// Returns the hardware details.
    open fileprivate(set) var hardware: Hardware?
    /// Returns the IP addresses.
    open fileprivate(set) var ips: [Ip]?
    /// Returns the currently installed image.
    open fileprivate(set) var image: Image?
    /// Returns true if the Cloud Server has a Nitrapi Daemon instance running.
    open fileprivate(set) var daemonAvailable: Bool?
    /// Returns true if the initial password can be received.
    open fileprivate(set) var passwordAvailable: Bool?
    /// Returns true if the bandwidth is limited.
    open fileprivate(set) var bandwidthLimited: Bool?
    
    class CloudServerData : Mappable {
        weak var parent: CloudServer!
        init() {
        }
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            parent.cloudserverStatus <- (map["status"], EnumTransform<CloudserverStatus>())
            parent.hostname <- map["hostname"]
            parent.dynamic <- map["dynamic"]
            parent.hardware <- map["hardware"]
            parent.ips <- map["ips"]
            parent.image <- map["image"]
            parent.daemonAvailable <- map["daemon_available"]
            parent.passwordAvailable <- map["password_available"]
            parent.bandwidthLimited <- map["bandwidth_limited"]
        }
    }
    
    /// This class represents details of the hardware.
    open class Hardware: Mappable {
        /// Returns cpu.
        open fileprivate(set) var cpu: Int?
        /// Returns ram.
        open fileprivate(set) var ram: Int?
        /// Returns windows.
        open fileprivate(set) var windows: Bool?
        /// Returns ssd.
        open fileprivate(set) var ssd: Int?
        /// Returns ipv4.
        open fileprivate(set) var ipv4: Int?
        /// Returns the amount of high speed traffic in TB.
        open fileprivate(set) var traffic: Int?
        /// Returns backup.
        open fileprivate(set) var backup: Int?
        
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
    
    /// This class represents an IP Address.
    open class Ip: Mappable, CustomStringConvertible {
        /// Returns address.
        open fileprivate(set) var address: String?
        /// Returns the ip version (4 or 6).
        open fileprivate(set) var version: Int?
        /// Returns mainIp.
        open fileprivate(set) var mainIp: Bool?
        /// Returns mac.
        open fileprivate(set) var mac: String?
        /// Returns ptr.
        open fileprivate(set) var ptr: String?
        
        init() {
        }
        
        
        required public init?(map: Map) {
        }
        
        public init(address: String) {
            self.address = address
        }
        
        public func mapping(map: Map) {
            address <- map["address"]
            version <- map["version"]
            mainIp <- map["main_ip"]
            mac <- map["mac"]
            ptr <- map["ptr"]
        }
        
        open var description: String {
            return address ?? ""
        }
    }
    
    /// This class represents an image.
    open class Image: Mappable, CustomStringConvertible {
        /// Returns id.
        open fileprivate(set) var id: Int?
        /// Returns name.
        open fileprivate(set) var name: String?
        /// Returns windows.
        open fileprivate(set) var windows: Bool?
        /// Returns hasDaemon.
        open fileprivate(set) var hasDaemon: Bool?
        /// Returns isDaemonCompatible.
        open fileprivate(set) var isDaemonCompatible: Bool?
        open fileprivate(set) var isDefault: Bool?
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            id <- map["id"]
            name <- map["name"]
            windows <- map["is_windows"]
            hasDaemon <- map["has_daemon"]
            isDaemonCompatible <- map["is_daemon_compatible"]
            isDefault <- map["default"]
        }

        open var description: String {
            return name ?? "undefined"
        }
    }
    
    /// This class represents a SupportAuthorization.
    open class SupportAuthorization: Mappable {
        /// Returns createdAt.
        open fileprivate(set) var createdAt: Date?
        /// Returns expiresAt.
        open fileprivate(set) var expiresAt: Date?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            createdAt <- (map["created_at"], Nitrapi.dft)
            expiresAt <- (map["expires_at"], Nitrapi.dft)
        }
    }
    
    /// This class represents a Group.
    open class Group: Mappable {
        /// Returns id.
        open fileprivate(set) var id: Int?
        /// Returns name.
        open fileprivate(set) var name: String?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            id <- map["id"]
            name <- map["name"]
        }
    }
    
    /// This class represents an User.
    open class User: Mappable {
        /// Returns username.
        open fileprivate(set) var username: String?
        /// Returns groups.
        open fileprivate(set) var groups: [Group]?
        /// Returns id.
        open fileprivate(set) var id: Int?
        /// Returns home.
        open fileprivate(set) var home: String?
        
        init() {
        }
        
        required public init?(map: Map) {
        }
        
        public func mapping(map: Map) {
            username <- map["username"]
            groups <- map["groups"]
            id <- map["id"]
            home <- map["home"]
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
    /// - parameter backupId: backupId
    open func restoreBackup(_ backupId: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/backups/\(backupId)/restore", parameters: [:])
    }
    
    /// Deletes the backup with the given id.
    /// - parameter backupId: backupId
    open func deleteBackup(_ backupId: String) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/cloud_servers/backups/\(backupId)", parameters: [:])
    }
    
    
    open func doBoot() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/boot", parameters: [:])
    }
    
    
    /// - parameter hostname: hostname
    open func changeHostame(_ hostname: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/hostname", parameters: [
            "hostname": String(hostname)
            ])
    }
    
    
    /// - parameter ipAddress: ipAddress
    /// - parameter hostname: hostname
    open func changePTREntry(_ ipAddress: String, hostname: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/ptr/\(ipAddress)", parameters: [
            "hostname": String(hostname)
            ])
    }
    
    
    /// - parameter imageId: imageId
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
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/hard_reset", parameters: [:])
    }
    
    /// Returns resource stats.
    /// - parameter time: valid time parameters: 1h, 4h, 1d, 7d
    /// - returns: [Resource]
    open func getResourceUsage(_ time: String) throws -> [Resource]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/resources", parameters: [
            "time": time
            ])
        
        let resources = Mapper<Resource>().mapArray(JSONArray: data?["resources"] as! [[String : Any]])
        return resources
    }
    
    
    /// - parameter lines: lines
    /// - returns: String
    open func getConsoleLogs(_ lines: Int) throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/console_logs", parameters: [
            "lines": String(lines)
            ])
        
        let console_logs = data?["console_logs"] as? String
        return console_logs
    }
    
    
    /// - returns: String
    open func getNoVNCUrl() throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/console", parameters: [:])
        
        let consoleurl = (data?["console"] as! [String: Any]) ["url"] as? String
        return consoleurl
    }
    
    
    /// - returns: String
    open func getInitialPassword() throws -> String? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/password", parameters: [:])
        
        let password = data?["password"] as? String
        return password
    }
    
    
    open func doShutdown() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cloud_servers/shutdown", parameters: [:])
    }
    
    
    /// - returns: Firewall
    open func getFirewall() throws -> Firewall? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/firewall", parameters: [:])
        
        let firewall = Mapper<Firewall>().map(JSON: data?["firewall"] as! [String : Any])
        firewall?.postInit(nitrapi, id: id)
        return firewall
    }
    
    open func getFileServer() -> FileServer {
        return FileServer(service: self, nitrapi: nitrapi)
    }
    
    open func getAppManager() -> AppsManager {
        let manager = AppsManager()
        manager.postInit(nitrapi, id: id)
        return manager
    }
    
    /// Returns the existing support authorization or a NitrapiError if none exists.
    /// needs permission ROLE_SUPPORT_AUTHORIZATION
    /// - returns: SupportAuthorization
    open func getSupportAuthorization() throws -> SupportAuthorization? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/support_authorization", parameters: [:])
        
        let support_authorization = Mapper<SupportAuthorization>().map(JSON: data?["support_authorization"] as! [String : Any])
        return support_authorization
    }
    
    /// Creates a support authorization.
    /// needs permission ROLE_SUPPORT_AUTHORIZATION
    open func createSupportAuthorization() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/support_authorization", parameters: [:])
    }
    
    /// Deletes the support authorization.
    /// needs permission ROLE_SUPPORT_AUTHORIZATION
    open func deleteSupportAuthorization() throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/support_authorization", parameters: [:])
    }
    
    open func getSystemd() -> Systemd {
        let systemd = Systemd()
        systemd.postInit(nitrapi, id: id)
        return systemd
    }
    
    open func getJournald() -> Journald {
        let journald = Journald()
        journald.postInit(nitrapi, id: id)
        return journald
    }
    
    /// List all the users (with groups) on a Cloud Server. These users are located in the /etc/passwd. All newly creates users on the system are included in this array.
    /// - returns: [User]
    open func getUsers() throws -> [User]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers/user", parameters: [:])
        
        let usersusers = Mapper<User>().mapArray(JSONArray: ((data?["users"] as! [String: Any]) ["users"] as! [[String : Any]]))
        return usersusers
    }
    
    
    open func refresh() throws {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/cloud_servers", parameters: [:])
        let datas = CloudServerData()
        datas.parent = self
        _ = Mapper<CloudServerData>().map(JSON: data?["cloud_server"] as! [String : Any], toObject: datas)
    }
    
    override func postInit(_ nitrapi: Nitrapi) throws {
        try super.postInit(nitrapi)
        
        if status == .ACTIVE || status == .SUSPENDED {
            try refresh()
        }
    }
}

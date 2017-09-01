import ObjectMapper

open class PluginSystemInfo: Mappable {
    
    public class Status: Value {
        /// Plugin system is stopping.
        public static let STOPPING = Status("do_stop")
        /// Plugin system is restarting.
        public static let RESTARTING = Status("do_restart")
        /// Plugin system is installing.
        public static let INSTALLING = Status("do_install")
        /// Plugin system is uninstalling.
        public static let UNINSTALLING = Status("do_uninstall")
        /// Plugin system is started.
        public static let STARTED = Status("started")
        /// Plugin system is stopped.
        public static let STOPPED = Status("stopped")
        /// Plugin system has an error.
        public static let ERROR = Status("error")
    }
    
    // MARK: - Attributes
    
    open fileprivate(set) var status: Status?
    open fileprivate(set) var hostname: String?
    open fileprivate(set) var ip: String?
    open fileprivate(set) var port: Int?
    open fileprivate(set) var installedAt: Date?
    open fileprivate(set) var password: String?
    open fileprivate(set) var database: Credentials?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        status      <- (map["status"], ValueTransform<Status>())
        hostname    <- map["hostname"]
        ip          <- map["ip"]
        port        <- map["port"]
        installedAt <- (map["installed_at"], Nitrapi.dft)
        password    <- map["password"]
        database    <- map["database"]
    }    
    
}

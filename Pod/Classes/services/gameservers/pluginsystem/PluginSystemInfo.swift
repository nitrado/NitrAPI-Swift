import ObjectMapper

open class PluginSystemInfo: Mappable {
    
    public enum Status: String {
        /// Plugin system is stopping.
        case STOPPING = "do_stop"
        /// Plugin system is restarting.
        case RESTARTING = "do_restart"
        /// Plugin system is installing.
        case INSTALLING = "do_install"
        /// Plugin system is uninstalling.
        case UNINSTALLING = "do_uninstall"
        /// Plugin system is started.
        case STARTED = "started"
        /// Plugin system is stopped.
        case STOPPED = "stopped"
        /// Plugin system has an error.
        case ERROR = "error"
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
        status      <- (map["status"], EnumTransform<Status>())
        hostname    <- map["hostname"]
        ip          <- map["ip"]
        port        <- map["port"]
        installedAt <- (map["installed_at"], Nitrapi.dft)
        password    <- map["password"]
        database    <- map["database"]
    }    
    
}

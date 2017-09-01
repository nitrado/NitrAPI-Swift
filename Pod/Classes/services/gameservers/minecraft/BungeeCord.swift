import ObjectMapper

open class BungeeCord: Mappable {
    
    public class FirewallStatus: Value {
        /// Firewall is deactivated.
        public static let OFF = FirewallStatus("off")
        /// Firewall only allows its ip address.
        public static let ON_SELF = FirewallStatus("on_self")
        /// Firewall only allows the ip address in firewallIp
        public static let ON_IP = FirewallStatus("on_ip")
    }
    
    // MARK: - Attributes
    open fileprivate(set) var enabled: Bool?
    open fileprivate(set) var only: Bool?
    open fileprivate(set) var firewall: FirewallStatus?
    open fileprivate(set) var firewallIp: String?
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        enabled     <- map["enabled"]
        only        <- map["only"]
        firewall    <- (map["firewall"], ValueTransform<FirewallStatus>())
        firewallIp  <- map["firewall_ip"]
    }
    
    
}

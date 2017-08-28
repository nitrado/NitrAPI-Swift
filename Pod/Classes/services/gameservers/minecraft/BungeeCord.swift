import ObjectMapper

open class BungeeCord: Mappable {
    
    public enum FirewallStatus: String {
        /// Firewall is deactivated.
        case OFF = "off"
        /// Firewall only allows its ip address.
        case ON_SELF = "on_self"
        /// Firewall only allows the ip address in firewallIp
        case ON_IP = "on_ip"
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
        firewall    <- (map["firewall"], EnumTransform<FirewallStatus>())
        firewallIp  <- map["firewall_ip"]
    }
    
    
}

import ObjectMapper

open class DDoSAttack: Mappable {
    
    // MARK: - Attributes
    
    open fileprivate(set) var id: Int?
    open fileprivate(set) var startedAt: Date?
    open fileprivate(set) var endedAt: Date?
    open fileprivate(set) var attackType: String?
    open fileprivate(set) var ip: String?
    open fileprivate(set) var server: String?
    /// average packets-per-second
    open fileprivate(set) var pps: Int?
    /// average bandwidth
    open fileprivate(set) var bandwidth: Int?
    open fileprivate(set) var duration: Int?
    open fileprivate(set) var data: [DDoSStat]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        id <- map["id"]
        startedAt <- (map["started_at"], Nitrapi.dft)
        endedAt <- (map["ended_at"], Nitrapi.dft)
        attackType  <- map["attack_type"]
        ip          <- map["ip"]
        server      <- map["server"]
        pps         <- map["pps"]
        bandwidth   <- map["bandwidth"]
        duration    <- map["duration"]
        data        <- map["data"]
    }
    
    
}

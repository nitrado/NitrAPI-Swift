import ObjectMapper

open class DDoSStat: Mappable {
    
    // MARK: - Attributes
    
    open fileprivate(set) var datetime: Date?
    /// packets-per-second
    open fileprivate(set) var pps: Int?
    open fileprivate(set) var bandwidth: Int?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        datetime    <- (map["datetime"], Nitrapi.dft)
        pps         <- map["pps"]
        bandwidth   <- map["bandwidth"]
    }
    
}


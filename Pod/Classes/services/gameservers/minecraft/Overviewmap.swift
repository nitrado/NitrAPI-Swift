import ObjectMapper

open class Overviewmap: Mappable {
    
    // MARK: - Attributes
    open fileprivate(set) var enabled: Bool?
    open fileprivate(set) var url: String?
    open fileprivate(set) var signs: Bool?
    open fileprivate(set) var ipsonly: [String]?
    open fileprivate(set) var reset: Bool?
    open fileprivate(set) var lastReset: Date?
    open fileprivate(set) var lastEnable: Date?
    open fileprivate(set) var modified: Date?
    

    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        enabled     <- map["enabled"]
        url         <- map["url"]
        signs       <- map["signs"]
        ipsonly     <- map["ipsonly"]
        reset       <- map["reset"]
        lastReset   <- (map["last_reset"], Nitrapi.dft)
        lastEnable  <- (map["last_enable"], Nitrapi.dft)
        modified    <- (map["modified"], Nitrapi.dft)
    }
    
}

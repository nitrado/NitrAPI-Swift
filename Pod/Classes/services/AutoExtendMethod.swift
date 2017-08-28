 import ObjectMapper
 
 open class AutoExtendMethod: Mappable, CustomStringConvertible {
    open fileprivate(set) var id: Int?
    open fileprivate(set) var name: String?
    open fileprivate(set) var descr: String?
    open fileprivate(set) var available: Bool?
    open fileprivate(set) var active: Bool?
    open fileprivate(set) var paymentMethod: String?
    open fileprivate(set) var rentalTimes: [String: Int]?
    
    // MARK: - Initialization
    public required init?(map: Map) {
    }
    
    open func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        descr           <- map["description"]
        available       <- map["available"]
        active          <- map["active"]
        paymentMethod   <- map["payment_method"]
        rentalTimes     <- map["rental_times"]
    }
    open var description: String {
        return descr!
    }
 }

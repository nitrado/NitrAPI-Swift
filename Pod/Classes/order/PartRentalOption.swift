import ObjectMapper

open class PartRentalOption: Mappable {
    open fileprivate(set) var hours: Int?
    open fileprivate(set) var prices: [Price]?
    
    
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        hours   <- map["hours"]
        prices  <- map["prices"]
    }
}

open class Price: Mappable {
    open fileprivate(set) var count: Int?
    /// Price in cents. Should be a whole number unless you deal with dynamic cloud servers.
    open fileprivate(set) var price: Double?
    
    
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        count   <- map["count"]
        price  <- map["price"]
    }
}

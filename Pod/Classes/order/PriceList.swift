import ObjectMapper

open class PriceList: Mappable {
    
    open fileprivate(set) var advice: Int!
    
    fileprivate var rentalTimes: [Int]?
    open fileprivate(set) var minRentalTime: Int!
    open fileprivate(set) var maxRentalTime: Int!
    fileprivate var dynamicRentalTimes: Bool = false
    
    
    // for part pricing
    open fileprivate(set) var parts: [Part]?
    
    // for dimension pricing
    open fileprivate(set) var dimensions: [Dimension]?
    open fileprivate(set) var prices: [String: DimensionValue]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        rentalTimes <- map["rental_times"]
        minRentalTime <- map["min_rental_time"]
        maxRentalTime <- map["max_rental_time"]
        parts       <- map["parts"]
        advice      <- map["advice"]
        dimensions  <- map["dimensions"]
        prices      <- (map["prices"], DimensionValuesTransform())
    }
    
    open func getRentalTimes() -> [Int] {
        if rentalTimes == nil {
            dynamicRentalTimes = true
            var times: [Int] = []
            var i: Int = minRentalTime
            while i <= maxRentalTime {
                times.append(i)
                i += 24
            }
            rentalTimes = times
        }
        return rentalTimes!
    }
    
    open func hasDynamicRentalTimes() -> Bool {
        return dynamicRentalTimes || rentalTimes == nil
    }
}

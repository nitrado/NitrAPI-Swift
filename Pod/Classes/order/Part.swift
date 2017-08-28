import ObjectMapper

open class Part: Mappable {

    open fileprivate(set) var type: String?
    open fileprivate(set) var name: String?
    open fileprivate(set) var minCount: Int?
    open fileprivate(set) var maxCount: Int?
    open fileprivate(set) var steps: [Int]?
    open fileprivate(set) var stepNames: [String: String]?
    open fileprivate(set) var optional: Bool?
    open fileprivate(set) var rentalTimes: [PartRentalOption]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        type        <- map["type"]
        name        <- map["name"]
        minCount    <- map["min_count"]
        maxCount    <- map["max_count"]
        steps       <- map["steps"]
        stepNames   <- map["step_names"]
        optional    <- map["optional"]
        rentalTimes <- map["rental_times"]
    }
    
    
    open func getStepName(_ step: Int) -> String {
        if let stepNames = stepNames {
            return stepNames["\(steps![step])"]!
        } else {
            return "\(steps![step])"
        }
    }
    
    // do not go over the array if you know the exact step value
    open func getInstantStepName(_ step: Int) -> String {
        if let stepNames = stepNames {
            return stepNames["\(step)"]!
        } else {
            return "\(step)"
        }
    }
}

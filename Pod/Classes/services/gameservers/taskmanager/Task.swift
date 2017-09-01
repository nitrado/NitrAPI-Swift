import ObjectMapper

open class Task: Mappable {
    
    public class ActionType: Value {
        /// Restarts the gameserver.
        public static let RESTART = ActionType("restart")
        /// Stops the gameserver.
        public static let STOP = ActionType("stop")
        /// Starts the gameserver.
        public static let START = ActionType("start")
    }
    
    // MARK: - Attributes
    open fileprivate(set) var id: Int?
    open fileprivate(set) var serviceId: Int?
    /// Minutes in cron format.
    open fileprivate(set) var minute: String?
    /// Hours in cron format.
    open fileprivate(set) var hour: String?
    /// Days in cron format.
    open fileprivate(set) var day: String?
    /// Months in cron format.
    open fileprivate(set) var month: String?
    /// Weekdays in cron format.
    open fileprivate(set) var weekday: String?
    open fileprivate(set) var nextRun: Date?
    open fileprivate(set) var lastRun: Date?
    open fileprivate(set) var actionMethod: ActionType?
    /// Optional message displayed on restart or stop tasks.
    open fileprivate(set) var actionData: String?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        id              <- map["id"]
        serviceId       <- map["service_id"]
        minute          <- map["minute"]
        hour            <- map["hour"]
        day             <- map["day"]
        month           <- map["month"]
        weekday         <- map["weekday"]
        nextRun         <- (map["next_run"], Nitrapi.dft)
        lastRun         <- (map["last_run"], Nitrapi.dft)
        actionMethod    <- (map["action_method"], ValueTransform<ActionType>())
        actionData      <- map["action_data"]
    }
    
    
}

import ObjectMapper

open class TaskManager {
    
    fileprivate var nitrapi: Nitrapi!
    /// service id
    fileprivate var id: Int!
    
    // MARK: - Initialization
    public required init(id: Int, nitrapi: Nitrapi) {
        self.id = id
        self.nitrapi = nitrapi
    }

    // MARK: - Getters
    open func getScheduledTasks() throws -> [Task]? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/tasks", parameters: [:])
        return Mapper<Task>().mapArray(JSONArray: data?["tasks"] as! [[String : Any]])
    }
    
    // MARK: - Actions
    
    /// Creates a new scheduled task for the service.
    /// - parameter minute: Minutes in cron format
    /// - parameter hour: Hours in cron format
    /// - parameter day: Days in cron format
    /// - parameter month: Months in cron format
    /// - parameter weekday: Weekdays in cron format
    /// - parameter method: Type of action to be run
    /// - parameter message: Optional message for restart or stop
    open func createTask(_ minute: String, hour: String, day: String, month: String, weekday: String, method: Task.ActionType, message: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/tasks", parameters: [
            "minute":           minute,
            "hour":             hour,
            "day":              day,
            "month":            month,
            "weekday":          weekday,
            "action_method":    method.value,
            "action_data":      message
            ])
    }
    
    /// Updates an existing scheduled task for the service.
    /// - parameter id: id of the existing scheduled task
    /// - parameter minute: Minutes in cron format
    /// - parameter hour: Hours in cron format
    /// - parameter day: Days in cron format
    /// - parameter month: Months in cron format
    /// - parameter weekday: Weekdays in cron format
    /// - parameter method: Type of action to be run
    /// - parameter message: Optional message for restart or stop
    open func createTask(_ taskId: Int, minute: String, hour: String, day: String, month: String, weekday: String, method: Task.ActionType, message: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/tasks/\(taskId)", parameters: [
            "minute":           minute,
            "hour":             hour,
            "day":              day,
            "month":            month,
            "weekday":          weekday,
            "action_method":    method.value,
            "action_data":      message
            ])
    }
    
    open func deleteTask(_ taskId: Int) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/tasks/\(taskId)", parameters: [:])
    }
}

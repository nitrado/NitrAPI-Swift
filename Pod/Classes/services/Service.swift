import ObjectMapper

open class Service: Mappable {
    internal var nitrapi: Nitrapi!
    
    public enum ServiceType: String {
        case BOUNCER = "bouncer"
        case CLANPAGE = "clanpage"
        case CLOUDSERVER = "cloud_server"
        case GAMESERVER = "gameserver"
        case ROOTSERVER = "rootserver"
        case STORAGE = "storage"
        case VOICESERVER = "voiceserver"
        case WEBSPACE = "webspace"
    }
    
    public enum Status: String {
        /// The service is active and useable
        case ACTIVE = "active"
        /// The service is currently installing
        case INSTALLING = "installing"
        /// The service is suspended and can be reactivated
        case SUSPENDED = "suspended"
        /// The service is admin locked, please contact support
        case ADMINLOCKED = "adminlocked"
        /// The service is admin locked and suspended
        case ADMINLOCKED_SUSPENDED = "adminlocked_suspended"
        /// The service is deleted
        case DELETED = "deleted"
        
        // These statuses are set by fixServiceStatus() if suspendDate or deleteDate are in the past.
        /// The service is currently being suspended.
        case SUSPENDING
        /// The service is currently being deleted.
        case DELETING
    }
    
    // MARK: - Attributes
    
    open fileprivate(set) var id: Int!
    open fileprivate(set) var startDate: Date?
    open fileprivate(set) var suspendDate: Date?
    open fileprivate(set) var deleteDate: Date?
    open fileprivate(set) var userId: Int!
    open fileprivate(set) var type: ServiceType!
    open fileprivate(set) var username: String!
    open fileprivate(set) var comment: String?
    open fileprivate(set) var autoExtension: Bool!
    open fileprivate(set) var typeHuman: String!
    open fileprivate(set) var details: ServiceDetails?
    open fileprivate(set) var roles: [Role]?
    open fileprivate(set) var status: Status?

    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        id                          <-  map["id"]
        startDate                   <- (map["start_date"],   Nitrapi.dft)
        suspendDate                 <- (map["suspend_date"], Nitrapi.dft)
        deleteDate                  <- (map["delete_date"],  Nitrapi.dft)
        userId                      <-  map["user_id"]
        type                        <-  map["type"] // TODO: enum transform?
        username                    <-  map["username"]
        comment                     <-  map["comment"]
        autoExtension               <-  map["auto_extension"]
        typeHuman                   <-  map["type_human"]
        details                     <-  map["details"]
        roles                       <- (map["roles"], EnumTransform<Role>())
        status                      <- (map["status"], EnumTransform<Status>())
        
    }
    
    
    open func getWebinterfaceUrl() -> String {
        return "https://webinterface.nitrado.net/?access_token=\(nitrapi.accessToken)&language=deu&service_id=\(id as Int)" // TODO: Replace language?
    }
    
    open func getLogs() throws -> Logs? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/logs", parameters: [:])
        return Mapper<Logs>().map(JSON: data as! [String : Any])
    }
    
    open func getLogs(_ page: Int) throws -> Logs? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/logs", parameters: ["page": String(page)])
        return Mapper<Logs>().map(JSON: data as! [String : Any])
    }
    
    open func getAutoExtendMethods() throws -> [AutoExtendMethod]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/auto_extend", parameters: [:])
        return Mapper<AutoExtendMethod>().mapArray(JSONArray: data?["auto_extend"] as! [[String : Any]])
    }
    
    open func changeAutoExtendMethod(_ method: Int, rentalTime: Int) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/auto_extend", parameters: [
            "auto_extend_id": "\(method)",
            "rental_time": "\(rentalTime)"
            ])
    }
    
    /// Cancels the service.
    /// Not supported by all product types.
    open func cancel() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/cancel", parameters: [:])
    }
    
    /// Deletes the service.
    /// You only can delete the service if it's suspended otherwise an error will be thrown.
    open func delete() throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)", parameters: [:])
    }    
    
    open func hasPermission(_ needRole: Role) -> Bool {
        for role in roles! {
            if role == .ROLE_OWNER {
                return true
            }
            if role == needRole {
                return true
            }
        }
        return false
    }
    
    // MARK: - Internally Used
    
    func postInit(_ nitrapi: Nitrapi) throws {
        self.nitrapi = nitrapi
        
        fixServiceStatus()
    }
    
    open func setAutoExtension(_ autoExtension: Bool) {
        self.autoExtension = autoExtension
    }
    
    /// Sets the status correctly if suspendDate or deleteDate are in the past.
    func fixServiceStatus() {
        let now = Date()
        if deleteDate?.compare(now) == ComparisonResult.orderedAscending && status != .DELETED {
            status = .DELETING
        } else if suspendDate?.compare(now) == ComparisonResult.orderedAscending && status != .SUSPENDED && status != .DELETED {
            status = .SUSPENDING
        }
    }
}

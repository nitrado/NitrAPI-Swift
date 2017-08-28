import ObjectMapper

/// Details of the current customer
open class Customer: Mappable {
    internal var nitrapi: Nitrapi!
    
    open fileprivate(set) var userId: Int?
    /// username of the customer
    open fileprivate(set) var username: String?
    open fileprivate(set) var timezone: String?
    open fileprivate(set) var email: String?
    open fileprivate(set) var credit: Int?
    open fileprivate(set) var currency: String? // TODO: enum?
    open fileprivate(set) var registered: Date?
    open fileprivate(set) var language: String?
    /// URL of the avatar
    open fileprivate(set) var avatar: String?
    /// personal details
    open fileprivate(set) var profile: Dictionary<String, String>?
    
    // MARK: - Initialization
    public required init?(map: Map) {

    }
    
    open func mapping(map: Map) {
        userId      <- map["user_id"]
        username    <- map["username"]
        timezone    <- map["timezone"]
        email       <- map["email"]
        credit      <- map["credit"]
        currency    <- map["currency"]
        registered   <- (map["registered"], Nitrapi.dft)
        language    <- map["language"]
        avatar      <- map["avatar"]
        profile     <- map["profile"]
    }
    
    open func getAccountOverview() throws -> AccountOverview? {
        let data = try nitrapi.client.dataGet("user/account_overview", parameters: [:])
        return Mapper<AccountOverview>().map(JSON: data?["account_overview"] as! [String : Any])
    }
    open func getAccountOverview(_ year: Int, month: Int) throws -> AccountOverview? {
        let data = try nitrapi.client.dataGet("user/account_overview", parameters: ["year": "\(year)", "month": "\(month)"])
        return Mapper<AccountOverview>().map(JSON: data?["account_overview"] as! [String : Any])
    }
    
    // MARK: - Internally Used
    
    func postInit(_ nitrapi: Nitrapi) {
        self.nitrapi = nitrapi
    }
}


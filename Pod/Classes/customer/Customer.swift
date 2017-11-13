import ObjectMapper

/// Details of the current customer.
open class Customer: Mappable {
    fileprivate var nitrapi: Nitrapi!

    /// Returns the id of this user.
    open fileprivate(set) var userId: Int?
    /// Returns the username.
    open fileprivate(set) var username: String?
    /// Returns true if the user is activated.
    open fileprivate(set) var activated: Bool?
    /// Returns the timezone of this user.
    open fileprivate(set) var timezone: String?
    /// Returns the email address of this user.
    open fileprivate(set) var email: String?
    /// Returns the credit of this user.
    open fileprivate(set) var credit: Int?
    /// Returns the currency the user paid.
    open fileprivate(set) var currency: String?
    /// Returns the date the user registered.
    open fileprivate(set) var registered: Date?
    /// Returns language.
    open fileprivate(set) var language: String?
    /// Returns the url of the avatar.
    open fileprivate(set) var avatar: String?
    /// Returns phone.
    open fileprivate(set) var phone: Phone?
    /// Returns activated two factor authentication methods.
    open fileprivate(set) var twoFactor: [String]?
    /// Returns personal details of the user.
    open fileprivate(set) var profile: [String: String]?

    init() {
    }

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        userId <- map["user_id"]
        username <- map["username"]
        activated <- map["activated"]
        timezone <- map["timezone"]
        email <- map["email"]
        credit <- map["credit"]
        currency <- map["currency"]
        registered <- (map["registered"], Nitrapi.dft)
        language <- map["language"]
        avatar <- map["avatar"]
        phone <- map["phone"]
        twoFactor <- map["two_factor"]
        profile <- map["profile"]
    }

    /// This class represents a phone.
    open class Phone: Mappable {
        /// Returns phonenumber of the user.
        open fileprivate(set) var number: String?
        /// Returns countryCode.
        open fileprivate(set) var countryCode: String?
        /// Returns true if this number is verified.
        open fileprivate(set) var verified: Bool?

        init() {
        }

        required public init?(map: Map) {
        }

        public func mapping(map: Map) {
            number <- map["number"]
            countryCode <- map["country_code"]
            verified <- map["verified"]
        }
    }

    /// - returns: AccountOverview
    open func getAccountOverview() throws -> AccountOverview? {
        let data = try nitrapi.client.dataGet("user/account_overview", parameters: [:])

        let account_overview = Mapper<AccountOverview>().map(JSON: data?["account_overview"] as! [String : Any])
        return account_overview
    }


    /// - parameter year: year
    /// - parameter month: month
    /// - returns: AccountOverview
    open func getAccountOverview(_ year: Int, month: Int) throws -> AccountOverview? {
        let data = try nitrapi.client.dataGet("user/account_overview", parameters: [
            "year": String(describing: year),
            "month": String(describing: month)
        ])

        let account_overview = Mapper<AccountOverview>().map(JSON: data?["account_overview"] as! [String : Any])
        return account_overview
    }

    /// Request user update token.
    /// - parameter password: The current user password.
    /// - returns: String
    open func requestUserUpdateToken(_ password: String) throws -> String? {
        let data = try nitrapi.client.dataPost("user/token", parameters: [
            "password": String(describing: password)
        ])

        let token = data?["token"] as? String
        return token
    }

    /// Add phone number.
    /// - parameter number: phone number with country code
    /// - parameter token: the current user update token
    open func addPhoneNumber(_ number: String, token: String) throws {
        _ = try nitrapi.client.dataPost("user/phone", parameters: [
            "number": String(describing: number),
            "token": String(describing: token)
        ])
    }

    /// Delete phone number.
    /// - parameter token: the current user update token
    open func deletePhoneNumber(_ token: String) throws {
        _ = try nitrapi.client.dataDelete("user/phone", parameters: [
            "token": String(describing: token)
        ])
    }

    /// Verify phone number.
    /// - parameter code: Verification code from SMS
    open func verifyPhoneNumber(_ code: String) throws {
        _ = try nitrapi.client.dataPost("user/phone/verify", parameters: [
            "code": String(describing: code)
        ])
    }

    // MARK: - Internally used
    func postInit(_ nitrapi: Nitrapi) {
        self.nitrapi = nitrapi
    }
}

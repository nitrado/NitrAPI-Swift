import ObjectMapper

/**
 Main class to interact with the Nitrapi.
 
 You create it by passing the access token of the user to it.
 The next step is to get a list of services and then operate further using the service-specific classes.
 
 */
open class Nitrapi {
    /// Base url of the live api
    open static let NITRAPI_LIVE_URL: String = "https://api.nitrado.net/"
    
    /// Date formatter used in the mapping functions
    open static var dft: DateFormatterTransform = {
        var form = DateFormatter()
        form.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return DateFormatterTransform(dateFormatter: form)
    }()


    fileprivate var nitrapiUrl: String
    open fileprivate(set) var accessToken: String
    
    open fileprivate(set) var client: ProductionHttpClient
    
    // MARK: - Initialization
    
    /// Creates a new Nitrapi with the given access token.
    public convenience init(accessToken: String) {
        self.init(accessToken: accessToken, nitrapiUrl: Nitrapi.NITRAPI_LIVE_URL)
    }

    /// Creates a new Nitrapi with the given access token and url.
    public init(accessToken: String, nitrapiUrl: String) {
        
        print("Access Token: \(accessToken)")
        self.accessToken = accessToken
        self.nitrapiUrl = nitrapiUrl
        self.client = ProductionHttpClient(nitrapiUrl: nitrapiUrl, accessToken: accessToken)
    }
    
    open func setLanguage(_ lang: String) {
        client.setLanguage(lang)
    }
    
    // MARK: - Retrieve Data
    
    /// Returns the current customer.
    open func getCustomer() throws -> Customer? {
        let data = try client.dataGet("user",  parameters: [:])
        
        let customer =  Mapper<Customer>().map(JSON: data?["user"] as! [String : Any])
        customer?.postInit(self)
        return customer
    }
   
    /// Returns the service specified by the given id.
    open func getService(_ id: Int) throws -> Service? {
        let data = try client.dataGet("services/\(id as Int)", parameters: [:])
        
        if let data = data?["service"] as? NSDictionary {
            let service = try createService(data)
            try service?.postInit(self) // attach nitrapi
            return service
        }
        return nil
    }
    
    /// Returns a list of all services for the current user.
    open func getServices() throws -> [Service]? {
        let data = try client.dataGet("services", parameters: [:])
        
        var services:[Service] = []
        
        if let data = data?["services"] as? [NSDictionary] {
            for svc in data {
                let service = try createService(svc)
                if let service = service {
                    do {
                        try service.postInit(self) // attach nitrapi
                        services.append(service)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        return services
    }
    
    
    // MARK: - Payment
    open func getPaymentCountries() throws -> [Country]? {
        let data = try client.dataGet("order/payment/countries", parameters: [:])
        return Mapper<Country>().mapArray(JSONArray: data?["countries"] as! [[String : Any]])
    }
    
    open func getPaymentMethods() throws -> [PaymentMethod]? {
        let data = try client.dataGet("order/payment/payment_methods", parameters: [:])
        var methods: [PaymentMethod] = []
        if let entries = data?["payment_methods"] as? [String: NSDictionary] {
            for (id, entry) in entries {
                let method = Mapper<PaymentMethod>().map(JSON: entry as! [String : Any])
                if let method = method {
                    method.id = id
                    methods.append(method)
                }
            }
        }
        return methods
    }
    
    open func getGames() throws -> GlobalGameList? {
        let data = try client.dataGet("gameserver/games", parameters: [:])
        return Mapper<GlobalGameList>().map(JSON: data?["games"] as! [String : Any])
    }
    
    /// Returns the full list of available images.
    /// - returns:
    open func getImages() throws -> [CloudServer.Image]? {
        let data = try client.dataGet("information/cloud_servers/images", parameters: [:])
        
        let images = Mapper<CloudServer.Image>().mapArray(JSONArray: data?["images"] as! [[String : Any]])
        return images
    }
    
    open func getSSHKeys() throws -> SSHKeys? {
        let data = try client.dataGet("user/ssh_keys", parameters: [:])
        
        let keys = Mapper<SSHKeys>().map(JSON: data as! [String : Any])
        keys?.postInit(self)
        return keys
    }

    
    // MARK: - Rate Limits
    
    /// Returns the current limit of requests per hour for each user.
    open func getRateLimit() -> Int {
        return client.rateLimit
    }
    
    /// Returns the remaining requests for this hour and the current user.
    open func getRateLimitRemaining() -> Int {
        return client.rateLimitRemaining
    }
    
    /// Returns the date when the limit resets for the current user.
    open func getRateLimitReset() -> Int {
        return client.rateLimitReset
    }
    
    
    // MARK: - Utility functions
    
    /// Returns true if the api is operating as expecting.
    open func ping() throws -> Bool {
        _ = try client.dataGet(nitrapiUrl + "ping", parameters: [:])
        return true
    }
    
    
}

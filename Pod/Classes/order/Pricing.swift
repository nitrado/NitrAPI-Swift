import ObjectMapper

open class Pricing {
    var nitrapi: Nitrapi
    var product: String!
    var locationId: Int
    
    var additionals: Dictionary<String, String>
    
    var prices: [String: PriceList]
    
    
    public init(nitrapi: Nitrapi, locationId: Int) {
        self.nitrapi = nitrapi
        self.locationId = locationId
        self.prices = [:]
        self.additionals = [:]
    }
    
    /// returns a list of locations this service is available in
    open func getLocations() throws -> [Location] {
        if product == nil {
            // TODO: Exception
            return []
        }
        
        let data = try nitrapi.client.dataGet("order/order/locations", parameters: [:])
        let locations = Mapper<Location>().mapArray(JSONArray: data?["locations"] as! [[String : Any]])
        var avaiable: [Location] = []
        
        for loc in locations! {
            if loc.hasService(product!) {
                avaiable.append(loc)
            }
        }
        return avaiable
    }
    
    open func setLocationId(_ id: Int) {
        locationId = id
    }
    
    open func getPrices() throws -> PriceList {
        return try getPrices(nil)
    }
    
    open func getPrices(_ service: Service?) throws -> PriceList {
        var cacheName = "\(locationId)"
        if let service = service {
            cacheName += "/\(service.id as Int)"
        }
        if prices.keys.contains(cacheName) {
            return prices[cacheName]!
        }
        
        var parameters: [String:String] = ["location": "\(locationId)"]
        
        if let service = service {
            parameters["sale_service"] = "\(service.id as Int)"
        }
        
        let data = try nitrapi.client.dataGet("order/pricing/\(product as String)", parameters: parameters)
        
        prices[cacheName] = Mapper<PriceList>().map(JSON: data?["prices"] as! [String : Any])
        return prices[cacheName]!
    }
    
    open func getExtendPricesForService(_ service: Int) throws -> [ExtensionPrice]? {
        let data = try nitrapi.client.dataGet("order/pricing/\(product as String)", parameters: [
            "method": "extend",
            "service_id": "\(service)"])
        if let obj = data?["extend"] as? Dictionary<String, AnyObject> {
            
            if let prices = obj["prices"]! as? Dictionary<String, AnyObject> {
                var list: [ExtensionPrice] = []
                for (key, value) in prices {
                    list.append(ExtensionPrice(rentalTime: Int(key)!, price: value as! Int)!)
                }
                return list
            }
        }
        return nil
    }
    
    open func doExtendService(_ service: Int, rentalTime: Int, price: Int) throws {
        _ = try nitrapi.client.dataPost("order/order/\(product as String)", parameters: [
            "price": "\(price)",
            "rental_time": "\(rentalTime)",
            "service_id": "\(service)",
            "method": "extend"
            ])
    }
    
    open func calcAdvicePrice(price: Double, advice: Double, service: Service?) -> Int {
        
        // Dynamic cloud servers return 100% of advice.
        if let cloudserver = service as? CloudServer, cloudserver.dynamic == true {
            return Int(price - advice)
        }
        
        var advice2 = advice
        if advice2 > price {
            advice2 -= round((advice2 - price) / 2)
        }
        return Int(price - advice2)
    }
    
    
    
    
    open func getPrice(_ rentalTime: Int) throws -> Int {
        return try getPrice(nil, rentalTime: rentalTime)
    }
    open func getPrice(_ service: Service?, rentalTime: Int) throws -> Int {
        return -1
    }
    open func orderService(_ rentalTime: Int) throws {
    }
    open func getSwitchPrice(_ service: Service?, rentalTime: Int) throws -> Int {
        return try getPrice(service, rentalTime: rentalTime)
    }
    open func switchService(_ service: Service, rentalTime: Int) throws {
        
    }
}

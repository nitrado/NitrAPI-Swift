import Foundation
open class PartPricing: Pricing {
    
    var parts: [String: Int]
    
    public override init(nitrapi: Nitrapi, locationId: Int) {
        self.parts = [:]
        super.init(nitrapi: nitrapi, locationId: locationId)
    }
    
    open func addPart(_ part: String, value: Int) {
        parts[part] = value
    }
    
    open func getParts() throws -> [Part] {
        return try getPrices().parts!
    }
    
    open override func getPrice(_ service: Service?, rentalTime: Int) throws -> Int {
        var rentalTime2 = rentalTime
        let prices = try getPrices(service)
        
        var totalPrice: Double = 0
        var multiply: Double = 1
        
        if prices.hasDynamicRentalTimes() {
            if rentalTime2 % prices.minRentalTime != 0 {
                throw NitrapiError.nitrapiException(message: "Rental time \(rentalTime2) is invalid (Modulo \(prices.minRentalTime))", errorId: nil)
            }
            multiply = Double(rentalTime2 / prices.minRentalTime)
            rentalTime2 = prices.minRentalTime
        }
        
        
        for part in prices.parts! {
            if !parts.keys.contains(part.type) {
                throw NitrapiError.nitrapiException(message: "No amount selected for \(part.type as String)", errorId: nil)
            }
            let amount = parts[part.type]!
            if amount < part.minCount {
                throw NitrapiError.nitrapiException(message: "The amount \(amount as Int) of type \(part.type as String) is too small.", errorId: nil)
            }
            if amount > part.maxCount {
                throw NitrapiError.nitrapiException(message: "The amount \(amount as Int) of type \(part.type as String) is too big.", errorId: nil)
            }
            
            var localPrice: Double = -1
            for rentalOption in part.rentalTimes! {
                if rentalOption.hours == rentalTime2 {
                    for price in rentalOption.prices {
                        if price.count == amount {
                            localPrice = price.price
                            break
                        }
                    }
                }
            }
            
            
            if amount == 0  && part.optional == true {
                localPrice = 0
            }
            
            if localPrice == -1 {
                throw NitrapiError.nitrapiException(message: "No valid price found for part \(part.type as String)", errorId: nil)
            }
            totalPrice += localPrice
        }
        
        totalPrice *= multiply
        
        
        return calcAdvicePrice(price: round(totalPrice), advice: Double(prices.advice), service: service)
    }
    
    open override func orderService(_ rentalTime: Int) throws {
        var params = [
            "price": "\(try getPrice(rentalTime))",
            "rental_time": "\(rentalTime)",
            "location": "\(locationId)"
        ]
        for (key, value) in self.parts {
            params["parts[\(key)"] = "\(value)"
        }
        
        for (key, value) in self.additionals {
            params["additionals[\(key)"] = value
        }
        
        _ = try nitrapi.client.dataPost("order/order/\(product as String)", parameters: params)
    }
    
    open override func switchService(_ service: Service?, rentalTime: Int) throws {
        var params = [
            "price": "\(try getSwitchPrice(service, rentalTime: rentalTime))",
            "rental_time": "\(rentalTime)",
            "location": "\(locationId)",
            "method": "switch",
            "service_id": "\((service?.id)! as Int)"
        ]
        for (key, value) in self.parts {
            params["parts[\(key)"] = "\(value)"
        }
        
        for (key, value) in self.additionals {
            params["additionals[\(key)"] = value
        }
        
        _ = try nitrapi.client.dataPost("order/order/\(product as String)", parameters: params)
    }
    
}

import ObjectMapper

open class AccountOverview: Mappable {
    
    open fileprivate(set) var from: Date?
    open fileprivate(set) var end: Date?
    open fileprivate(set) var payments: [Payment]?
    
    public required init?(map: Map) {
    }
    
    open func mapping(map: Map) {
        from <- (map["from"], Nitrapi.dft)
        end <- (map["end"], Nitrapi.dft)
        payments <- map["payments"]
    }
    
    public enum IncOrDec: String {
        case INCREASE = "increase"
        case DECREASE = "decrease"
    }
    
    open class Payment: Mappable {
        open fileprivate(set) var id: Int?
        open fileprivate(set) var invoiceId: String?
        open fileprivate(set) var serviceId: Int?
        open fileprivate(set) var switchedServiceId: Int?
        open fileprivate(set) var donation: Donation?
        open fileprivate(set) var date: Date?
        open fileprivate(set) var method: String?
        open fileprivate(set) var duration: Int?
        open fileprivate(set) var amount: Int?
        open fileprivate(set) var type: IncOrDec?
        open fileprivate(set) var currency: String?
        open fileprivate(set) var ip: String?
        open fileprivate(set) var refundable: Bool?
        open fileprivate(set) var providerFee: Int?
        open fileprivate(set) var lastStatus: String?
        
        public required init?(map: Map) {
            id                  <- map["id"]
            invoiceId           <- map["invoice_id"]
            serviceId           <- map["service_id"]
            switchedServiceId   <- map["switched_service_id"]
            donation            <- map["donation"]
            date                <- (map["date"], Nitrapi.dft)
            method              <- map["method"]
            duration            <- map["duration"]
            amount              <- map["amount"]
            type                <- (map["type"], EnumTransform<IncOrDec>())
            currency            <- map["currency"]
            ip                  <- map["ip"]
            refundable          <- map["refundable"]
            providerFee         <- map["provider_fee"]
            lastStatus          <- map["last_status"]
        
        }
        
        open func mapping(map: Map) {
        }
    }
    
    open class Donation: Mappable {
        
        open fileprivate(set) var senderUserId: Int?
        open fileprivate(set) var receiverUserId: Int?
        open fileprivate(set) var subject: String?
        
        public required init?(map: Map) {
        }
        
        open func mapping(map: Map) {
            senderUserId    <- map["sender_user_id"]
            receiverUserId  <- map["receiver_user_id"]
            subject         <- map["subject"]
        }
    }
}

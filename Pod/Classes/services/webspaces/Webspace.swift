import ObjectMapper

open class Webspace: Service {
    
    open fileprivate(set) var name: String?
    open fileprivate(set) var maxSpace: Int?
    open fileprivate(set) var maxDomains: Int?
    open fileprivate(set) var maxMailAccounts: Int?
    open fileprivate(set) var maxFtpAccounts: Int?
    open fileprivate(set) var maxDatabases: Int?
    open fileprivate(set) var domains: [Domain]?
    
    
    open class Domain: Mappable {
        open fileprivate(set) var domain: String?
        open fileprivate(set) var expires: String?
        open fileprivate(set) var paidUntil: String?
        open fileprivate(set) var status: String?
        
        public required init?(map: Map) {
        }
        
        open func mapping(map: Map) {
            domain      <- map["domain"]
            expires     <- map["expires"]
            paidUntil   <- map["paid_until"]
            status      <- map["status"]
        }
    }

    
    class WebspaceInfo: Mappable {
        weak var parent: Webspace!
        // MARK: - Initialization
        init() {
        }
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            parent.name             <- map["name"]
            parent.maxSpace         <- map["quota.max_space"]
            parent.maxDomains       <- map["quota.max_domains"]
            parent.maxMailAccounts  <- map["quota.max_mail_accounts"]
            parent.maxFtpAccounts   <- map["quota.max_ftp_accounts"]
            parent.maxDatabases     <- map["quota.max_databases"]
            parent.domains          <- map["domains"]
        }
    }
    
    open func refresh() throws {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/webspaces", parameters: [:])
        let infos = WebspaceInfo()
        infos.parent = self
        _ = Mapper<WebspaceInfo>().map(JSON: data?["webspace"] as! [String : Any], toObject: infos)
    }
    
    
    // MARK: - Internally Used
    
    override func postInit(_ nitrapi: Nitrapi) throws {
        try super.postInit(nitrapi)
        
        if (status == .ACTIVE) {
            try refresh()
        }
    }
}

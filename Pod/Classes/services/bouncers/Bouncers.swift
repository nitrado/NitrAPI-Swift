import ObjectMapper

open class Bouncer: Service {
    
    open fileprivate(set) var maxBouncer: Int!
    
    open fileprivate(set) var bouncers: [BouncerInstance]!
    
    
    class BouncerInfo: Mappable {
        weak var parent: Bouncer!
        
        init() {
            
        }
        
        required init?(map: Map) {
        }
    
        func mapping(map: Map) {
            parent.maxBouncer   <- map["max_bouncer"]
            parent.bouncers     <- map["bouncers"]
        }
    }
    
    open class BouncerInstance: Mappable {
        open fileprivate(set) var ident: String!
        open fileprivate(set) var password: String!
        open fileprivate(set) var comment: String!
        open fileprivate(set) var serverName: String!
        open fileprivate(set) var serverPort: Int!
        
        public required init?(map: Map) {
            
        }
        open func mapping(map: Map) {
            ident       <- map["ident"]
            password    <- map["password"]
            comment     <- map["comment"]
            serverName  <- map["server.name"]
            serverPort  <- map["server.port"]
        }
    }
    
    open func refresh() throws {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/bouncers", parameters: [:])
        let infos = BouncerInfo()
        infos.parent = self
        _ = Mapper<BouncerInfo>().map(JSON: data?["bouncer"] as! [String : Any], toObject: infos)
    }
    
    
    // MARK: - Internally Used
    
    override func postInit(_ nitrapi: Nitrapi) throws {
        try super.postInit(nitrapi)
        
        if (status == .ACTIVE) {
            try refresh()
        }
    }
}

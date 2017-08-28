import ObjectMapper

open class Voiceserver: Service {
    
    public enum VoiceserverType: String {
        case TEAMSPEAK3 = "teamspeak3"
        case MUMBLE = "mumble"
        case VENTRILO = "ventrilo"
    }
    
    open fileprivate(set) var voiceserverType: VoiceserverType?
    open fileprivate(set) var ip: String?
    open fileprivate(set) var port: Int?
    open fileprivate(set) var slots: Int?
    open fileprivate(set) var started: Bool?
    open fileprivate(set) var specific: AnyObject? // TODO: elaborate
    
    
    class VoiceserverInfo: Mappable {
        weak var parent: Voiceserver!
        // MARK: - Initialization
        init() {
        }
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            parent.voiceserverType <- (map["type"], EnumTransform<VoiceserverType>())
            parent.ip              <- map["ip"]
            parent.port            <- map["port"]
            parent.slots           <- map["slots"]
            parent.started         <- map["started"]
            parent.specific        <- map["specific"]
        }
    }
    
    open func doRestart() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/voiceservers/restart", parameters: [:])
    }
    
    open func doStop() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/voiceservers/stop", parameters: [:])
    }
    
    open func doReinstall() throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/voiceservers/reinstall", parameters: [:])
    }
    
    
    open func refresh() throws {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/voiceservers", parameters: [:])
        let infos = VoiceserverInfo()
        infos.parent = self
        _ = Mapper<VoiceserverInfo>().map(JSON: data?["voiceserver"] as! [String : Any], toObject: infos)
    }
    
    
    // MARK: - Internally Used
    
    override func postInit(_ nitrapi: Nitrapi) throws {
        try super.postInit(nitrapi)
        
        if (status == .ACTIVE) {
            try refresh()
        }
    }
}

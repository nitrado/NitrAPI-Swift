import ObjectMapper

open class Game: Mappable, CustomStringConvertible {
    // MARK: - Attributes
    
    open fileprivate(set) var name: String?
    open fileprivate(set) var steamId: Int?
    open fileprivate(set) var hasSteamGame: Bool?
    open fileprivate(set) var minecraftMode: Bool?
    open fileprivate(set) var publicserverOnly: Bool?
    open fileprivate(set) var portlistShort: String?
    open fileprivate(set) var folderShort: String?
    open fileprivate(set) var installed: Bool?
    open fileprivate(set) var active: Bool?
    open fileprivate(set) var minimumSlots: Int?
    open fileprivate(set) var enoughSlots: Bool?
    open fileprivate(set) var modpacks: [Modpack]?
    open fileprivate(set) var iconx16: String?
    open fileprivate(set) var iconx32: String?
    open fileprivate(set) var iconx64: String?
    open fileprivate(set) var iconx128: String?
    open fileprivate(set) var iconx256: String?
    open fileprivate(set) var locations: [Int]?
    open fileprivate(set) var visible: Bool?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        name                <- map["name"]
        steamId             <- map["steam_id"]
        hasSteamGame        <- map["has_steam_game"]
        minecraftMode       <- map["minecraft_mode"]
        publicserverOnly    <- map["publicserver_only"]
        portlistShort       <- map["portlist_short"]
        folderShort     	<- map["folder_short"]
        installed       	<- map["installed"]
        active              <- map["active"]
        minimumSlots    	<- map["minimum_slots"]
        enoughSlots     	<- map["enough_slots"]
        modpacks            <- map["modpacks"]
        iconx16             <- map["icons.x16"]
        iconx32         	<- map["icons.x32"]
        iconx64             <- map["icons.x64"]
        iconx128        	<- map["icons.x120"]
        iconx256            <- map["icons.x256"]
        locations           <- map["locations"]
        visible             <- map["visible"]
    }
    
    open var description: String {
        return name ?? ""
    }
    
}

import ObjectMapper

open class Modpack: Mappable {
    
    // MARK: - Attributes
    
    open fileprivate(set) var name: String?
    open fileprivate(set) var modpackVersion: String?
    open fileprivate(set) var gameVersion: String?
    open fileprivate(set) var modpackFile: String?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        name            <- map["name"]
        modpackVersion  <- map["modpack_version"]
        gameVersion     <- map["game_version"]
        modpackFile     <- map["modpack_file"]
    }
}

import ObjectMapper

open class Plugin: Mappable {

    
    open class Command: Mappable {
        
        // MARK: - Attributes
        open fileprivate(set) var description: String?
        /// Usage example for this command
        open fileprivate(set) var usage: String?
        
        // MARK: - Initialization
        public required init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            description <- map["description"]
            usage       <- map["usage"]
        }
        
        
    }
    
    // MARK: - Attributes
    open fileprivate(set) var file: String?

    open fileprivate(set) var name: String?
    open fileprivate(set) var main: String?
    open fileprivate(set) var version: String?
    open fileprivate(set) var author: String?
    open fileprivate(set) var authors: [String]?
    open fileprivate(set) var softDepent: [String]?
    open fileprivate(set) var description: String?
    open fileprivate(set) var commands: [String: Command]?
    
    
    // MARK: - Initialization
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        file        <- map["file"]
        
        name        <- map["details.name"]
        main        <- map["details.main"]
        version     <- map["details.version"]
        author      <- map["details.author"]
        authors     <- map["details.authors"]
        softDepent  <- map["details.softDepend"]
        description <- map["details.description"]
        commands    <- map["details.commands"]
    }
    
    
}

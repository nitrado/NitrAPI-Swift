import ObjectMapper

/// Quota of a user on a gameserver.
open class Quota: Mappable {
    
    // MARK: - Attributes
    
    /// Number of used blocks.
    open fileprivate(set) var blockUsage: Int?
    /// Soft limit of blocks.
    open fileprivate(set) var blockSoftLimit: Int?
    /// Hard limit of blocks.
    open fileprivate(set) var blockHardLimit: Int?
    
    /// Number of used files.
    open fileprivate(set) var fileUsage: Int?
    /// Soft limit of files.
    open fileprivate(set) var fileSoftLimit: Int?
    /// Hard limit of files.
    open fileprivate(set) var fileHardLimit: Int?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        blockUsage      <- map["block_usage"]
        blockSoftLimit  <- map["block_softlimit"]
        blockHardLimit  <- map["block_hardlimit"]
        fileUsage       <- map["file_usage"]
        fileSoftLimit   <- map["file_softlimit"]
        fileHardLimit   <- map["file_hardlimit"]
    }
    
    
}

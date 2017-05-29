import ObjectMapper
import Just

open class FileServer {
    
    fileprivate var nitrapi: Nitrapi!
    /// service id
    fileprivate var id: Int!

    open class Token: Mappable {
        // MARK: - Attributes
        open fileprivate(set) var url: String!
        open fileprivate(set) var token: String!
        
        open fileprivate(set) var id: Int!
        
        // MARK: - Initialization
        
        public required init?(map: Map) {
            
        }
        
        open func mapping(map: Map) {
            url     <- map["url"]
            token   <- map["token"]
        }
    }
    // MARK: - Initialization
    public required init(id: Int, nitrapi: Nitrapi) {
        self.id = id
        self.nitrapi = nitrapi
    }
    
    // MARK: - Getters
    open func getUploadToken(_ path: String, name: String) throws -> Token? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/file_server/upload", parameters: ["path": path, "file": name])
        return Mapper<Token>().map(JSON: data?["token"] as! [String : Any])
    }
    open func getDownloadToken(_ file: String) throws -> Token? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/file_server/download", parameters: ["file": file])
        return Mapper<Token>().map(JSON: data?["token"] as! [String : Any])
    }
    
    /// Lists the contents of the root directory.
    open func getFileList() throws -> [FileEntry]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/file_server/list", parameters: [:])

        return Mapper<FileEntry>().mapArray(JSONArray: data?["entries"] as! [[String : Any]])
    }
    
    open func getFileList(_ path: String) throws -> [FileEntry]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/file_server/list", parameters: ["dir": path])
        return Mapper<FileEntry>().mapArray(JSONArray: data?["entries"] as! [[String : Any]])
    }

    
    /// Searches inside a specific directory recursively for specified file pattern.
    /// - parameter path: path of the directory
    /// - parameter search: search pattern
    /// - returns: a list of files matching the pattern
    open func doFileSearch(_ path: String, search: String) throws -> [FileEntry]? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/file_server/list", parameters: ["dir": path, "search": "search"])
        return Mapper<FileEntry>().mapArray(JSONArray: data?["entries"] as! [[String : Any]])
    }
    
    
    // MARK: - Actions
    open func deleteFile(_ file: String) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/gameservers/file_server/delete", parameters: ["path": file])
    }
    
    open func deleteDirectory(_ file: String) throws {
        try deleteFile(file)
    }
    
    open func moveFile(_ sourceFile: String, targetDir:String, fileName: String) throws {
        if !sameDirectory(sourceFile, dir: targetDir) {
            _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/file_server/move", parameters: ["source_path": sourceFile, "target_path": targetDir, "target_filename": fileName])
        }
    }
    
    open func moveDirectory(_ source: String, target:String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/file_server/move", parameters: ["source_path": source, "target_path": target])
    }
    
    open func copyFile(_ sourceFile: String, targetDir:String, fileName: String) throws {
        if !sameDirectory(sourceFile, dir: targetDir) {
            _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/file_server/copy", parameters: ["source_path": sourceFile, "target_path": targetDir, "target_filename": fileName])
        }
    }
    
    open func copyDirectory(_ source: String, targetDir:String, dirName: String) throws {
        try copyFile(source, targetDir: targetDir, fileName: dirName)
    }
    
    open func createDirectory(_ path: String, name: String) throws {
        _ = try nitrapi.client.dataPost("services/\(id as Int)/gameservers/file_server/mkdir", parameters: ["path": path, "name": name])
    }
    
    open func getFileSize(_ path: String) throws -> Int {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/gameservers/file_server/size", parameters: ["path": path])
        return data!["size"] as! Int
    }
    
    
    
    // MARK: - read'n write
    
    open func readFile(_ file: String) throws -> String {
        let token = try getDownloadToken(file)
        let res = Just.get((token?.url)!)
        if res.ok {
            return res.text ?? ""
        } else {
            throw NitrapiError.httpException(statusCode: -1)
        }
    }
    
    open func writeFile(_ path: String, name: String, content: String) throws {
        let token = try getUploadToken(path, name: name)
        try nitrapi.client.rawPost((token?.url)!, token: (token?.token)!, body: content.data(using: String.Encoding.utf8)!)
    }
    
    
    func sameDirectory(_ path: String, dir: String) -> Bool {
        if let range = path.range(of: "/", options: .backwards) {
            return path.substring(to: path.index(before: range.upperBound)) == dir
        }
        return true
    }
}

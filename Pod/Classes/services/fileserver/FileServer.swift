import ObjectMapper
import Just

open class FileServer {
    
    fileprivate var nitrapi: Nitrapi!
    /// service id
    fileprivate var id: Int!
    fileprivate var url: String
    fileprivate var hasPermissions: Bool = false
    fileprivate var hasBookmarks: Bool = false

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
    public required init(service: Gameserver, nitrapi: Nitrapi) {
        self.id = service.id
        self.nitrapi = nitrapi
        self.url = "gameservers"
    }
    
    public required init(service: CloudServer, nitrapi: Nitrapi) {
        self.id = service.id
        self.nitrapi = nitrapi
        self.url = "cloud_servers"
        self.hasPermissions = true
        self.hasBookmarks = true
    }
    
    // MARK: - Getters
    open func getUploadToken(_ path: String, name: String, username: String? = nil) throws -> Token? {
        var params = [
            "path": path,
            "file": name]
        if let username = username {
            params["username"] = username
        }
        
        let data = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/upload", parameters: params)
        return Mapper<Token>().map(JSON: data?["token"] as! [String : Any])
    }
    open func getDownloadToken(_ file: String) throws -> Token? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/\(url)/file_server/download", parameters: ["file": file])
        return Mapper<Token>().map(JSON: data?["token"] as! [String : Any])
    }
    
    /// Lists the contents of the root directory.
    open func getFileList() throws -> [FileEntry]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/\(url)/file_server/list", parameters: [:])

        return Mapper<FileEntry>().mapArray(JSONArray: data?["entries"] as! [[String : Any]])
    }
    
    open func getFileList(_ path: String) throws -> [FileEntry]? {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/\(url)/file_server/list", parameters: ["dir": path])
        return Mapper<FileEntry>().mapArray(JSONArray: data?["entries"] as! [[String : Any]])
    }

    
    /// Searches inside a specific directory recursively for specified file pattern.
    /// - parameter path: path of the directory
    /// - parameter search: search pattern
    /// - returns: a list of files matching the pattern
    open func doFileSearch(_ path: String, search: String) throws -> [FileEntry]? {
        let data = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/list", parameters: ["dir": path, "search": "search"])
        return Mapper<FileEntry>().mapArray(JSONArray: data?["entries"] as! [[String : Any]])
    }
    
    
    // MARK: - Actions
    open func deleteFile(_ file: String) throws {
        _ = try nitrapi.client.dataDelete("services/\(id as Int)/\(url)/file_server/delete", parameters: ["path": file])
    }
    
    open func deleteDirectory(_ file: String) throws {
        try deleteFile(file)
    }
    
    open func moveFile(_ sourceFile: String, targetDir:String, fileName: String, username: String? = nil) throws {
        if !sameDirectory(sourceFile, dir: targetDir) {
            var params = ["source_path": sourceFile, "target_path": targetDir, "target_filename": fileName]
            if let username = username {
                params["username"] = username
            }
            _ = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/move", parameters: params)
        }
    }
    
    open func moveDirectory(_ source: String, target: String, username: String? = nil) throws {
        var params = ["source_path": source, "target_path": target]
        if let username = username {
            params["username"] = username
        }
        _ = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/move", parameters: params)
    }
    
    open func copyFile(_ sourceFile: String, targetDir: String, fileName: String, username: String? = nil) throws {
        if !sameDirectory(sourceFile, dir: targetDir) {
            var params = ["source_path": sourceFile, "target_path": targetDir, "target_filename": fileName]
            if let username = username {
                params["username"] = username
            }
            _ = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/copy", parameters: params)
        }
    }
    
    open func copyDirectory(_ source: String, targetDir:String, dirName: String, username: String? = nil) throws {
        try copyFile(source, targetDir: targetDir, fileName: dirName, username: username)
    }
    
    open func createDirectory(_ path: String, name: String, username: String? = nil) throws {
        var params = ["path": path, "name": name]
        if let username = username {
            params["username"] = username
        }
        _ = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/mkdir", parameters: params)
    }
    
    open func getFileSize(_ path: String) throws -> Int {
        let data = try nitrapi.client.dataGet("services/\(id as Int)/\(url)/file_server/size", parameters: ["path": path])
        return data!["size"] as! Int
    }
    
    open func supportsPermissions() -> Bool {
        return hasPermissions
    }
    
    open func chown(path: String, username: String, group: String, recursive: Bool = false) throws {
        if !hasPermissions {
            throw NitrapiError.nitrapiException(message: "This service does not support chown.", errorId: nil)
        }
        
        _ = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/chown", parameters: [
            "path": path,
            "username": username,
            "group": group,
            "recursive": recursive ? "1" : "0"
            ])
    }

    open func chmod(path: String, chmod: String, recursive: Bool = false) throws {
        if !hasPermissions {
            throw NitrapiError.nitrapiException(message: "This service does not support chmod.", errorId: nil)
        }
        
        _ = try nitrapi.client.dataPost("services/\(id as Int)/\(url)/file_server/chmod", parameters: [
            "path": path,
            "chmod": chmod,
            "recursive": recursive ? "1" : "0"
            ])
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
    
    open func writeFile(_ path: String, name: String, content: String, username: String? = nil) throws {
        let token = try getUploadToken(path, name: name, username: username)
        try nitrapi.client.rawPost((token?.url)!, token: (token?.token)!, body: content.data(using: String.Encoding.utf8)!)
    }
    
    
    func sameDirectory(_ path: String, dir: String) -> Bool {
        if let range = path.range(of: "/", options: .backwards) {
            return path.substring(to: path.index(before: range.upperBound)) == dir
        }
        return true
    }
}

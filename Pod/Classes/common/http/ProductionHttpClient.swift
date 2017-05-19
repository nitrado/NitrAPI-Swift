import Just

open class ProductionHttpClient {
    
    fileprivate var nitrapiUrl: String
    fileprivate var accessToken: String
    fileprivate var locale: String? = nil
    
    open fileprivate(set) var rateLimit: Int = 0
    open fileprivate(set) var rateLimitRemaining: Int = 0
    open fileprivate(set) var rateLimitReset: Int = 0
    
    
    public init (nitrapiUrl: String, accessToken: String) {
        self.nitrapiUrl = nitrapiUrl
        self.accessToken = accessToken
    }
    
    open func setLanguage(_ lang: String) {
        locale = lang
    }
    
    // MARK: - HTTP Operations
    
    /// send a GET request
    open func dataGet(_ url: String, parameters: Dictionary<String, String>) throws -> NSDictionary? {
        var params = parameters
        params["access_token"] = accessToken
        if let lc = locale { params["locale"] = lc }
        let res = Just.get(nitrapiUrl + url, params: params)
        
       return try parseResult(res)
    }
    
    /// send a POST request
    open func dataPost(_ url: String,parameters: Dictionary<String, String>) throws -> NSDictionary? {
        let res = Just.post(nitrapiUrl + url, params: ["access_token": accessToken, "locale": locale ?? "en"], data: parameters)

       return try parseResult(res)
        
    }
    
    /// send a DELETE request
    open func dataDelete(_ url: String, parameters: Dictionary<String, String>) throws -> NSDictionary? {
        let res = Just.delete(nitrapiUrl + url, params: ["access_token": accessToken, "locale": locale ?? "en"], data: parameters)
        
       return try parseResult(res)
    }
    
    
    func parseResult(_ res: HTTPResult) throws -> NSDictionary? {
        // get rate limit
        if (res.headers["X-RateLimit-Limit"] != nil) {
            rateLimit = Int(res.headers["X-RateLimit-Limit"]!)!
            rateLimitRemaining = Int(res.headers["X-RateLimit-Remaining"]!)!
            rateLimitReset = Int(res.headers["X-RateLimit-Reset"]!)!
        }
        
        var errorId: String? = nil
        if (res.headers["X-Raven-Event-ID"] != nil) {
            errorId = res.headers["X-Raven-Event-ID"]
        }
        
        let parsedObject: Any? = try JSONSerialization.jsonObject(with: res.text!.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
        
        var message: String = "Unknown error."
        
        if let result = parsedObject as? NSDictionary {
            if let status = result["status"] as? String {
                
                if status == "error" {
                    message = result["message"] as! String
                } else {
                
                    if let data = result["data"] as? NSDictionary {
                        return data
                    } else if let message = result["message"] as? String {
                        return ["message": message]
                    }
                }
            }
            
        }
        
        if let statusCode = res.statusCode {
            switch statusCode {
            case 428:
                throw NitrapiError.nitrapiConcurrencyException(message: message)
            case 503:
                throw NitrapiError.nitrapiMaintenanceException(message: message)
            default:
                throw NitrapiError.nitrapiException(message: message, errorId: errorId)
            }
        }
        
        
        throw NitrapiError.httpException(statusCode: res.statusCode ?? -1)
    }
    
    /// send a POST request with content
    open func rawPost(_ url: String, token: String, body: Data) throws {
        let res = Just.post(url, params: [:], headers: ["Token": token, "Content-Type": "application/binary"], requestBody: body )
        
        // get rate limit
        if (res.headers["X-RateLimit-Limit"] != nil) {
            rateLimit = Int(res.headers["X-RateLimit-Limit"]!)!
            rateLimitRemaining = Int(res.headers["X-RateLimit-Remaining"]!)!
            rateLimitReset = Int(res.headers["X-RateLimit-Reset"]!)!
        }
        
        // TODO: catch res not ok
        // TODO: check for text avaiability
        
        let parsedObject: Any? = try JSONSerialization.jsonObject(with: res.text!.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
        
        if let result = parsedObject as? NSDictionary {
            if let status = result["status"] as? String {
                
                if status == "error" {
                    // there has to be a message
                    throw NitrapiError.nitrapiException(message: result["message"] as! String, errorId: nil)
                }
                
                // everything was fine
                return
            }
            
        }
        if !res.ok {
            throw NitrapiError.httpException(statusCode: res.statusCode ?? -1)
        }
        throw NitrapiError.httpException(statusCode: -1)
    }
    
    
}

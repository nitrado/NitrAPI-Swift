import ObjectMapper

open class Dimension: Mappable {
    open fileprivate(set) var id: String!
    open fileprivate(set) var name: String?
    open fileprivate(set) var values: [String: DimensionValue]?
    
    // MARK: - Initialization
    
    public required init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        values  <- (map["values"], DimensionValuesTransform())
    }
    
    open func getValue(_ previousDimensions: [String?]) -> DimensionValue? {
        return values![calcPath(previousDimensions)]
    }
    
    open func getDefaultValue() -> DimensionValue? {
        return values!.values.first // TODO: from api?
    }
}

open class DimensionValue {
}

open class SimpleDimensionValue: DimensionValue {
    open fileprivate(set) var value: [Int]
    public init(value: [Int]) {
        self.value = value
    }
}

open class ComplexDimensionValue: DimensionValue {
    open fileprivate(set) var value: [NameDescription]
    public init(value: [NameDescription]) {
        self.value = value
    }
}
open class NameDescription: CustomStringConvertible  {
    open fileprivate(set) var key: String
    open fileprivate(set) var name: String
    open fileprivate(set) var desc: [String]
    public init(key: String, name: String, description: [String]) {
        self.name = name
        self.key = key
        self.desc = description
    }
    open var description: String {
        return name
    }
    
}
open class PriceDimensionValue: DimensionValue {
    open fileprivate(set) var value: Int
    public init(value: Int) {
        self.value = value
    }
}


open class DimensionValuesTransform: TransformType {
    public typealias Object = [String: DimensionValue]
    public typealias JSON = String
    
    open func transformFromJSON(_ value: Any?) -> [String: DimensionValue]? {
        var values = [String: DimensionValue]()
        let path: [String?] = []
        
        handleJson(value, path: path, values: &values)
        
        return values
    }
    
    
    func handleJson(_ json: Any?, path: [String?], values: inout [String: DimensionValue]) {
        if json == nil || json is NSNull {
            return
        }
        
        
        if let array = json as? [Int] {
            values[calcPath(path)] = SimpleDimensionValue(value: array)
            return
        }
        if let object = json as? [String: AnyObject] {
            let firstObj = object.first!.1
            if let firstObj = firstObj as? [String: AnyObject] {
                if firstObj.keys.contains("name") { // TODO: there are no dimensions named "name"
                    var intValues: [NameDescription] = []
                    
                    for entry in object.enumerated() {
                        if let obj = entry.element.1 as? [String: AnyObject] {
                            if let desc = obj["description"] as? [String] {
                                intValues.append(NameDescription(key: entry.element.0, name: obj["name"] as! String, description: desc))
                            }
                        }
                    }
                    
                    let value = ComplexDimensionValue(value: intValues)
                    values[calcPath(path)] = value
                    return
                }
            }

            // test if this is a price object
            for entry in object.enumerated() {
                if entry.element.0 == "price" {
                    let value = PriceDimensionValue(value: entry.element.1 as! Int)
                    values[calcPath(path)] = value
                    return
                }
            }
            
            // well, this just seems to be another dimension
            
            for entry in object.enumerated() {
                var newPath: [String?] = []
                for p in path {
                    newPath.append(p)
                }
                newPath.append(entry.element.0)
                
                handleJson(entry.element.1, path: newPath, values: &values)
            }
            
            return
        }
        
    }
    
    open func transformToJSON(_ value: [String: DimensionValue]?) -> String? {
        return "NOT IMPLEMENTED"
    }
    
}


public func calcPath(_ path: [String?]) -> String {
    var str = ""
    for p in path {
        if let p = p { // aka not nil
            str += "/\(p as String)"
        }
    }
    return str
}

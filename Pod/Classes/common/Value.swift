import ObjectMapper

public class Value : Equatable {
    public /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func ==(lhs: Value, rhs: Value) -> Bool {
        return lhs.value == rhs.value
    }

    public var value: String
    required public init(_ value: String) {
        var value = value
        self.value = value
    }
}

open class ValueTransform<T: Value>: TransformType {
    public typealias Object = T
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> T? {
        if let raw = value as? String {
            return T(raw)
        }
        return nil
    }
    
    open func transformToJSON(_ value: T?) -> String? {
        if let obj = value {
            return obj.value
        }
        return nil
    }
}

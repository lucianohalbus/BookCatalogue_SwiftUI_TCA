import Foundation

public protocol APICodable: Codable {
    init?(_ dictionary: [String: Any])
    init?(_ data: Data)
    func dictionary() -> [String: Any]?
    func jsonString() -> String
    func base64() -> String?
    static func from(_ base64: String) -> Self?
}

public extension APICodable {
    init?(_ dictionary: [String: Any]) {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let object: Self = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch {
            return nil
        }
    }
    
    init?(_ data: Data) {
        do {
            let decoder: JSONDecoder = JSONDecoder()
            let object: Self = try decoder.decode(Self.self, from: data)
            self = object
        } catch {
            print("\n❓JSONDecoder -> \(Self.self): \(error)\n")
            return nil
        }
    }
    
    init?(data: Data?) throws {
        guard let data = data else {
            return nil
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        let obj: Self = try decoder.decode(Self.self, from: data)
        self = obj
    }
    
    func dictionary() -> [String: Any]? {
        if let jsonData: Data = try? JSONEncoder().encode(self),
           let dict: [String: Any] = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return dict
        }
        return nil
    }
    
    func jsonString() -> String {
        if let data: Data = try? JSONEncoder().encode(self), let str: String = String(data: data, encoding: .utf8) {
            return str
        }
        return "{}"
    }
    
    func base64() -> String? {
        do {
            let jsonData: Data = try JSONEncoder().encode(self)
            return jsonData.base64EncodedString(options: .endLineWithCarriageReturn)
        } catch {
            return nil
        }
    }
    
    static func from(_ base64: String) -> Self? {
        do {
            guard let jsonData: Data = Data(base64Encoded: base64) else { return nil }
            let object: Self = try JSONDecoder().decode(Self.self, from: jsonData)
            return object
        } catch {
            return nil
        }
    }
    
    static func fromJsonString(_ string: String) -> Self? {
        let decoder: JSONDecoder = JSONDecoder()
        guard let data = string.data(using: .utf8),
            let result = try? decoder.decode(Self.self, from: data) else { return nil }
        return result
    }
    
    func toType<T: Codable>(_ model: T.Type) throws -> T {
        let data: Data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode(model, from: data)
    }
}

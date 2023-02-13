import Foundation

public enum APIError: Error {
    case generic
    case connection
    case parse(String)
}

extension APIError: Equatable {
    public var message: String {
        return localizedDescription
    }
    
    public var code: Int {
        switch self {
        case .generic:
            return 1
        case .connection:
            return 2
        case .parse:
            return 3
        }
    }
}

extension APIError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .generic:
            return "Something went wrong, please try again"
        case .connection:
            return "Connection issues"
        case let .parse(errorMessage):
            return "An error ocurred when trying to parse the request: \(errorMessage)"
        }
    }
}

extension APIError {
    public func getDescription() -> String {
        return (self as NSError).description
    }
}

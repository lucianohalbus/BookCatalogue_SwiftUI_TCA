//


import Foundation

/// HTTP Methods
public enum HTTPMethod: String {
   case GET
   case POST
   case DELETE
   case PUT
}

public protocol Fetcher {
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The task to be used in the request.
    var task: APICodable? { get }
    
    /// The request header key values
    var header: APICodable? { get }
}


enum BookListAPI {
    case fetch(_ term: String)
}

extension BookListAPI: Fetcher {
    
    var path: String {
        switch self {
        case let .fetch(term):
            return "https://www.googleapis.com/books/v1/volumes?q=\(term)&maxResults=\(20)&orderBy=newest"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .GET
        }
    }
    
    var header: APICodable? {
        switch self {
        case .fetch:
            return nil
        }
    }

    var task: APICodable? {
        switch self {
        case .fetch:
            return nil

        }
    }
}


import Foundation

/// Wrapps KNetwork requests to fetch JWT token.
open class NetworkProxy<T: Fetcher>: Network<T> {
    public func fetchData<V>(target: T, dataType: V.Type) async throws -> V where V: Decodable, V: Encodable {
        return try await withCheckedThrowingContinuation { continuation in
            super.fetch(target: target, dataType: dataType) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func fetchData<V>(target: T, optionalDataType: V.Type) async throws -> V? where V: Decodable, V: Encodable {
        return try await withCheckedThrowingContinuation { continuation in
            super.optionalFetch(target: target, dataType: optionalDataType) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func fetchData(target: T) async throws -> [String: Any] {
        return try await withCheckedThrowingContinuation { continuation in
            super.fetch(target: target) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

//

import Foundation

protocol BookListProviderProtocol {
    func fetchBookList(_ term: String) async throws -> BookListResponse

}

final class BookListProvider: NetworkProxy<BookListAPI>, BookListProviderProtocol {
    func fetchBookList(_ term: String) async throws -> BookListResponse {
        try await fetchData(target: .fetch(term), dataType: BookListResponse.self)
    }
        
}

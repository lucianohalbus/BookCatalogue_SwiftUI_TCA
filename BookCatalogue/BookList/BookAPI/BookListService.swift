//

import Foundation


public protocol BookListServiceProtocol {
    static func fetchBookList(_ term: String, completion: @escaping (Result<[BookListModel], Error>) -> Void) async throws
}

public final class BookListService: BookListServiceProtocol {
    public static func fetchBookList(_ term: String, completion: @escaping (Result<[BookListModel], Error>) -> Void) {
        
        let bookListProvider: BookListProviderProtocol = BookListProvider(debug: AppServiceLogs.API_BOOKS)
        
        Task {
            do {
                let bookListResponse: BookListResponse = try await bookListProvider.fetchBookList(term)
                let bookListModel: [BookListModel] = bookListResponse.toBookListModel(bookListResponse)
                completion(.success(bookListModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

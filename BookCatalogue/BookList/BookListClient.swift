//

import Combine
import Foundation
import ComposableArchitecture

struct BookListClient {
    var fetchBookList: (_ term: String) -> Effect<[BookListModel], Failure>
    
    
    enum Failure: Error, Equatable {
        case error(String)
    }
    
    enum BookListClientError: String {
        case fetchBookListError = "Unable to find books"
    }
}

extension BookListClient {
    static var live: BookListClient = BookListClient(
        fetchBookList: { term in
            .future { callback in
                BookListService.fetchBookList(term, completion: { result in
                    switch result {
                    case let .success(response):
                        callback(.success(response))
                    case let .failure(error):
                        callback(.failure(.error(BookListClientError.fetchBookListError.rawValue)))
                    }
                })
            }
        }
    )
}


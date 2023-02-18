//

import Foundation
import ComposableArchitecture


typealias BookListReducer = Reducer<BookListState, BookListAction, BookListEnvironment>

let bookReducer: BookListReducer = BookListReducer.combine(
    
    Reducer<BookListState, BookListAction, BookListEnvironment> { state, action, env in
        switch action {
            
        case let .setTitle(value):
            state.title = value
            struct EnterTerm: Hashable {}
            return Effect(value: .fetchbookList)
                .debounce(id: EnterTerm(), for: 1.0, scheduler: env.mainQueue)
            
        case let .setAuthor(value):
            state.author = value
            return .none
            
        case let .setDescription(value):
            state.description = value
            return .none
            
        case .fetchbookList:
            state.bookList = []
            let term: String = state.title
            return env.client.fetchBookList(term)
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(BookListAction.fetchBookListResponse)
            
        case let .fetchBookListResponse(.success(response)):
            state.bookList = response
            print(response)
            return .none
            
        case let .fetchBookListResponse(.failure(error)):
            print(error)
            return .none
            
            
        default:
            return .none
        } 
    }
)
    .binding()

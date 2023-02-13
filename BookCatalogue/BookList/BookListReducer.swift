//

import Foundation
import ComposableArchitecture


typealias BookListReducer = Reducer<BookListState, BookListAction, BookListEnvironment>

let bookReducer: BookListReducer = BookListReducer.combine(
    
    Reducer<BookListState, BookListAction, BookListEnvironment> { state, action, env in
        switch action {
            
        case let .setTitle(value):
            state.title = value
            return .none
            
        case let .setAuthor(value):
            state.author = value
            return .none
            
        case let .setDescription(value):
            state.description = value
            return .none
            
        case .addNewBook:
//            let model: BookListModel = BookListModel(
//                id: "",
//                title: state.title,
//                author: state.author,
//                description: state.description,
//                bookImage: URL(string: ""),
//                rating: state.rating,
//                favorite: state.favorite
//            )
            
//            state.bookList.append(model)
//
//            state.author = ""
//            state.title = ""
//            state.description = ""

            return .none
            
        case .fetchbookList:
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
            return .none
            
            
        default:
            return .none
        } 
    }
)
    .binding()

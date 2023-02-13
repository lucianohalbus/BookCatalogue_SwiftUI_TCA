//

import Foundation
import ComposableArchitecture

enum BookListAction: Equatable, BindableAction {
    case setTitle(String)
    case setAuthor(String)
    case setDescription(String)
    case setRationg(Double)
    case isFavotire(Bool)
    case addNewBook
    case fetchbookList
    case fetchBookListResponse(Result<[BookListModel], BookListClient.Failure>)
    case binding(BindingAction<BookListState>)

}

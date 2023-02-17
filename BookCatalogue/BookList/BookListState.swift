//

import Foundation
import ComposableArchitecture

struct BookListState: Equatable {
    @BindableState var title: String = ""
    @BindableState var description: String = ""
    @BindableState var rating: Double = 0
    @BindableState var favorite: Bool = false
    @BindableState var author: String = ""
    @BindableState var bookImage: String = ""
    var bookList: [BookListModel] = []
    
}

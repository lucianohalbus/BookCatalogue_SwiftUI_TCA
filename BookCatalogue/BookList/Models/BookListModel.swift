//

import Foundation

public struct BookListModel: Equatable, Identifiable {
    public var id: String
    public var title: String = ""
    public var author: String = ""
    public var description: String = ""
    public var bookImage: String = ""
    public var rating: Double = 0
    public var favorite: Bool = false
    public var date: String = ""
    
    public init(id: String, title: String, author: String, description: String, bookImage: String, rating: Double, favorite: Bool, date: String) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.bookImage = bookImage
        self.rating = rating
        self.favorite = favorite
        self.date = date
    }
    
}

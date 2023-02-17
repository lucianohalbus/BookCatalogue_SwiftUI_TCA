//

import Foundation

import Foundation

// MARK: - Welcome
public struct BookListResponse: APICodable, Equatable {
    let items: [Item]
    
    public init(items: [Item]) {
        self.items = items
        
    }
        public struct Item: APICodable, Equatable {
            let kind: Kind
            let id: String
            let volumeInfo: VolumeInfo
            
            public init(kind: Kind, id: String, volumeInfo: VolumeInfo) {
                self.kind = kind
                self.id = id
                self.volumeInfo = volumeInfo
            }
            
            public struct VolumeInfo: APICodable, Equatable {
                let title: String
                let authors: [String]
                let publishedDate: String
                let description: String?
                let imageLinks: ImageLinks
                let averageRating: Double?
                
                public init(title: String, authors: [String], publishedDate: String, description: String?, imageLinks: ImageLinks, averageRating: Double?) {
                    self.title = title
                    self.authors = authors
                    self.publishedDate = publishedDate
                    self.description = description
                    self.imageLinks = imageLinks
                    self.averageRating = averageRating
                }
                
                public struct ImageLinks: APICodable, Equatable {
                    let smallThumbnail, thumbnail: String
                    
                    public init(smallThumbnail: String, thumbnail: String) {
                        self.smallThumbnail = smallThumbnail
                        self.thumbnail = thumbnail
                    }
                }
                
            }
            
            public enum Kind: String, APICodable, Equatable {
                case booksVolume = "books#volume"
            }
        }
    
    
    func toBookListModel(_ bookListResponse: BookListResponse) -> [BookListModel] {
        
        var bookListModel: [BookListModel] = []
        
        for elements in items {
            if !elements.volumeInfo.imageLinks.smallThumbnail.isEmpty {
                let book: BookListModel = BookListModel(
                    id: elements.id,
                    title: elements.volumeInfo.title,
                    author: elements.volumeInfo.authors[0],
                    description: elements.volumeInfo.description ?? "",
                    bookImage: elements.volumeInfo.imageLinks.smallThumbnail,
                    rating: elements.volumeInfo.averageRating ?? 0,
                    favorite: false,
                    date: elements.volumeInfo.publishedDate
                )
                
                bookListModel.append(book)
                
                if bookListModel.count == 20 {
                    return bookListModel
                }
            }
  
        }
        
        return bookListModel
    }
    
}

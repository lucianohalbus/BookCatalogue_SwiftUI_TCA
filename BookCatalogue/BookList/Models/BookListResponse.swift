//

import Foundation

import Foundation

// MARK: - Welcome
public struct BookListResponse: APICodable, Equatable {
    let kind: String
    let totalItems: Int
    let items: [Item]
    
    public init(kind: String, totalItems: Int, items: [Item]) {
        self.kind = kind
        self.totalItems = totalItems
        self.items = items
    }
    
    func toBookListModel(_ bookListResponse: BookListResponse) -> [BookListModel] {
        
        var bookListModel: [BookListModel] = []
        
        for elements in items {
            let book: BookListModel = BookListModel(
                id: elements.id,
                title: elements.volumeInfo.title,
                author: elements.volumeInfo.authors.first ?? "",
                description: elements.volumeInfo.description ?? "",
                bookImage: elements.volumeInfo.imageLinks.smallThumbnail,
                rating: elements.volumeInfo.averageRating ?? 0,
                favorite: false
            )
            
            bookListModel.append(book)
  
        }
        
        return bookListModel
    }
    
}

// MARK: - Item
public struct Item: APICodable, Equatable {
    let kind: Kind
    let id, etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo
}

// MARK: - AccessInfo
public struct AccessInfo: APICodable, Equatable {
    let country: Country
    let viewability: Viewability
    let embeddable, publicDomain: Bool
    let textToSpeechPermission: TextToSpeechPermission
    let epub, pdf: Epub
    let webReaderLink: String
    let accessViewStatus: AccessViewStatus
    let quoteSharingAllowed: Bool
}

public enum AccessViewStatus: String, APICodable, Equatable {
    case none = "NONE"
    case sample = "SAMPLE"
}

public enum Country: String, APICodable, Equatable {
    case br = "BR"
}

// MARK: - Epub
public struct Epub: APICodable, Equatable {
    let isAvailable: Bool
    let acsTokenLink: String?
}

public enum TextToSpeechPermission: String, APICodable, Equatable {
    case allowed = "ALLOWED"
}

public enum Viewability: String, APICodable, Equatable {
    case noPages = "NO_PAGES"
    case partial = "PARTIAL"
}

public enum Kind: String, APICodable, Equatable {
    case booksVolume = "books#volume"
}

// MARK: - SaleInfo
public struct SaleInfo: APICodable, Equatable {
    let country: Country
    let saleability: Saleability
    let isEbook: Bool
    let listPrice, retailPrice: SaleInfoListPrice?
    let buyLink: String?
    let offers: [Offer]?
}

// MARK: - SaleInfoListPrice
public struct SaleInfoListPrice: APICodable, Equatable {
    let amount: Double
    let currencyCode: String
}

// MARK: - Offer
public struct Offer: APICodable, Equatable {
    let finskyOfferType: Int
    let listPrice, retailPrice: OfferListPrice
    let giftable: Bool
}

// MARK: - OfferListPrice
public struct OfferListPrice: APICodable, Equatable {
    let amountInMicros: Int
    let currencyCode: String
}

public enum Saleability: String, APICodable, Equatable {
    case forSale = "FOR_SALE"
    case notForSale = "NOT_FOR_SALE"
}

// MARK: - SearchInfo
public struct SearchInfo: APICodable, Equatable {
    let textSnippet: String
}

// MARK: - VolumeInfo
public struct VolumeInfo: APICodable, Equatable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let publisher: String?
    let publishedDate: String
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]
    let readingModes: ReadingModes
    let pageCount: Int?
    let printType: PrintType
    let categories: [String]
    let maturityRating: MaturityRating
    let allowAnonLogging: Bool
    let contentVersion: String
    let panelizationSummary: PanelizationSummary
    let imageLinks: ImageLinks
    let language: Language
    let previewLink: String
    let infoLink: String
    let canonicalVolumeLink: String
    let averageRating: Double?
    let ratingsCount: Int?
}

// MARK: - ImageLinks
public struct ImageLinks: APICodable, Equatable {
    let smallThumbnail, thumbnail: String
}

// MARK: - IndustryIdentifier
public struct IndustryIdentifier: APICodable, Equatable {
    let type: TypeEnum
    let identifier: String
}

public enum TypeEnum: String, APICodable, Equatable {
    case isbn10 = "ISBN_10"
    case isbn13 = "ISBN_13"
    case other = "OTHER"
}

public enum Language: String, APICodable, Equatable {
    case en = "en"
    case pt = "pt"
}

public enum MaturityRating: String, APICodable, Equatable {
    case notMature = "NOT_MATURE"
}

// MARK: - PanelizationSummary
public struct PanelizationSummary: APICodable, Equatable {
    let containsEpubBubbles, containsImageBubbles: Bool
}

public enum PrintType: String, APICodable, Equatable {
    case book = "BOOK"
}

// MARK: - ReadingModes
public struct ReadingModes: APICodable, Equatable {
    let text, image: Bool
}

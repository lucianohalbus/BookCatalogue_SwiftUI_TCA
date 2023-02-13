//

import SwiftUI
import ComposableArchitecture

@main
struct BookCatalogueApp: App {
    var body: some Scene {
        WindowGroup {
            BookSearchView(
                store: Store(
                    initialState: BookListState(),
                    reducer: bookReducer,
                    environment: BookListEnvironment()
                )
            )
        }
    }
}

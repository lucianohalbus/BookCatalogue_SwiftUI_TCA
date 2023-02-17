//

import SwiftUI
import ComposableArchitecture

struct BookSearchView: View {
    let store: Store<BookListState, BookListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .trailing) {
                
                searchTextField
                
                bookList
                
                
            }
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity)
        }
    }
    
    var addButton: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Button( action: {
                    viewStore.send(.addNewBook)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.horizontal, 10)
                }
                
            }
        }
    }
    
    var searchTextField: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 20) {
                TextField("Search a book title", text: viewStore.binding(
                    get: \.title,
                    send: BookListAction.setTitle))
                
                Button( action: {
                    viewStore.send(.fetchbookList)
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.gray)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.blue, lineWidth: 2))
        }
    }
    
    var bookList: some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    ForEach(viewStore.bookList) { item in
                        VStack {
                            HStack(alignment: .top) {
                                VStack {
                                    AsyncImage(
                                        url: URL(
                                            string: item.bookImage
                                        ),
                                        content: { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        },
                                        placeholder: {
                                            ProgressView()
                                        }
                                    )
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                        .lineLimit(3)
                                    Text(item.author)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .lineLimit(3)
                                    Text(item.date)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .lineLimit(3)
                                }
                            }
                            
                            Text(item.description)
                                .foregroundColor(.black)
                                .font(.headline)
                                .lineLimit(5)
                            
                            HStack {
                                Text("\(item.rating, specifier: "%.1f")")
                                    .font(.title3)
                                
                                Spacer()
                                
                                Image(systemName: item.favorite ?  "checkmark.square" : "square")
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listRowInsets(EdgeInsets())
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.blue, lineWidth: 2)
                )
            }
            .edgesIgnoringSafeArea(.all)
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity)
        }
    }
}

struct BookSearchView_Previews: PreviewProvider {
    static var previews: some View {
        BookSearchView(
            store: Store(
                initialState: BookListState(
                title: ""
                ),
                reducer: bookReducer,
                environment: BookListEnvironment()
            )
        )
    }
}

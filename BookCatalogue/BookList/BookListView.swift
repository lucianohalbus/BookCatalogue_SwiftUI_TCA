//

import SwiftUI
import ComposableArchitecture

struct BookListView: View {
    let store: Store<BookListState, BookListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .trailing) {

                addButton
                
                textFieldForm
                
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
    
    var textFieldForm: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                TextField("Title", text: viewStore.binding(
                    get: \.title,
                    send: BookListAction.setTitle))
                
                TextField("Author", text: viewStore.binding(
                    get: \.author,
                    send: BookListAction.setAuthor))
                
                TextField("Description", text: viewStore.binding(
                    get: \.description,
                    send: BookListAction.setDescription))
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
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.title)
                                .font(.title)
                                .foregroundColor(.black)
                            Text(item.author)
                                .font(.title3)
                                .foregroundColor(.black)
                            Text(item.description)
                                .foregroundColor(.black)
                                .font(.headline)
                                .lineLimit(nil)
                            
                            Spacer()
                            
                            HStack {
                                Text("\(item.rating, specifier: "%.1f")")
                                    .font(.title3)
                                
                                Spacer()
                                
                                Image(systemName: item.favorite ?  "checkmark.square" : "square")
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(
            store: Store(
                initialState: BookListState(
                title: "Livro",
                description: "descrição do livro",
                author: "Autor"
                ),
                reducer: bookReducer,
                environment: BookListEnvironment()
            )
        )
    }
}









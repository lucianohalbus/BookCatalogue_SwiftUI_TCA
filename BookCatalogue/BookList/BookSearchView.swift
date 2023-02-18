//

import SwiftUI
import ComposableArchitecture

struct BookSearchView: View {
    let store: Store<BookListState, BookListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                VStack {
                    
                    searchTextField

                    bookList

                }
            }
            .background {
                Color.black
                    .ignoresSafeArea()
            }
        }
    }

    var searchTextField: some View {
        WithViewStore(store) { viewStore in
            HStack {
                TextField("Search a book title", text: viewStore.binding(
                    get: \.title,
                    send: BookListAction.setTitle)
                )
                .foregroundColor(Color("ButtonForeground"))
 
                Button( action: {
                    viewStore.send(.fetchbookList)
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.horizontal)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("ButtonForeground"), lineWidth: 1))
            .padding(.horizontal)
        }
    }
    
    var bookList: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ScrollView {
                    ForEach(viewStore.bookList) { item in
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                AsyncImage(
                                    url: URL(
                                        string: item.bookImage
                                    ),
                                    content: { image in
                                        image
                                    },
                                    placeholder: {
                                        ProgressView()
                                    }
                                )
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundColor(Color("ButtonForeground"))
                                        .padding(.bottom, 5)
                                    Text(item.author)
                                        .font(.subheadline)
                                        .foregroundColor(Color("ButtonForeground"))
                                    Text(item.date)
                                        .font(.subheadline)
                                        .foregroundColor(Color("ButtonForeground"))
                                        .padding(.bottom, 5)
                                    Text(item.description)
                                        .foregroundColor(Color("ButtonForeground"))
                                        .font(.caption)
                                        .lineLimit(5)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(item.rating, specifier: "%.1f")")
                                    .font(.title3)
                                    .foregroundColor(Color("ButtonForeground"))
                                
                                Spacer()
                                
                                Image(systemName: item.favorite ?  "checkmark.square" : "square")
                                    .foregroundColor(Color("ButtonForeground"))
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        
                        Divider()
                            .background(Color.white)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct BookSearchView_Previews: PreviewProvider {
    static var previews: some View {
        BookSearchView(
            store: Store(
                initialState: BookListState(
                    bookList: [
                        BookListModel(
                            id: "e0yJEAAAQBAJ",
                            title: "SwiftUI Essentials - iOS 16 Edition",
                            author: "Neil Smyth",
                            description: "This book aims to teach the skills necessary to build iOS 16 applications using SwiftUI, Xcode 14, and the Swift 5.7 programming language. Beginning with the basics, this book outlines the steps to set up an iOS development environment, together with an introduction to using Swift Playgrounds to learn and experiment with Swift. The book also includes in-depth chapters introducing the Swift 5.7 programming language, including data types, control flow, functions, object-oriented programming, property wrappers, structured concurrency, and error handling. A guided tour of Xcode in SwiftUI development mode follows an introduction to the key concepts of SwiftUI and project architecture. The book also covers creating custom SwiftUI views and explains how these views are combined to create user interface layouts, including stacks, frames, and forms. Other topics covered include data handling using state properties and observable, state, and environment objects, as are key user interface design concepts such as modifiers, lists, tabbed views, context menus, user interface navigation, and outline groups. The book also covers graphics and chart drawing, user interface animation, view transitions and gesture handling, WidgetKit, document-based apps, Core Data, CloudKit, and SiriKit integration. Chapters also explain how to integrate SwiftUI views into existing UIKit-based projects and integrate UIKit code into SwiftUI. Finally, the book explains how to package up a completed app and upload it to the App Store for publication. Along the way, the topics covered in the book are put into practice through detailed tutorials, the source code for which is also available for download. The aim of this book, therefore, is to teach you the skills to build your own apps for iOS 16 using SwiftUI. Assuming you are ready to download the iOS 16 SDK and Xcode 14 and have an Apple Mac system, you are ready to get started.",
                            bookImage: "http://books.google.com/books/content?id=e0yJEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                            rating: 0.0,
                            favorite: false,
                            date: "2022-09-12"
                        ),
                        BookListModel(
                            id: "nL7JyQEACAAJ",
                            title: "SwiftUI for Absolute Beginners",
                            author: "Jayant Varma",
                            description: "Dive into the world of developing for all of Apple platforms with SwiftUI, Apple’s new framework that makes writing applications faster and easier with fewer lines of code. This book teaches the basics of SwiftUI to help you write amazing native applications using XCode. For developers already familiar with ReactNative, this book reviews the declarative, state-based DSL that manages the UI and updates it automatically will feel just like what they’re used to. You\'ll see how SwiftUI reduces the number of lines of code required to achieve the same effects by over 60% and provides a much better experience. Like the announcement of Swift in 2014, SwiftUI is expected to fundamentally change the way developing programmers approach coding iPhone and iPad applications. This book examines how SwiftUI lowers the entry barrier for developers to write amazing cross-platform applications for iOS and iPadOS as well as WatchOS, Mac OS, and TVOS. What You\'ll Learn Write code in the new SwiftUI syntax Combine views to arrange them for an application Add gestures and controls to an application Who This Book Is For Anyone who wants to learn to develop apps for the Mac, iPhone, iPad, and Apple Watch using the Swift programming language. No previous programming experience is necessary.",
                            bookImage: "http://books.google.com/books/content?id=nL7JyQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
                            rating: 0.0,
                            favorite: false,
                            date: "2019-11-13"
                        ),
                        BookListModel(
                            id: "hDgEEAAAQBAJ",
                            title: "SwiftUI Cookbook",
                            author: "Giordano Scalzo", description: "SwiftUI is an innovative new framework to build UI for all Apple platforms using Swift. This recipe-based guide covers the new features of SwiftUI 2 introduced on iOS14 and helps you migrate from UIkit with a simple learning curve through practical solutions. Learn how SwiftUI combines with Apple dev tools to build truly cross-platform Apple apps.",
                            bookImage: "http://books.google.com/books/content?id=hDgEEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                            rating: 0.0,
                            favorite: false,
                            date: "2020-10-19"
                        )
                    ]
                ),
                reducer: bookReducer,
                environment: BookListEnvironment()
            )
        )
    }
}

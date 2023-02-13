//

import Foundation
import ComposableArchitecture

struct BookListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
    var client: BookListClient = .live
}

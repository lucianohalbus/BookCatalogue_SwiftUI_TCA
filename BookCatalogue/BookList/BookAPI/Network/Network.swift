import Foundation

open class Network<T: Fetcher> {
    
    var debug: Bool
    
    public init(debug: Bool = false) {
        self.debug = debug
    }
    
    public func fetch<V: Codable>(
        target: T,
        dataType: V.Type,
        completion: ((Result<V, Error>) -> Void)?
    ) {
        let url: String = target.path
        let parameters: [String: Any] = target.task?.dictionary() ?? [:]
        let method: HTTPMethod = target.method
        
        guard let urlRequest: URL = URL(string: url) else {
            completion?(.failure(APIError.generic))
            return
        }
        
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerOpts: [String: Any] = target.header?.dictionary(), !headerOpts.isEmpty {
            target.header?.dictionary()?.forEach { key, value in
                if let value: String = value as? String {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        }

        let session: URLSession = URLSession.shared
        
        if method == .POST || method == .PUT || method == .DELETE {
            guard let httpBody: Data = try? JSONSerialization.data(withJSONObject: parameters, options: [.sortedKeys]) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { dataRequest, response, error in
            if self.debug {
                self.debugResponse(request, dataRequest, response, error)
            }
            
            guard let data: Data = dataRequest else {
                completion?(.failure(APIError.generic))
                return
            }
            
            do {
                let decoder: JSONDecoder = JSONDecoder()
                let decodedResponse: V = try decoder.decode(dataType.self, from: data)
                completion?(.success(decodedResponse))
            } catch {
                if self.debug {
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription )")
                    print(error as Any)
                    print("===========================\n\n")
                }
                
                completion?(.failure(APIError.parse(self.getParseMessage(dataRequest: dataRequest, request: request, response: response, error: error))))
                return
            }
        }
        .resume()
    }
    
    public func optionalFetch<V: Codable>(
        target: T,
        dataType: V.Type,
        completion: ((Result<V?, Error>) -> Void)?
    ) {
        let url: String = target.path
        let parameters: [String: Any] = target.task?.dictionary() ?? [:]
        let method: HTTPMethod = target.method
        
        guard let urlRequest: URL = URL(string: url) else {
            completion?(.failure(APIError.generic))
            return
        }
        
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerOpts: [String: Any] = target.header?.dictionary(), !headerOpts.isEmpty {
            target.header?.dictionary()?.forEach { key, value in
                if let value: String = value as? String {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        let session: URLSession = URLSession.shared
        
        if method == .POST || method == .PUT || method == .DELETE {
            guard let httpBody: Data = try? JSONSerialization.data(withJSONObject: parameters, options: [.sortedKeys]) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { dataRequest, response, error in
            if self.debug {
                self.debugResponse(request, dataRequest, response, error)
            }
            
            if let response: HTTPURLResponse = response as? HTTPURLResponse, [204, 205].contains(response.statusCode) {
                completion?(.success(nil))
                return
            }
            
            guard let data: Data = dataRequest else {
                completion?(.failure(APIError.generic))
                return
            }

            do {
                let decoder: JSONDecoder = JSONDecoder()
                let decodedResponse: V = try decoder.decode(dataType.self, from: data)
                completion?(.success(decodedResponse))
            } catch {
                if self.debug {
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription )")
                    print(error as Any)
                    print("===========================\n\n")
                }
                
                completion?(.failure(APIError.parse(self.getParseMessage(dataRequest: dataRequest, request: request, response: response, error: error))))
                return
            }
        }
        .resume()
    }
    
    public func fetch(
        target: T,
        completion: ((Result<[String: Any], Error>) -> Void)?
    ) {
        let url: String = target.path
        let parameters: [String: Any] = target.task?.dictionary() ?? [:]
        let method: HTTPMethod = target.method
        
        guard let urlRequest: URL = URL(string: url) else {
            completion?(.failure(APIError.generic))
            return
        }
        
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerOpts: [String: Any] = target.header?.dictionary(), !headerOpts.isEmpty {
            target.header?.dictionary()?.forEach { key, value in
                if let value: String = value as? String {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        let session: URLSession = URLSession.shared
        
        if method == .POST || method == .PUT || method == .DELETE {
            guard let httpBody: Data = try? JSONSerialization.data(withJSONObject: parameters, options: [.sortedKeys]) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { dataRequest, response, error in
            if self.debug {
                self.debugResponse(request, dataRequest, response, error)
            }
            
            guard let data: Data = dataRequest else {
                completion?(.failure(APIError.generic))
                return
            }
            
            do {
                if let response: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    completion?(.success(response))
                } else {
                    completion?(.failure(APIError.parse("Failed to parse as Dictionary")))
                }
            } catch {
                if self.debug {
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription )")
                    print(error as Any)
                    print("===========================\n\n")
                }
                
                completion?(.failure(APIError.parse(self.getParseMessage(dataRequest: dataRequest, request: request, response: response, error: error))))
                return
            }
        }
        .resume()
    }

    private func getParseMessage(dataRequest: Data?, request: URLRequest, response: URLResponse?, error: Error) -> String {
        var responseStatusCode: String = ""
        var responseBody: String = ""
        
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            responseStatusCode = String(httpResponse.statusCode)
        }
        
        if let data = dataRequest, let body = String(data: data, encoding: .utf8) {
            responseBody = body
        }
        
        var parseResponse: String = ""
        parseResponse += "[REQUEST_URL: \(request.url?.absoluteString ?? "")] "
        parseResponse += "[RESPONSE_CODE: \(responseStatusCode)] "
        parseResponse += "[RESPONSE_BODY: \(responseBody)] "
        parseResponse += "[PARSE: \(error.localizedDescription)]"
        
        return parseResponse
    }
}

private extension Network {
    private func debugResponse(
        _ request: URLRequest,
        _ responseData: Data?,
        _ response: URLResponse?,
        _ error: Error?
    ) {
        let uuid: String = UUID().uuidString
        print("\n↗️ ======= REQUEST =======")
        print("↗️ REQUEST #: \(uuid)")
        print("↗️ URL: \(request.url?.absoluteString ?? "")")
        print("↗️ HTTP METHOD: \(request.httpMethod ?? "GET")")
        
        if let requestHeaders: [String: String] = request.allHTTPHeaderFields,
           let requestHeadersData: Data = try? JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted),
           let requestHeadersString: String = String(data: requestHeadersData, encoding: .utf8) {
            print("↗️ HEADERS:\n\(requestHeadersString)")
        }
        
        if let requestBodyData: Data = request.httpBody,
           let requestBody: String = String(data: requestBodyData, encoding: .utf8) {
            print("↗️ BODY: \n\(requestBody)")
        }
        
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            print("\n↙️ ======= RESPONSE =======")
            switch httpResponse.statusCode {
            case 200...202, 204, 205:
                print("↙️ CODE: \(httpResponse.statusCode) - ✅")
            case 400...505:
                print("↙️ CODE: \(httpResponse.statusCode) - 🆘")
            default:
                print("↙️ CODE: \(httpResponse.statusCode) - ✴️")
            }
            
            if let responseHeadersData: Data = try? JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: .prettyPrinted),
               let responseHeadersString: String = String(data: responseHeadersData, encoding: .utf8) {
                print("↙️ HEADERS:\n\(responseHeadersString)")
            }
            
            if let responseBodyData: Data = responseData, let responseBody: String = String(data: responseBodyData, encoding: .utf8),
               !responseBody.isEmpty {
                
                print("↙️ BODY:\n\(responseBody)\n")
            }
        }
        
        if let urlError: URLError = error as? URLError {
            print("\n❌ ======= ERROR =======")
            print("❌ CODE: \(urlError.errorCode)")
            print("❌ DESCRIPTION: \(urlError.localizedDescription)\n")
        }
        
        print("======== END OF: \(uuid) ========\n\n")
    }
}

extension Date {
    enum DateFormatStyle: String {
        case longDateTime = "dd/MM/yyyy 'às' HH:mm"
        case longDateTimeDetailed = "dd/MM/yyyy 'às' HH:mm:SS"
        case shortDate = "dd/MM/yyyy"
        case reversedStashedDate = "yyyy-MM-dd"
        case longDateTimeGMT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case longDateTimeGMTLoan = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        case longDateTimeGMTQuickSale = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case longDateTimeGMTRewards = "yyyy-MM-dd'T'HH:mm:ss"
        case longDateTimeGMTServices = "yyyy-MM-dd HH:mm:ss.SSS"
        case longDateTimeGMTShellbox = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case fullDateWithTimeZone = "yyyy-MM-dd'T'HH:mm:ssZ"
        case shortDayMonthDate = "dd MMM"
        case dayMonthDate = "dd/MM"
        case longDateTimeDetailGMT = "yyyy-MM-dd HH:mm:SS"
        case monthYear = "MM/yy"
        case timeDate = "HH:mm"
        case longDateTimeBRT = "dd/MM/yyyy HH:mm:ss"
        case longDateDetail = "dd 'de' MMMM 'de' yyyy"
        case middleDateHour = "yyMMddHHmm"
        case yearDate = "yyyy"
        case shortMonthName = "MMM"
        case monthAndYearName = "MMMM yyyy"
        case month = "MMMM"
        case longDateTimeGMTPaymentLink = "yyyy-MM-dd'T'23:59:59ZZZZZ"
    }
    
    func toString(with format: DateFormatStyle) -> String {
        return toString(withFormat: format.rawValue)
    }
    
    func toString(withFormat: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
    
    func isDateOver(_ years: Int) -> Bool {
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: self, to: Date())
        guard let age: Int = ageComponents.year else {
            return false
        }
        return age >= years
    }
}

extension TimeInterval {
    func toString() -> String {
        String(self)
    }
}

extension Date {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            return true
        }
        return false
    }
}

extension Date {
    func years(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
}


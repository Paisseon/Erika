import Foundation
import Jinx

// Dangerops pirit repo? will it hurt iPhone top of his head?

private struct SafetyData: Codable {
    let uri: String
    let safe: Bool
}

private struct SafetyResult: Codable {
    let status: String
    let data: [SafetyData]
    let count: Int
    let date: String
}

struct SileoPiracyHook: Hook {
    typealias URLHandler = @Sendable (Data?, URLResponse?, Error?) -> Void
    typealias T = @convention(c) (URLSession, Selector, URLRequest, @escaping (URLHandler)) -> URLSessionDataTask
    
    let cls: AnyClass? = URLSession.self
    let sel: Selector = sel_registerName("dataTaskWithRequest:completionHandler:")
    let replace: T = { obj, sel, request, handler in
        guard request.url?.absoluteString.contains("/repository/safety") == true else {
            return orig(obj, sel, request, handler)
        }
        
        let newHandler: URLHandler = { (data, response, error) in
            if let data, var result: SafetyResult = try? JSONDecoder().decode(SafetyResult.self, from: data) {
                let newSafetyData: [SafetyData] = result.data.map { SafetyData(uri: $0.uri, safe: true) }
                let newResult: SafetyResult = .init(status: "200 OK", data: newSafetyData, count: result.count, date: result.date)
                let newData: Data? = try? JSONEncoder().encode(newResult)
                
                handler(newData, response, error)
            } else {
                handler(data, response, error)
            }
        }
        
        return orig(obj, sel, request, newHandler)
    }
}

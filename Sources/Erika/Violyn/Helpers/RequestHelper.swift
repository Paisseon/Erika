//
//  RequestHelper.swift
//  Violyn
//
//  Created by Lilliana on 27/11/2022.
//

import Foundation

struct RequestHelper {
    static let token: String = "&__RequestVerificationToken=b%2BsiLdIH65m5AVq2Xk7B0VHudOFB%2BrddgeMKqSSaYhNNEHULqRRQbNWkLDrPB%2FT%2F2aCx0RIJUz3w5UVygR6StTykyxlNxGWo3iWYC5eIjljDNHYcM5AL9MbQagSUy6YKs%2BkyXg%3D%3D"
    static let cookie: String = "ChomikSession=d3fb23c6-430d-456c-b729-bbb72fefaf99; __RequestVerificationToken_Lw__=w8xQ4U9IcdB71uD/zSxUsJXuEQQOsI1Dogfg9d4xN3p0xxRp/wTg+oqiDdqIYGZfhEfswCKnlA47H0IBDt53LrdOy7oCNzKdOdp/lTwQAn/Zw++5skZFvLLcktKreTD7mZMZTQ==; rcid=3; guid=999f1623-f0ea-4497-8775-50832b6258df;"

    @inlinable
    static func headers(
        from dict: [String: String],
        for request: inout URLRequest
    ) {
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        dict.forEach { (key, val) in
            request.setValue(val, forHTTPHeaderField: key)
        }
    }
    
    @inlinable
    static func send<T: Decodable>(
        _ request: URLRequest
    ) async throws -> T? {
        let (data, _): (Data, _) = try await URLSession.shared.data14(for: request)
        
        if let json: T = try JSONDecoder().decode(T?.self, from: data) {
            return json
        }
        
        return nil
    }
    
    @inlinable
    static func string(
        from request: URLRequest
    ) async throws -> String {
        let (data, _): (Data, _) = try await URLSession.shared.data14(for: request)
        let dataString: String = .init(decoding: data, as: UTF8.self)
        
        return dataString
    }
}

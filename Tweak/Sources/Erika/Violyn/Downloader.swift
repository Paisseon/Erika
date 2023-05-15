import Foundation
import Jinx

private struct Response: Decodable {
    let redirectURL: URL
    
    enum CodingKeys: String, CodingKey {
        case redirectURL = "redirectUrl"
    }
}

struct Downloader {
    static func download(
        package: String,
        version: String
    ) async throws {
        let erikaURL: URL = .init(fileURLWithPath: "/var/mobile/Media/Erika")
        
        if access(erikaURL.path, F_OK) != 0 {
            mkdir(erikaURL.path, S_IRWXU | S_IRWXG | S_IRWXO)
        }
        
        #if JINX_ROOTLESS
        let id: Int = try await {
            if let _id: Int = try? await fileID(forPackage: package, version: version, arch: "iphoneos-arm64") { return _id }
            return try await fileID(forPackage: package, version: version, arch: "iphoneos-arm")
        }()
        #else
        let id: Int = try await fileID(forPackage: package, version: version, arch: "iphoneos-arm")
        #endif
        
        let licURL: URL = .init(string: "https://chomikuj.pl/action/License/Download")!
        let licBody: Data = "fileId=\(id)\(token)".data(using: .utf8)!
        var licReq: URLRequest = .init(url: licURL)
        
        licReq.httpMethod = "POST"
        licReq.httpBody = licBody
        licReq.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        licReq.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        let licData: Data = try await URLSession.shared.data(for: licReq).0
        let license: Response = try JSONDecoder().decode(Response.self, from: licData)
        let dlURL: URL
        
        if #available(iOS 15.0, *) {
            dlURL = try await URLSession.shared.download(from: license.redirectURL).0
        } else {
            dlURL = try await withCheckedThrowingContinuation { continuation in
                let dlReq: URLRequest = .init(url: license.redirectURL)
                let task: URLSessionDownloadTask = URLSession.shared.downloadTask(with: dlReq) { url, _, error in
                    if let url { continuation.resume(returning: url) }
                    if let error { continuation.resume(throwing: error) }
                }
                
                task.resume()
            }
        }
        
        guard access(dlURL.path, F_OK) == 0 else {
            throw "Couldn't save downloaded tweak"
        }
        
        try FileManager.default.moveItem(at: dlURL, to: erikaURL.appendingPathComponent("\(package)_\(version)_iphoneos-arm.deb"))
    }
    
    private static func fileID(
        forPackage package: String,
        version: String,
        arch: String
    ) async throws -> Int {
        let url: URL = .init(string: "https://chomikuj.pl/farato/Dokumenty/debfiles/\(package)_v\(version)_\(arch).deb")!
        let (data, response): (Data, URLResponse) = try await URLSession.shared.data(from: url)
        let contents: String = .init(decoding: data, as: UTF8.self)
        
        guard (response as? HTTPURLResponse)?.statusCode != 404 else {
            throw "\(package) was not found on the server"
        }
        
        if let range: Range<String.Index> = contents.range(of: #"\d{10}(?=.d)"#, options: .regularExpression),
           let ret: Int = .init(contents[range].description)
        {
            return ret
        }
        
        throw "\(package) does not have a valid file ID"
    }
    
    private static let token: String = "REDACTED"
    private static let cookie: String = "REDACTED"
}

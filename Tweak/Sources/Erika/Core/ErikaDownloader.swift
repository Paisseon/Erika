import Chomikuj
import Foundation

struct ErikaDownloader {
    private static let apiKey: String = "REDACTED"
    
    static func download(
        package: String,
        version: String
    ) async throws {
        let (id, arch): (Int, String) = try await fileID(package: package, version: version)
        let url: URL = .init(string: "https://api.cypwn.xyz/@hamster/redirect/\(id)")!
        var request: URLRequest = .init(url: url)
        
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let data: Data = try await URLSession.shared.data(for: request).0
        let ddlURL: URL = try JSONDecoder().decode(Redirect.self, from: data).redirectURL
        let fileURL: URL = try await URLRequest(url: ddlURL).download()
        let destURL: URL = .init(fileURLWithPath: "/var/mobile/Media/Erika/\(package)_v\(version)_\(arch).deb")
        
        try FileManager.default.moveItem(at: fileURL, to: destURL)
    }
    
    private static func fileID(
        package: String,
        version: String,
        isFallback: Bool = false
    ) async throws -> (Int, String) {
        let arch: String = isFallback ? "iphoneos-arm" : CurrentTweak.arch
        let url: URL = .init(string: "https://chomikuj.pl/farato/Dokumenty/debfiles/\(package)_v\(version)_\(arch).deb")!
        let (data, response): (Data, URLResponse) = try await URLSession.shared.data(from: url)
        let contents: String = .init(decoding: data, as: UTF8.self)
        
        guard (response as? HTTPURLResponse)?.statusCode != 404,
              let range: Range<String.Index> = contents.range(of: #"\d{10}(?=.d)"#, options: .regularExpression),
              let id: Int = .init(String(contents[range]))
        else {
            if CurrentTweak.arch == "iphoneos-arm64" && !isFallback {
                return try await fileID(package: package, version: version, isFallback: true)
            }
            
            throw "\(CurrentTweak.displayName) \(version) hasn't been pirated yet"
        }
        
        return (id, arch)
    }
}

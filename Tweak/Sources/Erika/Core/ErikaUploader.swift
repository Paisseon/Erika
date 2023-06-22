import Chomikuj
import Foundation

struct ErikaUploader {
    static func upload(
        package: String,
        version: String,
        localURL url: URL
    ) async throws {
        guard access(url.path, F_OK) == 0 else {
            throw "Couldn't find file at local URL"
        }
        
        let existURL: URL = .init(string: "https://chomikuj.pl/farato/Dokumenty/debfiles/" + url.lastPathComponent)!
        let response: URLResponse = try await URLSession.shared.data(from: existURL).1
        
        guard (response as? HTTPURLResponse)?.statusCode == 404 else {
            throw "\(CurrentTweak.displayName) \(version) already exists on the server"
        }
        
        let uploadResponse: [String: [FileMeta]] = try await sendUpload(for: url)
        let debSize: UInt64 = url.fileSize
        let retSize: UInt64 = uploadResponse["files"]?.first?.size ?? 1
        
        let ping: Ping = .init(
            isSuccess: debSize == retSize,
            fileName: url.lastPathComponent,
            fileSize: String(retSize / 1000),
            udidHash: getUDID()
        )
        
        try await sendPing(ping)

        guard ping.isSuccess else {
            throw "Uploaded file and local file size mismatch"
        }
    }
    
    private static func getMultipart(
        from url: URL,
        fileName: String
    ) async throws -> Data {
        var body: Data = .init()
        let fileData: Data = try Data(contentsOf: url)
        
        body.append("------WebKitFormBoundary13bNeybuFGg8rkAB\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \"application/octet-stream\"\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("------WebKitFormBoundary13bNeybuFGg8rkAB--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    private static func getUDID() -> String {
        typealias MGCopyAnswerFunc = @convention(c) (CFString) -> CFString
        
        let gestalt: UnsafeMutableRawPointer = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY)
        let MGCopyAnswer: MGCopyAnswerFunc = unsafeBitCast(dlsym(gestalt, "MGCopyAnswer"), to: MGCopyAnswerFunc.self)
        let udid: String = MGCopyAnswer("UniqueDeviceID" as CFString) as String
        return udid.sha1() ?? "NULL"
    }
    
    private static func getUploadURL(fileName: String) async throws -> URL {
        let url: URL = .init(string: "https://api.cypwn.xyz/@hamster/upload")!
        var request: URLRequest = .init(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "udidHash=\(getUDID())&fileName=\(fileName)".data(using: .utf8)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let data: Data = try await URLSession.shared.data(for: request).0
        let response: NeoUploadResponse = try JSONDecoder().decode(NeoUploadResponse.self, from: data)
        
        return response.uploadURL
    }
    
    private static func sendPing(_ ping: Ping) async throws {
        let url: URL = .init(string: "https://api.cypwn.xyz/@hamster/final")!
        var request: URLRequest = .init(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "success=\(ping.isSuccess)&fileName=\(ping.fileName)&fileSize=\(ping.fileSize)&udidHash=\(ping.udidHash)".data(using: .utf8)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    private static func sendUpload(for url: URL) async throws -> [String: [FileMeta]] {
        let uploadURL: URL = try await getUploadURL(fileName: url.lastPathComponent)
        let debData: Data = try await getMultipart(from: url, fileName: url.lastPathComponent)
        var request: URLRequest = .init(url: uploadURL)
        
        request.httpMethod = "POST"
        request.httpBody = debData
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.setValue(cookie, forHTTPHeaderField: "Cookie")
        request.setValue("close", forHTTPHeaderField: "Connection")
        request.setValue("https://chomikuj.pl/farato/Dokumenty/debfiles", forHTTPHeaderField: "Referer")
        request.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; boundary=----WebKitFormBoundary13bNeybuFGg8rkAB", forHTTPHeaderField: "Content-Type")
        
        let data: Data = try await URLSession.shared.data(for: request).0
        let response: [String: [FileMeta]] = try JSONDecoder().decode([String: [FileMeta]].self, from: data)
        
        return response
    }
    
    private static let apiKey: String = "REDACTED"
    private static let cookie: String = "REDACTED"
}

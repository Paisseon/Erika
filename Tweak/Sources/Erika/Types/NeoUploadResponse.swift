import Foundation

struct NeoUploadResponse: Decodable {
    let uploadURL: URL
    
    enum CodingKeys: String, CodingKey {
        case uploadURL = "upload_url"
    }
}

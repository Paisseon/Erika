import Foundation

struct Redirect: Decodable {
    let redirectURL: URL
    
    enum CodingKeys: String, CodingKey {
        case redirectURL = "redirectUrl"
    }
}

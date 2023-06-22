import Foundation
import CommonCrypto

extension String {
    func sha1() -> String? {
        guard let data: Data = self.data(using: .utf8) else {
            return nil
        }
        
        var digest: [UInt8] = .init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        data.withUnsafeBytes { _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest) }
        
        let hexBytes: [String] = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

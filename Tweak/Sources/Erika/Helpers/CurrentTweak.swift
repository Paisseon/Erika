import UIKit

struct CurrentTweak {
    static var currentDepiction: UIViewController? = nil
    static var displayName: String = ""
    static var isPaid: Bool = false
    static var package: String = ""
    static var version: String = ""
    static var hashMap: [String: (String, String, Bool)] = [:] // [sha256: (package, version, isPaid)]
    
    #if JINX_ROOTLESS
    static let arch: String = "iphoneos-arm64"
    #else
    static let arch: String = "iphoneos-arm"
    #endif
}

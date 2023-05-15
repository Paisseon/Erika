import UIKit

final class Observer {
    static let shared: Observer = .init()
    var currentDepiction: UIViewController? = nil
    
    private init() {
        if CommandLine.arguments[0].hasSuffix("chromatic") {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.handleCopy),
                name: UIPasteboard.changedNotification,
                object: nil
            )
        }
    }
    
    @objc private func handleCopy() {
        guard let control: String = UIPasteboard.general.string,
              let pRange: Range<String.Index> = control.range(of: #"(?<=package:\s)[^\s]*\b"#, options: .regularExpression),
              let vRange: Range<String.Index> = control.range(of: #"(?<=version:\s)[^\s]*\b"#, options: .regularExpression)
        else {
            return
        }
        
        ErikaWindow.shared.package = control[pRange].description
        ErikaWindow.shared.version = control[vRange].description
    }
}

import UIKit

final class Observer {
    static let shared: Observer = .init()
    var currentDepiction: UIViewController? = nil
    
    private init() {
        if Bundle.main.bundleIdentifier == ErikaApp.saily.rawValue {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.handleCopy),
                name: UIPasteboard.changedNotification,
                object: nil
            )
        }
    }
    
    @objc
    func handleCopy() {
        guard let control: String = UIPasteboard.general.string,
              let pRange: Range<String.Index> = control.range(of: #"(?<=package:\s)[^\s]*\b"#, options: .regularExpression),
              let vRange: Range<String.Index> = control.range(of: #"(?<=version:\s)[^\s]*\b"#, options: .regularExpression)
        else {
            return
        }

        Task {
            await Progress.shared.setPackage(String(control[pRange]))
            await Progress.shared.setVersion(String(control[vRange]))

            DispatchQueue.main.async { [self] in
                if let currentDepiction,
                   ErikaWindow.shared.rootViewController != nil,
                   currentDepiction.presentedViewController !== ErikaWindow.shared.rootViewController
                {
                    currentDepiction.present(ErikaWindow.shared.rootViewController!, animated: true)
                }
            }
        }
    }
}

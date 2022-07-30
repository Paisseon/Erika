import Orion
import ErikaC
import UIKit

class SailyLabel: ClassHook<UILabel> {
    typealias Group = Saily
    
    func setText(_ text: String) {
        if text == "Copy Meta" {
            orig.setText("Erika")
        } else if text.contains("Copy Meta") {
            orig.setText("   Erika")
        } else {
            orig.setText(text)
        }
    }
}

class SailyHook: ClassHook<UIViewController> {
    static let targetName = "chromatic.PackageController"
    typealias Group       = Saily
    
    func viewDidLoad() {
        orig.viewDidLoad()
        NotificationCenter.default.addObserver(target, selector: #selector(self.erikaDownload), name: UIPasteboard.changedNotification, object: nil)
        // note: the tweak icon is target.view.subviews[0].subviews[2].subviews[0]. in case this doesn't work in the future for some reason
    }
    
    // orion:new
    @objc func erikaDownload() {
        guard let control = UIPasteboard.general.string, control.contains("package:"), control.contains("version"),
              let packageRange: Range<String.Index> = control.range(of: #"(?<=package:\s)[^\s]*\b"#, options: .regularExpression),
              let versionRange: Range<String.Index> = control.range(of: #"(?<=version:\s)[^\s]*\b"#, options: .regularExpression) else { return }
        
        let package = String(control[packageRange])
        let version = String(control[versionRange])
        
        ec.displayErika(withPackage: package, andVersion: version, inVC: target)
    }
}
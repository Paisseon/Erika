import Orion
import ErikaC
import UIKit

class InstallerHook: ClassHook<UIViewController> {
    static let targetName = "DepictionViewController"
    typealias Group       = Installer
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        target.topTweakIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(self.erikaDownload))
        
        target.topTweakIcon.addGestureRecognizer(tapGesture)
    }
    
    // orion:new
    @objc func erikaDownload() {
        guard let package = target.packageDictionary["identifier"] as? String else { return }
        guard let version = target.packageDictionary["version"] as? String else { return }
        
        ErikaController.shared.displayGui(withTitle: package, version: version)
    }
}
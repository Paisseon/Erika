import Orion
import ErikaC
import UIKit

class ZebraHook: ClassHook<UIViewController> {
    static let targetName = "ZBPackageDepictionViewController"
    typealias Group       = Zebra
    
    func viewDidLoad() {
        orig.viewDidLoad()
        
        target.packageIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(self.erikaDownload))
        
        target.packageIcon.addGestureRecognizer(tapGesture)
    }
    
    // orion:new
    @objc func erikaDownload() {
        guard let package = target.package.identifier else { return }
        guard let version = target.package.version else { return }
        
        ErikaController.shared.displayGui(withTitle: package, version: version)
    }
}
import SwiftUI
import UIKit

final class ErikaWindow: UIWindow {
    static let shared: ErikaWindow = .init()
    
    private var _package: String = ""
    private var _version: String = ""
    private var view: ErikaView = .init(package: "", version: "")
    
    var package: String {
        get { _package }
        set { _package = newValue; setRootVC(); }
    }
    var version: String {
        get { _version }
        set { _version = newValue; setRootVC(); }
    }
    
    private func setRootVC() {
        let rootVC: UIHostingController = .init(rootView: ErikaView(package: package, version: version))
        rootVC.view.backgroundColor = .clear
        rootVC.view.layer.cornerCurve = .continuous
        
        self.rootViewController = rootVC
    }
    
    override func makeKeyAndVisible() {
        self.alpha = 0
        super.makeKeyAndVisible()
        
        UIView.animate(withDuration: 0.5, animations: { ErikaWindow.shared.alpha = 1 })
    }
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        setRootVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

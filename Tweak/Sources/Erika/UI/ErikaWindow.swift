import SwiftUI
import UIKit

final class ErikaWindow: UIWindow {
    static let shared: ErikaWindow = .init()
    
    override func makeKeyAndVisible() {
        setRootVC(package: CurrentTweak.package, version: CurrentTweak.version)
        self.alpha = 0
        super.makeKeyAndVisible()
        
        UIView.animate(withDuration: 0.5, animations: { ErikaWindow.shared.alpha = 1 })
    }
    
    private func setRootVC(
        package: String,
        version: String
    ) {
        let rootVC: UIHostingController = .init(rootView: ErikaView(package: package, version: version))
        rootVC.view.backgroundColor = .clear
        rootVC.view.layer.cornerCurve = .continuous
        
        self.rootViewController = rootVC
    }
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        setRootVC(package: "com.example.tweak", version: "1.0.0")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

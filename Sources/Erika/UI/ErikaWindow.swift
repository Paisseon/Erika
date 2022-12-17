import SwiftUI
import UIKit

final class ErikaWindow: UIWindow {
    // MARK: Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rootVC: UIHostingController = .init(rootView: ErikaView())
        rootVC.view.backgroundColor = .clear
        rootVC.view.layer.cornerCurve = .continuous
        
        self.rootViewController = rootVC
    }

    // MARK: Internal

    static let shared: ErikaWindow = .init(frame: UIScreen.main.bounds)

    // MARK: Private

    private let progress: Progress = .shared
}

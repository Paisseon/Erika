import UIKit

struct Installer5Hook: Hook {
    
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let `class`: AnyClass? = objc_getClass("DepictionViewController") as? AnyClass
    let selector: Selector = #selector(UIViewController.viewDidLoad)
    let replacement: T = { target, cmd in
        let orig: T = PowPow.unwrap(Installer5Hook.self)!
        orig(target, cmd)
        
        let gesture = BindableGesture {
            if let packageDictionary: NSMutableDictionary = target.value(forKey: "packageDictionary") as? NSMutableDictionary,
               let package: String = packageDictionary["identifier"] as? String,
               let version: String = packageDictionary["version"] as? String
            {
                Task {
                    await Progress.shared.setPackage(package)
                    await Progress.shared.setVersion(version)
                    
                    DispatchQueue.main.async {
                        ErikaWindow.shared.makeKeyAndVisible()
                    }
                }
            }
        }
        
        if let topTweakIcon: UIImageView = target.value(forKey: "topTweakIcon") as? UIImageView {
            topTweakIcon.isUserInteractionEnabled = true
            topTweakIcon.addGestureRecognizer(gesture)
        }
    }
}

import UIKit

struct ZebraHook: Hook {
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let `class`: AnyClass? = objc_getClass("ZBPackageDepictionViewController") as? AnyClass
    let selector: Selector = #selector(UIViewController.viewDidLoad)
    let replacement: T = { target, cmd in
        let orig: T = PowPow.unwrap(ZebraHook.self)!
        orig(target, cmd)
        
        let gesture = BindableGesture {
            if let tPackage: NSObject = target.value(forKey: "package") as? NSObject,
               let package: String = tPackage.value(forKey: "identifier") as? String,
               let version: String = tPackage.value(forKey: "version") as? String
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
        
        if let packageIcon: UIImageView = target.value(forKey: "packageIcon") as? UIImageView {
            packageIcon.isUserInteractionEnabled = true
            packageIcon.addGestureRecognizer(gesture)
        }
    }
}

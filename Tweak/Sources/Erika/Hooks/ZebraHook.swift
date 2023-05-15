import Jinx
import UIKit

struct ZebraHook: Hook {
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let cls: AnyClass? = objc_getClass("ZBPackageDepictionViewController") as? AnyClass
    let sel: Selector = #selector(UIViewController.viewDidLoad)
    let replace: T = { obj, sel in
        orig(obj, sel)
        
        let gesture = BindableGesture {
            if let tPackage: NSObject = obj.value(forKey: "package") as? NSObject,
               let package: String = tPackage.value(forKey: "identifier") as? String,
               let version: String = tPackage.value(forKey: "version") as? String
            {
                ErikaWindow.shared.package = package
                ErikaWindow.shared.version = version
                ErikaWindow.shared.makeKeyAndVisible()
            }
        }
        
        if let packageIcon: UIImageView = obj.value(forKey: "packageIcon") as? UIImageView {
            packageIcon.isUserInteractionEnabled = true
            packageIcon.addGestureRecognizer(gesture)
        }
    }
}

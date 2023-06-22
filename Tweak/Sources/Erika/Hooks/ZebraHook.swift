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

        guard let tPackage: NSObject = obj.value(forKey: "package") as? NSObject,
              let package: String = tPackage.value(forKey: "identifier") as? String,
              let version: String = tPackage.value(forKey: "version") as? String,
              let isPaid: Bool = tPackage.value(forKey: "requiresAuthorization") as? Bool,
              let name: String = tPackage.value(forKey: "name") as? String,
              let sha256Hash: String = tPackage.value(forKey: "sha256") as? String
        else {
            return
        }

        CurrentTweak.package = package
        CurrentTweak.version = version
        CurrentTweak.isPaid = isPaid
        CurrentTweak.displayName = name
        CurrentTweak.hashMap[sha256Hash] = (package, version, isPaid)

        let gesture = BindableGesture { ErikaWindow.shared.makeKeyAndVisible() }

        if let packageIcon: UIImageView = obj.value(forKey: "packageIcon") as? UIImageView {
            packageIcon.isUserInteractionEnabled = true
            packageIcon.addGestureRecognizer(gesture)
        }
    }
}

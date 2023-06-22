import Jinx
import UIKit
import os

struct SileoHook: Hook {
    typealias T = @convention(c) (UIViewController, Selector) -> Void

    let cls: AnyClass? = objc_getClass("Sileo.PackageViewController") as? AnyClass
    let sel: Selector = #selector(UIViewController.viewDidLoad)
    let replace: T = { obj, sel in
        orig(obj, sel)
        
        guard let icon: UIImageView = obj.value(forKey: "packageIconView") as? UIImageView,
              let packageObj: AnyObject = Ivar.get("package", for: obj),
              let package: String = Ivar.get("packageID", for: packageObj),
              let version: String = Ivar.get("version", for: packageObj),
              let isPaid: Bool = Ivar.get("commercial", for: packageObj),
              let packageName: String = Ivar.get("name", for: packageObj),
              let rawControl: [String: String] = Ivar.get("rawControl", for: packageObj),
              let expectHash: String = rawControl["sha256"]
        else {
            return
        }
        
        CurrentTweak.package = package
        CurrentTweak.version = version
        CurrentTweak.isPaid = isPaid
        CurrentTweak.displayName = packageName
        CurrentTweak.hashMap[expectHash] = (package, version, isPaid)
        
        let gesture = BindableGesture {
            ErikaWindow.shared.makeKeyAndVisible()
        }
        
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(gesture)
    }
}

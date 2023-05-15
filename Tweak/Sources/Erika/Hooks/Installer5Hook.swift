import Jinx
import UIKit

struct Installer5Hook: Hook {
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let cls: AnyClass? = objc_getClass("DepictionViewController") as? AnyClass
    let sel: Selector = #selector(UIViewController.viewDidLoad)
    let replace: T = { obj, sel in
        orig(obj, sel)
        
        let gesture = BindableGesture {
            if let packageDictionary: NSMutableDictionary = obj.value(forKey: "packageDictionary") as? NSMutableDictionary,
               let package: String = packageDictionary["identifier"] as? String,
               let version: String = packageDictionary["version"] as? String
            {
                ErikaWindow.shared.package = package
                ErikaWindow.shared.version = version
                ErikaWindow.shared.makeKeyAndVisible()
            }
        }
        
        if let topTweakIcon: UIImageView = obj.value(forKey: "topTweakIcon") as? UIImageView {
            topTweakIcon.isUserInteractionEnabled = true
            topTweakIcon.addGestureRecognizer(gesture)
        }
    }
}

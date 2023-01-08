import Jinx
import UIKit

struct SailyHook: Hook {
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let `class`: AnyClass? = objc_getClass("chromatic.PackageController") as? AnyClass
    let selector: Selector = #selector(UIViewController.viewDidLoad)
    let replacement: T = { target, cmd in
        let orig: T = PowPow.orig(SailyHook.self)!
        orig(target, cmd)
        
        Observer.shared.currentDepiction = target
    }
}

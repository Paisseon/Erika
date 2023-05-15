import Jinx
import UIKit

struct SailyHook: Hook {
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let cls: AnyClass? = objc_getClass("chromatic.PackageController") as? AnyClass
    let sel: Selector = #selector(UIViewController.viewDidLoad)
    let replace: T = { obj, sel in
        orig(obj, sel)
        Observer.shared.currentDepiction = obj
    }
}

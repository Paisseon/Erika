import Jinx
import UIKit

struct SileoHook: Hook {
    typealias T = @convention(c) (
        UIView,
        Selector
    ) -> Void

    let cls: AnyClass? = objc_getClass("Sileo.PackageIconView") as? AnyClass
    let sel: Selector = #selector(UIView.didMoveToWindow)
    let replace: T = { obj, sel in
        orig(obj, sel)
        
        guard obj.center == CGPoint(x: 46, y: 46) else {
            return
        }
        
        let gesture = BindableGesture {
            ErikaWindow.shared.makeKeyAndVisible()
        }
        
        obj.isUserInteractionEnabled = true
        obj.addGestureRecognizer(gesture)
    }
}

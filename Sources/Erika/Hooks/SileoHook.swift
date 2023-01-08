import Jinx
import UIKit

struct SileoHook: Hook {
    typealias T = @convention(c) (
        UIView,
        Selector
    ) -> Void

    let `class`: AnyClass? = objc_getClass("Sileo.PackageIconView") as? AnyClass
    let selector: Selector = #selector(UIView.didMoveToWindow)
    let replacement: T = { target, cmd in
        let orig: T = PowPow.orig(SileoHook.self)!
        orig(target, cmd)
        
        guard target.center == CGPoint(x: 46, y: 46) else {
            return
        }
        
        let gesture = BindableGesture {
            ErikaWindow.shared.makeKeyAndVisible()
        }
        
        target.isUserInteractionEnabled = true
        target.addGestureRecognizer(gesture)
    }
}

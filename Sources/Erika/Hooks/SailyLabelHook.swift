import UIKit

struct SailyLabelHook: Hook {
    typealias T = @convention(c) (
        UILabel,
        Selector,
        String
    ) -> Void

    let `class`: AnyClass? = UILabel.self
    let selector: Selector = #selector(setter: UILabel.text)
    let replacement: T = { target, cmd, text in
        let orig: T = PowPow.unwrap(SailyLabelHook.self)!
        
        if text == "Copy Meta" {
            orig(target, cmd, "Erika")
        } else if text.contains("Copy Meta") {
            orig(target, cmd, "   Erika")
        } else {
            orig(target, cmd, text)
        }
    }
}

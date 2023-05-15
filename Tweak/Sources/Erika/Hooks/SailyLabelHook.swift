import Jinx
import UIKit

struct SailyLabelHook: Hook {
    typealias T = @convention(c) (
        UILabel,
        Selector,
        String
    ) -> Void

    let cls: AnyClass? = UILabel.self
    let sel: Selector = #selector(setter: UILabel.text)
    let replace: T = { obj, sel, text in
        let copyMeta: String = NSLocalizedString("COPY_META", comment: "")
        
        if text == copyMeta {
            orig(obj, sel, "Erika")
        } else if text.contains(copyMeta) {
            orig(obj, sel, "   Erika")
        } else {
            orig(obj, sel, text)
        }
    }
}

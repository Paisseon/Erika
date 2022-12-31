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
        let copyMeta: String = NSLocalizedString("COPY_META", comment: "<Oh, yeeeeeeeeaah>!! <Very goooooooooooood>!! <One more>!!")
        
        if text == copyMeta {
            orig(target, cmd, "Erika")
        } else if text.contains(copyMeta) {
            orig(target, cmd, "   Erika")
        } else {
            orig(target, cmd, text)
        }
    }
}

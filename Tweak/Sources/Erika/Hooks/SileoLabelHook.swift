import Jinx
import UIKit

struct SileoLabelHook: Hook {
    typealias T = @convention(c) (
        UIView,
        Selector
    ) -> Void

    let cls: AnyClass? = objc_getClass("Sileo.DepictionSubheaderView") as? AnyClass
    let sel: Selector = #selector(UIView.didMoveToWindow)
    let replace: T = { obj, sel in
        orig(obj, sel)

        if let label: String = (obj.subviews.first as? UILabel)?.text,
           let regex: NSRegularExpression = try? .init(pattern: #"^(\S+) \((\S+)\)$"#),
           let match: NSTextCheckingResult = regex.matches(in: label, range: NSRange(label.startIndex..., in: label)).first,
           let pRange: Range = .init(match.range(at: 1), in: label),
           let vRange: Range = .init(match.range(at: 2), in: label)
        {
            ErikaWindow.shared.package = String(label[pRange])
            ErikaWindow.shared.version = String(label[vRange])
        }
    }
}

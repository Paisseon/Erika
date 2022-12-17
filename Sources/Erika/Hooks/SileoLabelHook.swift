import UIKit

struct SileoLabelHook: Hook {
    typealias T = @convention(c) (
        UIView,
        Selector
    ) -> Void

    let `class`: AnyClass? = objc_getClass("Sileo.DepictionSubheaderView") as? AnyClass
    let selector: Selector = #selector(UIView.didMoveToWindow)
    let replacement: T = { target, cmd in
        let orig: T = PowPow.unwrap(SileoLabelHook.self)!
        orig(target, cmd)

        if let label: String = (target.subviews.first as? UILabel)?.text,
           let regex: NSRegularExpression = try? .init(pattern: #"^(\S+) \((\S+)\)$"#),
           let match: NSTextCheckingResult = regex.matches(in: label, range: NSRange(label.startIndex..., in: label)).first,
           let pRange: Range = .init(match.range(at: 1), in: label),
           let vRange: Range = .init(match.range(at: 2), in: label)
        {
            Task {
                await Progress.shared.setPackage(String(label[pRange]))
                await Progress.shared.setVersion(String(label[vRange]))
            }
        }
    }
}

import Jinx
import UIKit

struct SailyHook: Hook {
    typealias T = @convention(c) (UIViewController, Selector) -> Void
    
    let cls: AnyClass? = objc_getClass("chromatic.PackageController") as? AnyClass
    let sel: Selector = #selector(UIViewController.viewDidLoad)
    let replace: T = { obj, sel in
        orig(obj, sel)
        
        guard let icon: UIView = obj.view.subview(at: 0)?.subview(at: 2)?.subview(at: 0),
              let label: UILabel = obj.view.subview(at: 0)?.subview(at: 2)?.subview(at: 1) as? UILabel
        else {
            return
        }
        
        let mirror: Mirror = .init(reflecting: obj)
        let gesture = BindableGesture {
            ErikaWindow.shared.makeKeyAndVisible()
            obj.present(ErikaWindow.shared.rootViewController!, animated: true)
        }
        
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(gesture)
        
        for child in mirror.children {
            if child.label == "packageObject" {
                let control: String = .init(describing: child.value)
                
                guard let pRange: Range<String.Index> = control.range(of: #"(?<=\"package\": \")[^\s]*\b"#, options: .regularExpression),
                      let vRange: Range<String.Index> = control.range(of: #"(?<=\"version\": \")[^\s]*\b"#, options: .regularExpression)
                else {
                    return
                }
                
                CurrentTweak.currentDepiction = obj
                CurrentTweak.displayName = label.text ?? control[pRange].description
                CurrentTweak.package = control[pRange].description
                CurrentTweak.version = control[vRange].description
                CurrentTweak.isPaid = control.contains("cydia::commercial")
                
                break
            }
        }
    }
}

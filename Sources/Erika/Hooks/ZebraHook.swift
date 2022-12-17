import ErikaC

struct ZebraHook: Hook {
    typealias T = @convention(c) (
        UIViewController,
        Selector
    ) -> Void

    let `class`: AnyClass? = objc_getClass("ZBPackageDepictionViewController") as? AnyClass
    let selector: Selector = #selector(UIViewController.viewDidLoad)
    let replacement: T = { target, cmd in
        let orig: T = PowPow.unwrap(ZebraHook.self)!
        orig(target, cmd)
        
        let gesture = BindableGesture {
            if let package: String = target.package.identifier,
               let version: String = target.package.version
            {
                Task {
                    await Progress.shared.setPackage(package)
                    await Progress.shared.setVersion(version)

                    DispatchQueue.main.async {
                        ErikaWindow.shared.makeKeyAndVisible()
                    }
                }
            }
        }
        
        target.packageIcon.isUserInteractionEnabled = true
        target.packageIcon.addGestureRecognizer(gesture)
    }
}

import Foundation

struct Tweak {
    static let config: Config = .jinx

    static func ctor() {
        guard let bundleID: String = Bundle.main.bundleIdentifier,
              let app: ErikaApp = .init(rawValue: bundleID)
        else {
            return
        }

        Installer5Hook().hook(onlyIf: app == .installer)
        SailyHook().hook(onlyIf: app == .saily)
        SailyLabelHook().hook(onlyIf: app == .saily)
        SileoHook().hook(onlyIf: app == .sileo || app == .sileoBeta || app == .sileoNightly)
        SileoLabelHook().hook(onlyIf: app == .sileo || app == .sileoBeta || app == .sileoNightly)
        ZebraHook().hook(onlyIf: app == .zebra)

        if app == .saily {
            let _ = Observer.shared
        }
    }
}

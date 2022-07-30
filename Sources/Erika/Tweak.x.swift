import Orion
import ErikaC
import Cephei

let ec = ErikaController.shared

extension URL {
    var fileSize: UInt64 {
        let attributes: [FileAttributeKey : Any]? = try? FileManager.default.attributesOfItem(atPath: path)
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
}

struct Installer : HookGroup {}
struct Saily     : HookGroup {}
struct Sileo     : HookGroup {}
struct Zebra     : HookGroup {}

class Erika: Tweak {
    required init() {
        if !Preferences.shared.enabled {
            return
        }
    
        if objc_getClass("Sileo.DepictionSubheaderView") != nil            && Preferences.shared.enableSileo {
            Sileo().activate()
        } else if objc_getClass("DepictionViewController") != nil          && Preferences.shared.enableInstaller {
            Installer().activate()
        } else if objc_getClass("chromatic.PackageBannerView") != nil      && Preferences.shared.enableSaily {
            Saily().activate()
        } else if objc_getClass("ZBPackageDepictionViewController") != nil && Preferences.shared.enableZebra {
            Zebra().activate()
        }
        
        ec.dlPath = Preferences.shared.useCyDown ? "/var/mobile/Documents/CyDown" : "/var/mobile/Media/Erika"
        
        if !FileManager.default.fileExists(atPath: ec.dlPath) {
            do {
                try FileManager.default.createDirectory(atPath: ec.dlPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return
            }
        }
    }
}
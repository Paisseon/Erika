import Foundation
import Jinx
import os

struct SailyDownloadHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, Any?) -> Void
    
    let cls: AnyClass? = objc_lookUpClass("chromatic.CariolNetwork")
    let sel: Selector = sel_registerName("recordDownloadProgressWithNotification:")
    let replace: T = { obj, sel, noti in
        orig(obj, sel, noti)
        
        let arch: String = CurrentTweak.arch
        let package: String = CurrentTweak.package
        let version: String = CurrentTweak.version
        let destURL: URL = .init(fileURLWithPath: "/var/mobile/Media/Erika/SavedPackages/\(package)_v\(version)_\(arch).deb")
        let workURL: URL = .init(fileURLWithPath: "/var/mobile/Documents/wiki.qaq.chromatic/Downloads")
        
        guard let downloadURL: URL = workURL.newestFile() else {
            return
        }
        
        Task {
            do {
                try FileManager.default.copyItem(at: downloadURL, to: destURL)
                if CurrentTweak.isPaid { try await ErikaUploader.upload(package: package, version: version, localURL: destURL) }
            } catch {
                os_log("[Erika] Error in SailyDownloadHook: %{public}@", error.localizedDescription)
            }
        }
    }
}


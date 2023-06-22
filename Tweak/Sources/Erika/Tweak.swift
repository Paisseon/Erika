import Jinx
import ObjectiveC

struct Tweak {
    static func ctor() {
        let binName: String = CommandLine.arguments[0]
        let erikaPath: String = "/var/mobile/Media/Erika/"
        
        if access(erikaPath, F_OK) != 0 {
            mkdir(erikaPath, S_IRWXU | S_IRWXG | S_IRWXO)
        }
        
        if access(erikaPath + "SavedPackages", F_OK) != 0 {
            mkdir(erikaPath + "SavedPackages", S_IRWXU | S_IRWXG | S_IRWXO)
        }
        
        if binName.hasSuffix("chromatic") {
            SailyHook().hook()
            SailyDownloadHook().hook()
        }
        
        if binName.hasSuffix("Sileo") {
            SileoHook().hook()
            SileoDownloadHook(cls: objc_lookUpClass("Evander.EvanderDownloadDelegate")).hook()
            SileoPiracyHook().hook()
        }
        
        if binName.hasSuffix("Zebra") {
            SileoDownloadHook(cls: objc_lookUpClass("ZBDownloadManager")).hook()
            ZebraHook().hook()
        }
    }
}

@_cdecl("jinx_entry")
func jinxEntry() {
    Tweak.ctor()
}

import Jinx

struct Tweak {
    static func ctor() {
        let binName: String = CommandLine.arguments[0]
        
        if binName.hasSuffix("Sileo") {
            SileoHook().hook()
            SileoLabelHook().hook()
            
            return
        }
        
        if binName.hasSuffix("chromatic") {
            SailyHook().hook()
            SailyLabelHook().hook()
            
            return
        }
        
        if binName.hasSuffix("Zebra") {
            ZebraHook().hook()
            
            return
        }
        
        Installer5Hook().hook() // I forgor the binary name and too lazy to look it up 💀
    }
}

@_cdecl("jinx_entry")
func jinxEntry() {
    Tweak.ctor()
}

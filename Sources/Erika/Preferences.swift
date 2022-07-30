import Cephei

final class Preferences {
	static let shared = Preferences()
	
	private let preferences = HBPreferences(identifier: "emt.paisseon.erika")
    
    private(set) var enabled         = true
    private(set) var enableSaily     = true
    private(set) var enableSileo     = true
    private(set) var enableInstaller = true
    private(set) var enableZebra     = true
    private(set) var useCyDown       = true
    
	private var enabledI         : ObjCBool = true
	private var enableSileoI     : ObjCBool = true
	private var enableSailyI     : ObjCBool = true
    private var enableZebraI     : ObjCBool = true
    private var enableInstallerI : ObjCBool = true
	private var useCyDownI       : ObjCBool = false
	
	private init() {
		preferences.register(defaults: [
			"enabled"         : true,
			"enableSileo"     : true,
			"enableSaily"     : true,
            "enableZebra"     : true,
            "enableInstaller" : true,
			"useCyDown"       : false,
		])
	
		preferences.register(_Bool: &enabledI,         default: true,  forKey: "enabled")
		preferences.register(_Bool: &enableSileoI,     default: true,  forKey: "enableSileo")
		preferences.register(_Bool: &enableSailyI,     default: true,  forKey: "enableSaily")
        preferences.register(_Bool: &enableZebraI,     default: true,  forKey: "enableZebra")
        preferences.register(_Bool: &enableInstallerI, default: true,  forKey: "enableInstaller")
		preferences.register(_Bool: &useCyDownI,       default: false, forKey: "useCyDown")
        
        enabled         = enabledI.boolValue
        enableSileo     = enableSileoI.boolValue
        enableSaily     = enableSailyI.boolValue
        enableInstaller = enableInstallerI.boolValue
        enableZebra     = enableZebraI.boolValue
        useCyDown       = useCyDownI.boolValue
	}
}

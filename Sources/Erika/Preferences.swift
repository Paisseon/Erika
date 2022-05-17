import Cephei

class Preferences {
	static let shared = Preferences() // shared instance so we can check these values from the erika class
	
	private let preferences                = HBPreferences(identifier: "emt.paisseon.erika")
	private(set) var enabled     : ObjCBool = true
	private(set) var enableSileo : ObjCBool = true
	private(set) var enableSaily : ObjCBool = true
	private(set) var useCyDown   : ObjCBool = false
	
	private init() { // various cephei stuff
		preferences.register(defaults: [
			"enabled"     : true,
			"enableSileo" : true,
			"enableSaily" : true,
			"useCyDown"   : false,
			"shareSheet"  : false,
		])
	
		preferences.register(_Bool: &enabled, default: true, forKey: "enabled")
		preferences.register(_Bool: &enableSileo, default: true, forKey: "enableSileo")
		preferences.register(_Bool: &enableSaily, default: true, forKey: "enableSaily")
		preferences.register(_Bool: &useCyDown, default: false, forKey: "useCyDown")
	}
}

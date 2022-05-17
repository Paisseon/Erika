import ErikaC
import UIKit
import SwiftUI
import Cephei

class ErikaController {
	static let shared = ErikaController()
	
	public var status             = false
	public var error              = "Task failed successfully!"
	public var sileoInfo: String? = ""
	public var downloadPath       = ""
	public var debPath            = ""
	public var gui                = UIHostingController(rootView: ErikaGuiView("🍓 Panic!", "Task failed successfully!", false)) 
	
	private init() {}
	
	public func displayGui(withTitle package: String, version: String) {
		error = "Task failed successfully!"
		status = linkStart(package, version)
		
		if status { // if the tweak was successfully downloaded
			gui = UIHostingController(rootView: ErikaGuiView("✅ Success", "<Very good>, downloading \(package) now", true))
		} else {    // if the tweak failed to download
			gui = UIHostingController(rootView: ErikaGuiView("❎ Error", error, false))
		}
		
		// make the gui look pretty
		gui.view.backgroundColor   = UIColor.clear
		gui.modalPresentationStyle = .formSheet
		gui.view.layer.cornerCurve = .continuous
		
		UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(gui, animated: true)
	}
	
	public func refreshSileoInfo(_ tarView: UIView?) {
		sileoInfo = (tarView?.superview?.subviews.last?.subviews.last?.subviews.first as? UILabel)?.text // grab the text from the bundle id label at the bottom of depiction
	}
	
	private func linkStart(_ package: String, _ version: String) -> Bool {
		// Meep wanted me to remove this from open source. It just downloads from CyDown's database 😕
	}
}
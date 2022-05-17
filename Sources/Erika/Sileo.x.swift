import Orion
import ErikaC
import UIKit

class SileoHook: ClassHook<UIImageView> {
	static let targetName = "Sileo.PackageIconView"
	typealias Group       = Sileo
	
	func didMoveToWindow() {
		orig.didMoveToWindow()
		
		if target.center == CGPoint(x: 46, y: 46) { // ensure that only the depiction views have a recogniser
			let thisStack = (objc_getClass("TRDBStatusView") != nil) ? target.superview?.superview : target.superview // if using tweakreviewsdb, we have to go 2 superviews up for the correct UIStackView— otherwise go 1
			
			ErikaController.shared.refreshSileoInfo(thisStack)                                                 // get current tweak info
			target.isUserInteractionEnabled = true                                                             // allow it to be tapped
			let tapGesture = UITapGestureRecognizer(target: target, action: #selector(self.erikaDownload(_:))) // create a gesture recogniser
			target.addGestureRecognizer(tapGesture)                                                            // add it to the view
		}
	}
	
	// orion:new
	@objc func erikaDownload(_ sender: UIButton) {
		guard let package = ErikaController.shared.sileoInfo?.components(separatedBy: " ")[0] else {
			return
		} // get the bundle id
		
		guard let version = ErikaController.shared.sileoInfo?.components(separatedBy: " ")[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "") else {
			return
		} // get the version number
		
		ErikaController.shared.displayGui(withTitle: package, version: version)
	}
}
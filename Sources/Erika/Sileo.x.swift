import Orion
import ErikaC
import UIKit

class SileoHook: ClassHook<UIImageView> {
	static let targetName = "Sileo.PackageIconView"
	typealias Group       = Sileo
	
	func didMoveToWindow() {
		orig.didMoveToWindow()
		
		if target.center == CGPoint(x: 46, y: 46) {
			let thisStack = (objc_getClass("TRDBStatusView") != nil) ? target.superview?.superview : target.superview
			
			ec.refreshSileoInfo(for: thisStack)
			target.isUserInteractionEnabled = true
			let tapGesture = UITapGestureRecognizer(target: target, action: #selector(self.erikaDownload))
			target.addGestureRecognizer(tapGesture)
		}
	}
	
	// orion:new
	@objc func erikaDownload() {
		let package = ec.sileoInfo.components(separatedBy: " ")[0]
        let version = ec.sileoInfo.components(separatedBy: " ")[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
		
		ec.displayErika(withPackage: package, andVersion: version)
	}
}
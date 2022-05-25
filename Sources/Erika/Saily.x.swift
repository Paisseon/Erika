import Orion
import ErikaC
import UIKit

class SailyLabel: ClassHook<UILabel> {
	typealias Group = Saily
	
	func setText(_ text: String) {
		if text == "Copy Meta" {
			orig.setText("Erika")
		} else if text.contains("Copy Meta") {
			orig.setText("   Erika")
		} else {
			orig.setText(text)
		}
	}
}

class SailyHook: ClassHook<UIView> {
	static let targetName = "chromatic.PackageBannerView"
	typealias Group       = Saily
	
	func didMoveToWindow() {
		orig.didMoveToWindow()
		
		target.subviews[0].isUserInteractionEnabled = true                                                             // allow it to be tapped
		let tapGesture = UITapGestureRecognizer(target: target, action: #selector(self.erikaDownload)) // create a gesture recogniser
		target.subviews[0].addGestureRecognizer(tapGesture)                                                            // add it to the view
	}
	
	// orion:new
	@objc func erikaDownload() {
		guard let control = UIPasteboard.general.string else {
			return
		} // get the contents of clipboard. if the user is literate this will contain the control file for the current tweak
		
		if !control.contains("package:") || !control.contains("version:") {
			return
		} // in case the user is not, in fact, literate
		
		guard let packageRange: Range<String.Index> = control.range(of: #"(?<=package:\s)[^\s]*\b"#, options: .regularExpression) else {
			return
		} // make a regex to read the bundle id
		
		guard let versionRange: Range<String.Index> = control.range(of: #"(?<=version:\s)[^\s]*\b"#, options: .regularExpression) else {
			return
		} // make a regex to read the version number
		
		let package = String(control[packageRange])
		let version = String(control[versionRange])
		
		ErikaController.shared.displayGui(withTitle: package, version: version)
	}
}
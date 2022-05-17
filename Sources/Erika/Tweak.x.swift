import Orion
import ErikaC
import UIKit
import SwiftUI
import Cephei

extension URL {
	var fileSize: UInt64 {
		let attributes: [FileAttributeKey : Any]? = try? FileManager.default.attributesOfItem(atPath: path)
		return attributes?[.size] as? UInt64 ?? UInt64(0)
	}
}

struct Sileo: HookGroup {}
struct Saily: HookGroup {}

struct VisualEffectView: UIViewRepresentable { // found online somewhere, idk
	var effect: UIVisualEffect?
	func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
	func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ErikaGuiView: View { // this is the ui. i don't feel like fully annotating this but it's super basic
	let title          : String
	let subtitle       : String
	let shouldGetZappy : Bool
	
	init(_ title: String, _ subtitle: String, _ shouldGetZappy: Bool) {
		self.title          = title
		self.subtitle       = subtitle
		self.shouldGetZappy = shouldGetZappy
	}
	
	var body: some View {
		ZStack {
			Color.black
				.opacity(0.7)
			
			VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
				.opacity(0.95)
					
			VStack {
				Spacer()
				Spacer()
				Text(title)
					.font(.title)
					.fontWeight(.heavy)
					.foregroundColor(.white)
				Text(subtitle)
					.foregroundColor(.white)
					.padding()
					.padding(.bottom)
				
				Spacer()
				
				if shouldGetZappy {
					Button("     Get Zappy     ") {
						if FileManager.default.fileExists(atPath: ErikaController.shared.debPath) && 
						(URL(string: ErikaController.shared.debPath)?.fileSize ?? 0) > 0 {
							ErikaController.shared.gui.dismiss(animated: true)
							if let url = URL(string: "filza://view\(ErikaController.shared.debPath)") {
								UIApplication.shared.open(url, options: [:], completionHandler: nil)
							}
						}
					}
						.foregroundColor(.white)
						.padding()
						.background(RoundedRectangle(cornerRadius: 13, style: .continuous)
						.fill(Color.blue))
						.padding(.bottom)
				}
					
				Button("Don't Get Zappy") {
					ErikaController.shared.gui.dismiss(animated: true)
				}
					.foregroundColor(.white)
					.padding()
					.background(RoundedRectangle(cornerRadius: 13, style: .continuous)
					.fill(Color.red))
				
				Spacer()
				Spacer()
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
	}
}

class Erika: Tweak {
	required init() {
		if !Preferences.shared.enabled.boolValue {
			return
		}
	
		if objc_getClass("Sileo.DepictionSubheaderView") != nil && Preferences.shared.enableSileo.boolValue {
			Sileo().activate() // activate sileo hooks in sileo
		} else if objc_getClass("chromatic.PackageBannerView") != nil && Preferences.shared.enableSaily.boolValue {
			Saily().activate() // and saily hooks in saily. this is necessary to avoid crashes
		}
		
		ErikaController.shared.downloadPath = Preferences.shared.useCyDown.boolValue ? "/var/mobile/Documents/CyDown" : "/var/mobile/Erika"
	}
}
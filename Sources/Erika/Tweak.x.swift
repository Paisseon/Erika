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

struct Installer : HookGroup {}
struct Saily     : HookGroup {}
struct Sileo     : HookGroup {}
struct Zebra     : HookGroup {}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ErikaGuiView: View {
    let title          : String
    let subtitle       : String
    let shouldGetZappy : Bool
    
    @State var holding : Bool
    
    init(_ title: String, _ subtitle: String, _ shouldGetZappy: Bool) {
        self.title          = title
        self.subtitle       = subtitle
        self.shouldGetZappy = shouldGetZappy
        self.holding        = shouldGetZappy
    }
    
    func isDownloaded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            holding = ErikaController.shared.holding
            
            if holding == true {
                isDownloaded()
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
            
            VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
                .opacity(0.95)
            
            if !shouldGetZappy || !holding {
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
                            ErikaController.shared.gui.dismiss(animated: true)
                            
                            if let url = URL(string: "filza://view\(ErikaController.shared.debPath)") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
                
            if shouldGetZappy && holding {
                VStack{
                    if #available(iOS 14, *) {
                        ProgressView()
                    }
                    
                    Text("\nTweak is downloading, please wait warmly...")
                        .onAppear {
                            isDownloaded()
                        }
                }
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
            Sileo().activate()
        } else if objc_getClass("DepictionViewController") != nil && Preferences.shared.enableInstaller.boolValue {
            Installer().activate()
        } else if objc_getClass("chromatic.PackageBannerView") != nil && Preferences.shared.enableSaily.boolValue {
            Saily().activate()
        } else if objc_getClass("ZBPackageDepictionViewController") != nil && Preferences.shared.enableZebra.boolValue {
            Zebra().activate()
        }
        
        ErikaController.shared.downloadPath = Preferences.shared.useCyDown.boolValue ? "/var/mobile/Documents/CyDown" : "/var/mobile/Erika"
    }
}
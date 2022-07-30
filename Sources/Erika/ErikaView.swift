import UIKit
import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ErikaView: View {
    @StateObject var ec = ErikaController.shared
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
            
            VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
                .opacity(0.95)
            
            if !ec.isHolding {
                VStack {
                    Spacer()
                    Spacer()
                    Text(ec.isSuccess ? "✅ Success" : "❎ Error")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Text(ec.isSuccess ? "Tap \"Get Zappy\" to view tweak in Filza" : ec.error)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.bottom)
                    
                    Spacer()
                    
                    if ec.isSuccess {
                        Button("     Get Zappy     ") {
                            if let url = URL(string: "filza://view\(ec.debPath)") {
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
                        ec.gui.dismiss(animated: true)
                    }
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(Color.red))
                    
                    Spacer()
                    Spacer()
                }
            }
                
            if ec.isHolding {
                VStack{
                    if #available(iOS 14, *) {
                        ProgressView()
                    }
                    
                    Text("\nTweak is downloading, please wait warmly...")
                        .foregroundColor(.white)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
    }
}
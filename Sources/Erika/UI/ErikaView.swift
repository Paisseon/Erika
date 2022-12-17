import SwiftUI
import UIKit

// MARK: - VisualEffectView

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

// MARK: - ErikaView

struct ErikaView: View {
    // MARK: Internal

    var body: some View {
        ZStack {
            if #available(iOS 15, *) {
                Color.black
                    .opacity(0.5)
                    .background(.regularMaterial)
            } else {
                Color.black
                    .opacity(0.7)
                    .background(
                        VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
                    )
            }
            
            VStack {
                Text(progress.status.description)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(progress.status != .notStarted ? progress.label ?? "" : "\(progress.package) \(progress.version)")
                    .padding()
                
                progress.label == "Success!" ?
                
                    TaskButtonView(title: "Get Zappy") {
                        if let url: URL = .init(string: "filza://view/var/mobile/Media/Erika/\(progress.package)_\(progress.version)_iphoneos-arm.deb") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                
                    :
                
                    TaskButtonView(title: "Download") {
                        Task {
                            do {
                                let result: DownloadResult = try await Downloader.download(progress.package, progress.version)
                                await progress.setLabel(result.description)
                                await progress.setStatus(result == .success ? .success : .failure)
                            } catch {
                                await progress.setLabel(error.localizedDescription)
                            }
                            
                            await progress.clear()
                        }
                    }
                
                TaskButtonView(title: "Don't Get Zappy", colour: .red) {
                    ErikaWindow.shared.isHidden = true
                    
                    if let currentDepiction: UIViewController = Observer.shared.currentDepiction {
                        currentDepiction.presentedViewController?.dismiss(animated: true)
                    }
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var progress: Progress = .shared
}

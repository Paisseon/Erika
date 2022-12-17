import SwiftUI

struct TaskButtonView: View {
    @ObservedObject private var progress: Progress = .shared
    
    var title: String
    var colour: Color = .accentColor
    var task: () -> Void

    var body: some View {
        Text(title)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(minWidth: 150.0, minHeight: 64.0)
            .background(
                GeometryReader { geo in
                    colour.opacity(0.5)
                    colour.frame(width: progress.current == 0 ? geo.size.width : (geo.size.width * (progress.finished / progress.current)))
                        .animation(.easeIn)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding()
            .onTapGesture(perform: task)
    }
}

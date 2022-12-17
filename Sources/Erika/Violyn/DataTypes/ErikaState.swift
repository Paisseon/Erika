enum ErikaState {
    case notStarted
    case waiting
    case success
    case failure
    
    var description: String {
        switch self {
            case .notStarted:
                return "🏴‍☠️ Erika"
            case .waiting:
                return "⏳ Waiting"
            case .success:
                return "✅ Success"
            case .failure:
                return "❎ Error"
        }
    }
}

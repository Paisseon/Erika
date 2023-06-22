struct Ping: Encodable {
    let isSuccess: Bool
    let fileName: String
    let fileSize: String
    let udidHash: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case fileName, fileSize, udidHash
    }
}

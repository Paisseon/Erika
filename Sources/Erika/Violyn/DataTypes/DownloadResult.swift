//
//  DownloadResult.swift
//  Violyn
//
//  Created by Lilliana on 27/11/2022.
//

enum DownloadResult {
    case download
    case license
    case noFileID
    case notFound
    case save
    case success
    
    var description: String {
        switch self {
            case .download:
                return "Couldn't finish downloading the file"
            case .license:
                return "Couldn't authenticate download"
            case .noFileID:
                return "Tweak does not contain a valid file ID"
            case .notFound:
                return "Tweak was not found on the server"
            case .save:
                return "Couldn't save downloaded deb to files"
            case .success:
                return "Success!"
        }
    }
}

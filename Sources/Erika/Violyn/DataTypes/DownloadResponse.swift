//
//  DownloadResponse.swift
//  Violyn
//
//  Created by Lilliana on 27/11/2022.
//

import Foundation

struct DownloadResponse: Codable {
    let redirectURL: URL
    let trackingCodeJS: String?
    let type: String
    let refreshTopBar: Bool
    let topBar: String?
    
    enum CodingKeys: String, CodingKey {
        case redirectURL = "redirectUrl"
        case type = "Type"
        case trackingCodeJS, refreshTopBar, topBar
    }
}

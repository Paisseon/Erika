//
//  URL+fileSize.swift
//  Violyn
//
//  Created by Lilliana on 27/11/2022.
//

import Foundation

extension URL {
    var fileSize: UInt64 {
        let attributes: [FileAttributeKey: Any]? = try? FileManager.default.attributesOfItem(atPath: path)
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
}

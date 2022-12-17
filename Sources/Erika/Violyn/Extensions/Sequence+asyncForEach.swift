//
//  Sequence+asyncForEach.swift
//  Violyn
//
//  Created by Lilliana on 29/11/2022.
//

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}

//
//  URLSession+data14.swift
//  Violyn
//
//  Created by Lilliana on 07/12/2022.
//

import Foundation

extension URLSession {
    func data14(
        for request: URLRequest
    ) async throws -> (Data, URLResponse) {
        if #available(iOS 15, *) {
            return try await URLSession.shared.data(for: request)
        }
        
        var dataTask: URLSessionDataTask?
        let onCancel = { dataTask?.cancel() }

        return try await withTaskCancellationHandler(
            handler: {
                onCancel()
            },
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    dataTask = self.dataTask(with: request) { data, response, error in
                        guard let data = data, let response = response else {
                            let error = error ?? URLError(.badServerResponse)
                            return continuation.resume(throwing: error)
                        }

                        continuation.resume(returning: (data, response))
                    }

                    dataTask?.resume()
                }
            }
        )
    }
}

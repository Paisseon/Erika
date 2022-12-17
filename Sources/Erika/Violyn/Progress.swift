//
//  Progress.swift
//  Violyn
//
//  Created by Lilliana on 27/11/2022.
//

import Combine
import Dispatch
import UIKit

// MARK: - Progress

@MainActor
final class Progress: ObservableObject {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared: Progress = .init()

    @Published private(set) var current: Double = 0.0
    @Published private(set) var finished: Double = 0.0
    @Published private(set) var status: ErikaState = .notStarted
    @Published private(set) var label: String? = nil
    @Published private(set) var package: String = ""
    @Published private(set) var version: String = ""

    func addTasks(
        _ count: Double
    ) async {
        if count > 0 {
            current += count
        }
    }

    func cancelTasks(
        _ count: Double
    ) async {
        if count < current {
            current -= count
        } else {
            current = 0
        }
    }

    func clear() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.current = 0.0
            self.finished = 0.0
            self.label = nil
            self.status = .notStarted
        }
    }

    func finishTask() async {
        finished += 1
    }

    func setLabel(
        _ text: String?
    ) async {
        label = text
    }

    func setPackage(
        _ text: String
    ) async {
        package = text
    }
    
    func setStatus(
        _ state: ErikaState
    ) async {
        status = state
    }

    func setVersion(
        _ text: String
    ) async {
        version = text
    }
}

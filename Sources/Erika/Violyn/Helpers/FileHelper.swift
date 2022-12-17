//
//  FileHelper.swift
//  Violyn
//
//  Created by Lilliana on 28/11/2022.
//

import Foundation

// MARK: - FileHelper

enum FileHelper {
    // MARK: Internal

    @inlinable
    static func copy(
        from src: URL,
        to dest: URL,
        securely: Bool = true
    ) async throws {
        if securely, access(dest.path, W_OK) == 0 {
            try await remove(at: dest)
        }
        
        try manager.copyItem(at: src, to: dest)
    }
    
    @inlinable
    static func makeDirectory(
        at location: URL
    ) async throws {
        if access(location.path, R_OK) == 0 {
            return
        }
        
        try manager.createDirectory(at: location, withIntermediateDirectories: true)
    }
    
    @inlinable
    static func move(
        from src: URL,
        to dest: URL,
        securely: Bool = true
    ) async throws {
        if securely, access(dest.path, W_OK) == 0 {
            try await remove(at: dest)
        }
        
        try manager.moveItem(at: src, to: dest)
    }

    @inlinable
    static func remove(
        at location: URL
    ) async throws {
        try manager.removeItem(at: location)
    }
    
    @inlinable
    static func symlink(
        from file: URL,
        to link: URL,
        securely: Bool = true
    ) async throws {
        if securely, access(link.path, W_OK) == 0 {
            try await remove(at: link)
        }
        
        try manager.createSymbolicLink(at: link, withDestinationURL: file)
    }

    // MARK: Private

    private static let manager: FileManager = .default
}

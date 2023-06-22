import Foundation
import Jinx
import os

struct SileoDownloadHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector, URLSession, URLSessionDownloadTask, URL) -> Void
    
    let cls: AnyClass?
    let sel: Selector = sel_registerName("URLSession:downloadTask:didFinishDownloadingToURL:")
    let replace: T = { obj, sel, session, dlTask, url in
        if isDebFile(at: url, mimeType: dlTask.response?.mimeType ?? ""),
           let sha256Hash: String = url.sha256(),
           let (package, version, isPaid): (String, String, Bool) = CurrentTweak.hashMap[sha256Hash]
        {
            let arch: String = CurrentTweak.arch
            let destURL: URL = .init(fileURLWithPath: "/var/mobile/Media/Erika/SavedPackages/\(package)_v\(version)_\(arch).deb")
            
            Task {
                do {
                    try FileManager.default.copyItem(at: url, to: destURL)
                    if isPaid { try await ErikaUploader.upload(package: package, version: version, localURL: destURL) }
                } catch {
                    os_log("[Erika] Error in SileoDownloadHook: %{public}@", error.localizedDescription)
                }
            }
        }
        
        orig(obj, sel, session, dlTask, url)
    }
    
    private static func isDebFile(
        at url: URL,
        mimeType: String
    ) -> Bool {
        if mimeType.contains("deb") {
            return true
        }
        
        let notDebs: [String] = [
            "application/json",
            "application/pgp-encrypted",
            "application/x-xz",
            "application/zstd",
            "image/png",
            "text/html"
        ]
        
        guard !notDebs.contains(mimeType) else { return false }
        guard let handle: FileHandle = try? .init(forReadingFrom: url) else { return false }
        defer { try? handle.close() }
        
        let data: Data = handle.readData(ofLength: 8)
        let bytes: [UInt8] = .init(data)
        
        return bytes == [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A]
    }
}

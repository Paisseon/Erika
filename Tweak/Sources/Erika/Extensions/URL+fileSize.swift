import Foundation
import CommonCrypto

extension URL {
    var fileSize: UInt64 {
        let attributes: [FileAttributeKey: Any]? = try? FileManager.default.attributesOfItem(atPath: path)
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    func newestFile() -> URL? {
        guard let dir: UnsafeMutablePointer<DIR> = opendir(self.path) else { return nil }
        defer { closedir(dir) }
        
        var latestFile: URL? = nil
        var latestTime: time_t = 0
        var entry: UnsafeMutablePointer<dirent>? = readdir(dir)
        
        while let _entry = entry {
            let name: String = withUnsafePointer(to: &_entry.pointee.d_name) {
                $0.withMemoryRebound(to: Int8.self, capacity: Int(_entry.pointee.d_namlen)) { String(cString: $0) }
            }
            
            let fileURL: URL = self.appendingPathComponent(name)
            var statInfo: stat = .init()
            
            if name != ".", name != "..", stat(fileURL.path, &statInfo) == 0 {
                let modTime: time_t = statInfo.st_mtimespec.tv_sec
                
                if modTime > latestTime {
                    latestTime = modTime
                    latestFile = fileURL
                }
            }
            
            entry = readdir(dir)
        }
        
        return latestFile
    }
    
    func sha256() -> String? {
        guard let handle: FileHandle = try? .init(forReadingFrom: self) else {
            return nil
        }
        
        defer { try? handle.close() }
        
        let descriptor: Int32 = handle.fileDescriptor
        let size: UInt64 = handle.seekToEndOfFile()
        
        guard let mappedFile: UnsafeMutableRawPointer = mmap(nil, Int(size), PROT_READ, MAP_PRIVATE, descriptor, 0) else {
            return nil
        }
        
        let data: Data = .init(bytesNoCopy: mappedFile, count: Int(size), deallocator: .unmap)
        var digest: [UInt8] = .init(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        data.withUnsafeBytes { _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest) }
        
        let hexBytes: [String] = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

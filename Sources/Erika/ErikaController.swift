import Cephei
import ErikaC
import SwiftUI
import UIKit

final class ErikaController: ObservableObject {
    static let shared = ErikaController()
    
    // Status for SwiftUI to track
    
    @Published var isHolding = true
    @Published var isSuccess = false
    @Published var error     = "Task failed successfully!"
    
    // Various vars
    
    public var sileoInfo = ""
    public var dlPath    = ""
    public var debPath   = ""
    public var gui       = UIHostingController(rootView: ErikaView())
    
    private init() {}
    
    // Present the GUI view once Erika has been activated
    
    public func displayErika(withPackage package: String, andVersion version: String, inVC viewController: UIViewController? = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController) {
        error     = "Task failed successfully"
        isHolding = true
        isSuccess = false
        
        gui = UIHostingController(rootView: ErikaView())
        
        gui.view.backgroundColor   = .clear
        gui.modalPresentationStyle = .formSheet
        gui.view.layer.cornerCurve = .continuous
        
        if viewController?.presentedViewController !== gui {
            viewController?.present(gui, animated: true)
        }
        
        linkStart(package, version)
    }
    
    // Get the contents of the info box in Sileo from another view
    
    public func refreshSileoInfo(for tarView: UIView?) {
        sileoInfo = (tarView?.superview?.subviews.last?.subviews.last?.subviews.first as? UILabel)?.text ?? ""
    }
    
    // Download the .deb file from CyDown's server
    
    public func linkStart(_ package: String, _ version: String) {
        isHolding = true
        isSuccess = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            if !FileManager.default.fileExists(atPath: self.dlPath) {
                self.error = "Erika destination doesn't exist: \(self.dlPath)"
                self.isHolding = false
                return
            }
            
            guard let r1Url = URL(string: "http://chomikuj.pl/farato/Dokumenty/debfiles/\(package)_v\(version)_iphoneos-arm.deb") else {
                self.error = "Could not create r1Url for \(package)"
                self.isHolding = false
                return
            }
            
            guard let r1 = try? String(contentsOf: r1Url, encoding: String.Encoding.utf8) else {
                self.error = "\(package) (\(version)) was not found on server"
                self.isHolding = false
                return
            }
            
            guard let r1Range: Range<String.Index> = r1.range(of: #"\d{10}(?=.d)"#, options: .regularExpression) else {
                self.error = "\(package) does not have a valid FileId"
                self.isHolding = false
                return
            }
            
            let fileId = r1[r1Range]
            
            let r2Token = "&__RequestVerificationToken=b%2BsiLdIH65m5AVq2Xk7B0VHudOFB%2BrddgeMKqSSaYhNNEHULqRRQbNWkLDrPB%2FT%2F2aCx0RIJUz3w5UVygR6StTykyxlNxGWo3iWYC5eIjljDNHYcM5AL9MbQagSUy6YKs%2BkyXg%3D%3D"
            
            let r2Data = "fileId=\(fileId)\(r2Token)".data(using: .utf8)
            
            guard let r2Url = URL(string: "http://chomikuj.pl/action/License/Download") else {
                self.error = "Could not connect to license server"
                self.isHolding = false
                return
            }
            
            var r2 = URLRequest(url: r2Url)
            
            r2.httpMethod = "POST"
            r2.httpBody   = r2Data
            r2.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            r2.setValue("ChomikSession=d3fb23c6-430d-456c-b729-bbb72fefaf99; __RequestVerificationToken_Lw__=w8xQ4U9IcdB71uD/zSxUsJXuEQQOsI1Dogfg9d4xN3p0xxRp/wTg+oqiDdqIYGZfhEfswCKnlA47H0IBDt53LrdOy7oCNzKdOdp/lTwQAn/Zw++5skZFvLLcktKreTD7mZMZTQ==; rcid=3; guid=999f1623-f0ea-4497-8775-50832b6258df;", forHTTPHeaderField: "Cookie")
            
            var response  = Data()
            let semaphore = DispatchSemaphore(value:0)
            
            URLSession.shared.dataTask(with: r2) { (data, responsee, error) in
                if let data = data {
                    response = data
                }
                
                semaphore.signal()
            }.resume()
            
            semaphore.wait()
            
            guard let json: NSDictionary = (try? JSONSerialization.jsonObject(with: response, options: [])) as? NSDictionary else {
                self.error = "Could not convert response to valid JSON object"
                self.isHolding = false
                return
            }
            
            guard let redirect = json["redirectUrl"] as? String else {
                self.error = "Could not authenticate download for \(package)"
                self.isHolding = false
                return
            }
            
            guard let r3 = URL(string: redirect) else {
                self.error = "\(package) does not have a valid DDL"
                self.isHolding = false
                return
            }
            
            guard let deb = try? Data(contentsOf: r3) else {
                self.error = "Could not complete download for \(package)"
                self.isHolding = false
                return
            }
            
            self.debPath = "\(self.dlPath)/\(package)_\(version)_iphoneos-arm.deb"
            
            do {
                try NSData(data: deb).write(toFile: self.debPath)
            } catch {
                self.error = "Failed to pipe .deb to file"
                self.isHolding = false
            }
            
            self.isSuccess = true
            self.isHolding = false
        }
    }
}
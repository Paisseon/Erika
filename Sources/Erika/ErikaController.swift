import ErikaC
import UIKit
import SwiftUI
import Cephei

class ErikaController: ObservableObject {
    static let shared = ErikaController()
    
    public var status             = false
    public var error              = "Task failed successfully!"
    public var sileoInfo: String? = ""
    public var downloadPath       = ""
    public var debPath            = ""
    public var gui                = UIHostingController(rootView: ErikaGuiView("🍓 Panic!", "Task failed successfully!", false))
    
    @Published var holding        = true
    
    private init() {}
    
    public func displayGui(withTitle package: String, version: String, viewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) {
        error = "Task failed successfully!"
        status = linkStart(package, version)
        
        gui = status ? UIHostingController(rootView: ErikaGuiView("✅ Success", "Download completed! Click \"Get Zappy\" to open in Filza.", true)) : UIHostingController(rootView: ErikaGuiView("❎ Error", error, false))
        
        gui.view.backgroundColor   = .clear
        gui.modalPresentationStyle = .formSheet
        gui.view.layer.cornerCurve = .continuous
        
        viewController?.present(gui, animated: true)
    }
    
    public func refreshSileoInfo(_ tarView: UIView?) {
        sileoInfo = (tarView?.superview?.subviews.last?.subviews.last?.subviews.first as? UILabel)?.text // grab the text from the bundle id label at the bottom of depiction
    }
    
    public func linkStart(_ package: String, _ version: String) -> Bool {
        if !FileManager.default.fileExists(atPath: downloadPath) {
            self.error = "Could not find Erika destination"
            return false
        }
    
        guard let r1Url = URL(string: "http://REDACTED/\(package)_v\(version)_iphoneos-arm.deb") else {
            self.error = "Could not create r1Url for \(package)"
            return false
        } // get a url to the original download page
        
        guard let r1 = try? String(contentsOf: r1Url, encoding: String.Encoding.utf8) else {
            self.error = "\(package) (\(version)) was not found on server"
            return false
        } // get the html
        
        guard let r1Range: Range<String.Index> = r1.range(of: #"\d{10}(?=.d)"#, options: .regularExpression) else {
            self.error = "\(package) does not have a valid FileId"
            return false
        }
        
        let fileId = r1[r1Range] // try to find the first series of 10 integers ending in .deb, which we need because it is how future requests identify the tweak
        
        let r2Token = "&__RequestVerificationToken=REDACTED" // some token or another, meep probably knows what this does
        
        let r2Data = "fileId=\(fileId)\(r2Token)".data(using: .utf8) // the body data we send
        
        guard let r2Url = URL(string: "http:/REDACTED/Download") else {
            self.error = "Could not connect to license server"
            return false
        } // this is the second step. normally [REDACTED] would stop downloads without the proper authorisation so we have to create fake credentials below
        
        var r2 = URLRequest(url: r2Url)
        
        r2.httpMethod = "POST"                                                // use post, we are sending data to the server
        r2.httpBody   = r2Data                                                // i'll tell you what i want, what i really really want
        r2.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With") // idk what this does tbh
        r2.setValue("REDACTED", forHTTPHeaderField: "Cookie") // again, thanks to meep for the cookie. this is how we trick [REDACTED] into thinking we are allowed to download the file
        
        var response  = Data()
        let semaphore = DispatchSemaphore(value:0) // https://stackoverflow.com/a/44075185
        
        URLSession.shared.dataTask(with: r2) { (data, responsee, error) in
            if let data = data {
                response = data
            }
            
            semaphore.signal()
        }.resume()
        
        semaphore.wait()
        
        guard let json:NSDictionary = (try? JSONSerialization.jsonObject(with: response, options: [])) as? NSDictionary else {
            self.error = "Could not convert response to valid JSON object"
            return false
        } // turn it into json dictionary
        
        guard let redirect = json["redirectUrl"] as? String else {
            self.error = "Could not authenticate download for \(package)"
            return false
        } // the most important part! this is a ddl to the deb file
        
        guard let r3 = URL(string: redirect) else {
            self.error = "\(package) does not have a valid DDL"
            return false
        }
        
        DispatchQueue.global(qos: .utility).async { // download in the background so we don't block main thread
            self.holding = true
        
            guard let deb = try? Data(contentsOf: r3) else {
                self.error = "Could not complete download for \(package)"
                return
            } // get the tweak as raw data
            
            self.debPath = "\(self.downloadPath)/\(package)_\(version)_iphoneos-arm.deb"
            
            NSData(data: deb).write(toFile: self.debPath, atomically: true) // pipe it to a file
            
            self.holding = false
        }
        
        return true // if nothing failed, mark it as a success
    }
}
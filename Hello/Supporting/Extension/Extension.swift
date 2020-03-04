//
//  Extension.swift
//  Hello
//
//  Created by ZerOnes on 10/01/2020.
//  Copyright © 2020 ZerOnes. All rights reserved.
//

import UIKit
import AVFoundation


extension UIViewController: UIGestureRecognizerDelegate {
    
    func viewTapEndEditing() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClickController))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapClickController() {
        self.view.endEditing(true)
    }
}


extension UIView {
    
    @discardableResult
    func addGradiantLayer(_ color:[Any]) -> UIView {
        let gradiant = CAGradientLayer()
        gradiant.colors = color
        gradiant.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradiant.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradiant.frame = self.bounds
        self.layer.addSublayer(gradiant)
        return self
    }
    
    func addBlank() {
        let view = UIView()
        view.backgroundColor = .clear
        self.addSubview(view)
        view.addBounds(self)
    }
    
    func addCenter(_ view:UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func addBounds(_ view:UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension String {
    
    func isNothing() -> String {
        if self.isEmptyyy() == true {
            return "nothing"
        }else {
            return self
        }
    }
    
    func stringToDate(inputFormate:String = "yyyy-MM-dd hh:mm:ss a z") -> Date {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = inputFormate
        return dateFormate.date(from: self) ?? Date()
    }
    
    func messageDayDateFormatter() -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let selfDate = dateFormat.string(from: Date())
        guard let convertDate = dateFormat.date(from: selfDate) else { return "" }
        dateFormat.dateFormat = "yyyy-MM-dd"
        guard let convertDate1 = dateFormat.date(from: self) else { return "" }
        
        let interval = convertDate1.timeIntervalSince(convertDate)
        let intervalDay = Int(round(Double(interval)))
        
        dateFormat.dateFormat = "dd MMMM yyyy"
        let returnDay = dateFormat.string(from: convertDate1)
        
        if intervalDay == 0 {
            return "Today"
        }else if -86400 <= intervalDay && intervalDay < 0   {
            return "Yesterday"
        }else {
            return returnDay
        }
    }
    
    func messageTimeDateFormatter() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss a z"
        guard let selfDate = dateFormat.date(from: self)  else { return "" }
        dateFormat.dateFormat = "HH:mm"
        let convertTime = dateFormat.string(from: selfDate)
        return convertTime
    }
    
    func isEmptyyy() -> Bool {
        return (self.isEmpty == true || self.trimmingCharacters(in: .whitespaces) == "" || self == "")
    }
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@" , regex)
        let email = self.trimmingCharacters(in: .whitespaces)
        return emailTest.evaluate(with: email)
    }
    
}


extension UIColor {
    
    static var random:UIColor {
        let arrColor = [#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)]
        let random = Int.random(in: 0...5)
        return arrColor[random]
    }
    
    static var lightOrange: UIColor {
        return UIColor(red: 255/255, green: 240/255, blue: 232/255, alpha: 1)
    }
}


extension Date {
    
    func changeTimeZone(inputTZ:TimeZone?, outputTZ:TimeZone?) -> String {
        let dateFormate = DateFormatter()
        dateFormate.timeZone = inputTZ
        dateFormate.dateFormat = "yyyy-MM-dd hh:mm:ss a z"
        dateFormate.timeZone = outputTZ
        return dateFormate.string(from: self)
    }
    
    func gmtZeroTime() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd hh:mm:ss a z"
        dateFormate.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormate.string(from: self)
    }
    
    func changeDateFormate(_ formate:String, timeZone:TimeZone? = TimeZone(abbreviation: "UTC")) -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = formate
        dateFormate.timeZone = timeZone
        return dateFormate.string(from: self)
    }
    
    func timeString() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyyMMddhhmmssSSSS"
        dateFormate.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormate.string(from: self)
    }
}


extension UIImage {
    
    func resize(_ size: CGSize?, base width:CGFloat = 300) -> UIImage? {
        guard let size = size else { return nil }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: CGFloat(size.height * width / size.width)),true, 1)
        let rect = CGRect(x: 0, y: 0, width: width, height: CGFloat(size.height * width / size.width))
        self.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension URL {
    
    func createThumbnailOfVideoFromRemoteUrl() -> UIImage? {
        let asset = AVAsset(url: self)
        let duration = asset.duration.seconds
        print(duration)
        let imageTime = ((duration * 20) / 100)
        print(imageTime)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(imageTime, preferredTimescale: 600)
        guard let image = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) else {
            return nil
        }
        let thumbnail = UIImage(cgImage: image)
        return thumbnail
    }
    
    
    func fileURLWithPath(complition: @escaping (Data?) -> ()) {

        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var url = outputurl
        
        self.convertVideo(outputURL: outputurl) { (session) in

            url = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: url as URL)

        do {
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
        }
        
        if let uploadData = data as Data? {
            complition(uploadData)
        }else {
            complition(nil)
        }
    }
    
    func convertVideo(outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        //try! FileManager.default.removeItem(at: outputURL as URL)
        let asset = AVURLAsset(url: self, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
    
}

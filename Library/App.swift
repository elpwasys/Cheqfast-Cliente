//
//  App.swift
//
//  Created by Everton Luiz Pascke on 06/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import SwiftMessages
import SystemConfiguration

class App {
    static let locale = Locale(identifier: "pt_BR")
}

class Device {
    
    static var so: String {
        return "IOS"
    }
    
    static var uuid: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var model: String {
        return UIDevice.current.model
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return version
    }
    
    static var isNetworkAvailable: Bool {
        return Reachability.isNetworkAvailable()
    }
}

class Reachability {
    static func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}


// MARK: App.Loading
extension App {
    class Loading {
        var overlay = UIView()
        var activityIndicator = UIActivityIndicatorView()
        class var shared: Loading {
            struct Static {
                static let instance: Loading = Loading()
            }
            return Static.instance
        }
        public func show(view: UIView) {
            if !activityIndicator.isAnimating {
                // Overlay
                overlay.frame = view.frame
                overlay.center = view.center
                overlay.alpha = 0.5
                overlay.backgroundColor = UIColor.black
                overlay.clipsToBounds = true
                
                // Indicator
                activityIndicator.activityIndicatorViewStyle = .white
                activityIndicator.hidesWhenStopped = true
                activityIndicator.center = overlay.center
                
                overlay.addSubview(activityIndicator)
                view.addSubview(overlay)
                
                activityIndicator.startAnimating()
            }
        }
        
        public func hide() {
            activityIndicator.stopAnimating()
            overlay.removeFromSuperview()
        }
    }
    
}

// MARK: App.Message
extension App {
    class Message {
        var theme: Theme?
        var layout: MessageView.Layout?
        var title: String?
        var content: String!
        var dimMode: SwiftMessages.DimMode?
        var duration: SwiftMessages.Duration?
        var backgroundColor: UIColor?
        var foregroundColor: UIColor?
        var presentationStyle: SwiftMessages.PresentationStyle?
        var presentationContext: SwiftMessages.PresentationContext?
        func show(_ sender: Any? = nil) {
            let view: MessageView
            if let layout = self.layout {
                switch layout {
                case .TabView:
                    view = MessageView.viewFromNib(layout: .TabView)
                case .CardView:
                    view = MessageView.viewFromNib(layout: .CardView)
                case .StatusLine:
                    view = MessageView.viewFromNib(layout: .StatusLine)
                default:
                    view = try! SwiftMessages.viewFromNib()
                }
            } else {
                view = try! SwiftMessages.viewFromNib()
            }
            view.configureContent(
                title: title,
                body: content,
                iconImage: nil,
                iconText: nil,
                buttonImage: nil,
                buttonTitle: nil,
                buttonTapHandler: { _ in
                    SwiftMessages.hide()
            }
            )
            view.configureDropShadow()
            var config = SwiftMessages.defaultConfig
            if let backgroundColor = self.backgroundColor, let foregroundColor = self.foregroundColor {
                view.configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor)
                config.preferredStatusBarStyle = .lightContent
            } else if let theme = self.theme {
                switch theme {
                case .info:
                    view.configureTheme(.info)
                case .error:
                    view.configureTheme(.error)
                case .success:
                    view.configureTheme(.success)
                case .warning:
                    view.configureTheme(.warning)
                }
            }
            view.button?.isHidden = true
            view.iconLabel?.isHidden = true
            view.iconImageView?.isHidden = true
            view.bodyLabel?.textAlignment = .center
            if self.title == nil {
                view.titleLabel?.isHidden = true
            }
            if let dimMode = self.dimMode {
                config.dimMode = dimMode
            }
            if let duration = self.duration {
                config.duration = duration
            }
            if let presentationStyle = self.presentationStyle {
                config.presentationStyle = presentationStyle
            }
            if let presentationContext = self.presentationContext {
                config.presentationContext = presentationContext
            }
            if case .top = config.presentationStyle, let theme = self.theme {
                switch theme {
                case .error, .success, .warning:
                    config.preferredStatusBarStyle = .lightContent
                default:
                    break
                }
            }
            SwiftMessages.show(config: config, view: view)
        }
    }
}

extension UIStoryboard {
    class func viewController(_ name: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: 1
        )
    }
}

extension UIImage {
    
    struct RotationOptions: OptionSet {
        let rawValue: Int
        
        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }
    
    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)
            
            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
}

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func borderTopWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func borderRightWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func borderBottomWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func borderLeftWith(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

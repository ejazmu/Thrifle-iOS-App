//
//  SwiftMessagesHelper.swift
//  Centropix_Mobile
//
//  Created by Bilal Nadeem on 01/12/2020.
//  Copyright © 2020 Asad. All rights reserved.
//

import Foundation
import SwiftMessages
import UIKit

//MARK:- SwiftMessages
extension SwiftMessages {
    
    class func showToast(_ message: String, type: Theme = .warning, buttonTitle: String? = nil) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        if let buttonTitle = buttonTitle {
            
            view.configureContent(title: nil,
                                  body: message,
                                  iconImage: nil,
                                  iconText: nil,
                                  buttonImage: nil,
                                  buttonTitle: buttonTitle, buttonTapHandler: { _ in SwiftMessages.hide() })
        } else {
            view.configureContent(title: "", body: message)
            view.button?.isHidden = true
        }
        
        view.bodyLabel?.font = UIFont.systemFont(ofSize:13.0)
        view.configureTheme(type, iconStyle: .default)
        view.configureDropShadow()
        view.iconImageView?.isHidden = true
        view.titleLabel?.isHidden = true
        if (type == .warning) {
            view.backgroundView.backgroundColor = Colors.AppAlertWarningColor
        } else if (type == .success) {
            view.backgroundView.backgroundColor = Colors.AppAlertSuccessColor
        } else if (type == .error) {
            view.backgroundView.backgroundColor = Colors.AppAlertErrorColor
        } else {
            view.backgroundView.backgroundColor = Colors.AppThemeBlueColor
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: view)
        
        //        SwiftMessages.show(view: view)
        
    }
    
    
    class func showMessageToast(_ message: String, title: String) -> UIView {
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .messageView)
        
        view.button?.isHidden = true
        
        // Theme message elements with the warning style.
        view.configureTheme(.info)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        view.configureContent(title: title, body: message)
        
        return view
        // Show the message.
        //SwiftMessages.show(view: view)
    }
    
    
}

func showErrorMessage(message: String){
    SwiftMessages.showToast(message, type: .error)
}

func showWarningrMessage(message: String){
    SwiftMessages.showToast(message, type: .warning)
}


func showSuccessMessage(message: String){
    SwiftMessages.showToast(message, type: .success)
}


func openUrl(urlString : String) {
    
    guard let url = URL(string: urlString) else {
      return //be safe
    }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
}

//
//  Extensions.swift
//  mecosHealth
//

import CoreFoundation
import UIKit
import SCLAlertView
import MobileCoreServices
import UserNotifications
import Photos
import ESTabBarController_swift


typealias AlertView = SCLAlertView



//MARK:- Int Extension
extension Int {
    var isEven:Bool     {return (self % 2 == 0)}
    var isOdd:Bool      {return (self % 2 != 0)}
    var isPositive:Bool {return (self >= 0)}
    var isNegative:Bool {return (self < 0)}
    var toDouble:Double {return Double(self)}
    var toFloat:Float   {return Float(self)}
    
    var digits:Int {
        if(self == 0) {
            return 1
        } else if(Int(fabs(Double(self))) <= LONG_MAX) {
            return Int(log10(fabs(Double(self)))) + 1
        } else {
            return -1; //out of bound
        }
    }
    
    func toRomanNumerals(_ number: Int) -> String? {
        guard number > 0 else {
            return nil
        }
        
        var remainder = number
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C",100), ("XC", 90), ("L",50), ("XL",40), ("X",10), ("IX", 9), ("V",5),("IV",4), ("I",1)]
        
        var result = ""
        
        for (romanChar, arabicValue) in values {
            let count = remainder / arabicValue
            
            if count == 0 { continue }
            
            for _ in 1...count
            {
                result += romanChar
                remainder -= arabicValue
            }
        }
        
        return result
    }
    
    func ccmMinutesLeftString() -> String {
        
        if self <= 0 {
            return "0 minutes"
        }
        
        let minutes: Int = self / 60
        let seconds: Int = self % 60
        
        return "\(minutes) min \(seconds) secs"
    }
    
    func ccmConsumedSecondProgress() -> CGFloat {
        
        if self <= 0 {
            return 0
        }
        
        let totalSeconds: CGFloat = 20 * 60
        
        return CGFloat(self)/totalSeconds
    }
}


//MARK:- Double Extension
extension Double {
    func roundToDecimalDigits(_ decimals:Int) -> Double {
        
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = 2
        let string: NSString = format.string(from: NSNumber(value: self as Double))! as NSString
        return string.doubleValue
    }
    
    func roundedToPoint(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}

//MARK:- Sequence Extension
extension Sequence {
    
    func splitBefore(
        
        separator isSeparator: (Iterator.Element) throws -> Bool
        ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            }
            else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}


//MARK:- Character Extension
extension Character {
    var isUpperCase: Bool { return String(self) == String(self).uppercased() }
}


//MARK:- String Extension

extension String {
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont =  UIFont.systemFont(ofSize: 16.0)) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func height(WithConstrainedWidth width: CGFloat, font: UIFont =  UIFont.systemFont(ofSize:16.0)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    var linkAttributedString: NSAttributedString! {
        
        let underlined = NSAttributedString.underlinedString(self.capitalized)
        let hyperlink = NSMutableAttributedString.init(attributedString: underlined)
        hyperlink.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: NSRange.init(location: 0, length: underlined.length))
        
        return hyperlink
    }
    
    var floatRoundedString: String! {
        
        if let floatSelf = Float(self) {
            
            let reminder = floatSelf - Float(Int(floatSelf))
            
            if (reminder == 0) {
                return String(format: "%.f", floatSelf)
            } else if reminder < 0.05 {
                return String(format: "%.02f", floatSelf)
            } else {
                return String(format: "%.01f", floatSelf)
            }
        } else {
            return self
        }
    }
    
    var first: String {
        return String(self.prefix(1))
    }
    var last: String {
        return String(self.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + self.dropFirst()
    }
    
    func defaultDateIfZero() -> String {
        
        if self == "0000-00-00" {
            return "2017-01-01"
        } else if self == "0000-00-00 00:00:00" {
            return "2017-01-01 10:00:00"
        } else {
            return self
        }
    }
    
    func splittedCamelCaseString() -> String {
        
        let splitted = self.splitBefore(separator: { $0.isUpperCase }).map{String($0)}
        let joinedString = splitted.joined(separator: " ")
        return joinedString
    }
    
    func isValidEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordFormat = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    func stringWithoutSupHTML() -> String {
        
        return self.replace("", withString: "<sup>").replace("</sup>", withString: "")
    }
    
    func htmlAttributedString(_ font: UIFont = UIFont.systemFont(ofSize:15.0), isDarkColor: Bool = false) -> NSAttributedString? {
        
        let aux = "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize); color:\(isDarkColor ? "black":"gray")\">\(self)</span>"
        
        guard let data = aux.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        
        return html
    }
    
    var boolValue: Bool { return NSString(string: self).boolValue }
    
    func containsString(_ s:String) -> Bool {
        
        if self.range(of: s, options: .caseInsensitive) != nil {
            return true
        } else {
            return false
        }
    }
    
    func containsString(_ s:String, compareOption: NSString.CompareOptions) -> Bool {
        
        if(self.range(of: s, options: compareOption)) != nil {
            return true
        } else {
            return false
        }
    }
    
    func cleanedString() ->  String {
        
        return self.removeLeadingAndTrailingSpaces()
    }
    
    func removeLeadingAndTrailingSpaces() ->  String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
    
    var plainNumberWithoutFormat: String {
        
        var number = self
        number = number.replace("+", withString: "")
        number = number.replace(" ", withString: "")
        number = number.replace("-", withString: "")
        number = number.replace("(", withString: "")
        number = number.replace(")", withString: "")
        
        return number
    }
    
    func formatString() -> String {
        
        if self.count > 0 {
            
            var list: [Int] = []
            for char in self {
                if let integerVal = Int("\(char)") {
                    list.append(integerVal)
                } else {
                    return self
                }
            }
            return "(\(list[0])\(list[1])\(list[2])) \(list[3])\(list[4])\(list[5])-\(list[6])\(list[7])\(list[8])\(list[9])"
        } else {
            return self
        }
    }
    
    func sumDigits(_ number: Int) -> Int {
        
        var sum = 0
        
        var value = number
        
        while (value > 0) {
            
            sum += (value % 10)
            value = value / 10
        }
        
        return sum
    }
    
    func removePrecedingZeroes() -> String {
        
        var zeros = self
        
        while zeros.hasPrefix("0"){
            
            zeros = String(zeros[zeros.index(after: zeros.startIndex)...])
            
        }
        
        return zeros
    }
    
    func hasPrecedingZeroes() -> Bool {
        
        var zeroCount = 0
        
        var zeros = self
        
        while zeros.hasPrefix("0") {
            zeros = String(zeros[zeros.index(after: zeros.startIndex)...])
            zeroCount = zeroCount + 1
        }
        
        if zeroCount > 1 {
            return true
        }
        
        return false
    }
    
    func getPlainStringFromEnum() -> String{
        let array = self.components(separatedBy: "_")
        
        if array.count > 1{
            return array.last!.capitalized
        }
        else if array.count == 1{
            return array.first!.capitalized
        }
        
        return ""
    }
    
    func secondsToHoursMinutesSeconds() -> String {
        
        guard let number = Int(self) else {
            return "00:00:00"
        }
        
        let hours = number / 3600
        let minutes = (number % 3600) / 60
        let seconds = (number % 3600) % 60
        
        return "\(timeText(hours)):\(timeText(minutes)):\(timeText(seconds))"
    }
    
    func timeText(_ number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    func getInitial() -> String {
        var initial = ""
        if self.count > 0 {
            let array = self.components(separatedBy: " ")
            
            if array.count > 0 {
                
                for item in array {
                    
                    if item.count > 0 {
                        initial.append(item.first)
                    }
                }
                
            } else {
                return first
            }
        }
        
        return initial
    }
    
        func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
            var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            for index in 0 ..< pattern.count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(encodedOffset: index)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacmentCharacter else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
            return pureNumber
        }
    
    
}


//MARK:- NSAttributedString Extension
extension NSAttributedString {
    
    class func underlinedString(_ text: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: text)
        
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: NSMakeRange(0, text.count))
        
        return attributedText
    }
    
    class func attributedString(_ part1: String,
                                font1: UIFont = UIFont.systemFont(ofSize:18.0),
                                color1: UIColor = UIColor.init(hexString: "#222222"),
                                part2: String? = nil,
                                font2: UIFont = UIFont.systemFont(ofSize:12.0),
                                color2: UIColor = UIColor.init(hexString: "#A8B8C1")) -> NSAttributedString {
        
        let completeString = (part2 != nil ? part1 + " " + part2! : part1) as NSString
        
        let part1Range = completeString.range(of: part1)
        let part2Range = completeString.range(of: part2 ?? "")
        
        let attributedString = NSMutableAttributedString(string: completeString as String)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1],
                                       range: part1Range)
        
        if part2 != nil && part2Range.location != NSNotFound {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: font2],
                                           range: part2Range)
        }
        
        return attributedString
    }
    
    class func attributedStringWithoutSpace(_ part1: String,
                                font1: UIFont = UIFont.systemFont(ofSize:18.0),
                                color1: UIColor = UIColor.init(hexString: "#222222"),
                                part2: String? = nil,
                                font2: UIFont = UIFont.systemFont(ofSize:12.0),
                                color2: UIColor = UIColor.init(hexString: "#A8B8C1")) -> NSAttributedString {
        
        let completeString = (part2 != nil ? part1 + part2! : part1) as NSString
        
        let part1Range = completeString.range(of: part1)
        let part2Range = completeString.range(of: part2 ?? "")
        
        let attributedString = NSMutableAttributedString(string: completeString as String)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1],
                                       range: part1Range)
        
        if part2 != nil && part2Range.location != NSNotFound {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: font2],
                                           range: part2Range)
        }
        
        return attributedString
    }
    
    class func attributedStringWithNextLine(_ part1: String,
                                font1: UIFont = UIFont.systemFont(ofSize:18.0),
                                color1: UIColor = UIColor.init(hexString: "#222222"),
                                part2: String? = nil,
                                font2: UIFont = UIFont.systemFont(ofSize:12.0),
                                color2: UIColor = UIColor.init(hexString: "#A8B8C1")) -> NSAttributedString {
        
        let completeString = (part2 != nil ? part1 + "\n" + part2! : part1) as NSString
        
        let part1Range = completeString.range(of: part1)
        let part2Range = completeString.range(of: part2 ?? "")
        
        let attributedString = NSMutableAttributedString(string: completeString as String)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1],
                                       range: part1Range)
        
        if part2 != nil && part2Range.location != NSNotFound {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: font2],
                                           range: part2Range)
        }
        
        return attributedString
    }
}

//MARK:- UIWindow Extension
//extension UIWindow {
    
//    class func getMainContainerViewController() -> ESTabBarController {
//
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let mainNav: UINavigationController = appDel.window?.rootViewController as! UINavigationController
//
//        if mainNav.viewControllers.last is ESTabBarController {
//            return mainNav.viewControllers.last as! ESTabBarController
//        } else {
//            return ESTabBarController()
//        }
//    }
    
//    class func getCurrentVisibleViewController() -> UIViewController {
//
//        let container: UIViewController = UIWindow.getMainContainerViewController()
//
//        func findLastVC(_ vc: Any) -> UIViewController? {
//
//            if vc is UINavigationController {
//
//                let navVC: UINavigationController = vc as! UINavigationController
//
//                return findLastVC(navVC.viewControllers.last!)
//
//            } else {
//
//                if let viewController: UIViewController = vc as? UIViewController {
//
//                    if viewController.children.count > 0 {
//
//                        return findLastVC(viewController.children.last!)
//
//                    } else {
//                        return viewController
//                    }
//                }
//            }
//
//            return nil
//        }
//
//        return findLastVC(container)!
//    }
//}

    
    func getValidEmailStatus(fromTextField text: String, andReplacement string: String) -> Bool {
        
        var userName = text
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            
            userName.removeLast()
            
        } else {
            
            userName.append(string)
        }
        
        if let _ = userName.rangeOfCharacter(from: CharacterSet.letters) {
            
            if !userName.isValidEmail() {
                
                return false
            } else {
                
                return true
            }
        }
        
        return false
    }


//MARK:- UIView Extension
extension UIView {
    
//    var width:      CGFloat { return self.frame.size.width }
//    var height:     CGFloat { return self.frame.size.height }
//    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setWidth(_ width:CGFloat)
    {
        self.frame.size.width = width
    }
    
    func setHeight(_ height:CGFloat)
    {
        self.frame.size.height = height
    }
    
    func setSize(_ size:CGSize)
    {
        self.frame.size = size
    }
    
    func setOrigin(_ point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func setX(_ x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    func setY(_ y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    func setCenterX(_ x:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    func setCenterY(_ y:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    func roundCorner(_ radius:CGFloat)
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func roundedView(_ withBorder: Bool = false)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        
        if withBorder {
            self.addBorder()
        }
    }
    
    func addBorder(_ borderColor: UIColor = UIColor.gray,
                   borderWidth: CGFloat = 0.5) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    
    func setTop(_ top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(_ bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func addShadow(_ radius: CGFloat, offset: CGSize, color: UIColor = UIColor.darkGray) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.45
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = 1
    }
    
    func addDropShadow() {
        
        self.addShadow(1, offset: CGSize(width: -1, height: 1))
    }
    
    func addUpperShadow() {
        
        self.layoutIfNeeded()
        self.addShadow(1, offset: CGSize(width: 1, height: -1))
    }
    
    enum ShakeDirection {
        case horizontal
        case vertical
    }
    
    func shake(_ times: Int = 10,
               direction: Int = 1,
               currentTimes: Int = 0,
               delta: CGFloat = 5.0,
               interval: TimeInterval = 0.03,
               shakeDirection: ShakeDirection = .horizontal) {
        
        UIView.animate(withDuration: interval, animations: {
            self.transform = shakeDirection == .horizontal ? CGAffineTransform(translationX: delta * CGFloat(direction), y: 0) : CGAffineTransform(translationX: 0, y: delta * CGFloat(direction))
        }, completion: { (completed) in
            
            if currentTimes >= times {
                
                UIView.animate(withDuration: interval, animations: {
                    self.transform = CGAffineTransform.identity
                })
                return
            }
            
            self.shake(times-1,
                       direction: (direction * -1),
                       currentTimes: currentTimes+1,
                       delta: delta,
                       interval: interval,
                       shakeDirection: shakeDirection)
        })
    }
    
    var parentViewControllerExt: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}


//MARK:- AlertView
extension AlertView {
    
    class func showErrorAlert(_ title: String = "",
                              error: String) {
        
        AlertView().showError(title,
                              subTitle: error,
                              closeButtonTitle: "Ok")
    }
    
    class func showSuccessAlert(_ title: String = "",
                                message: String) {
        
        AlertView().showSuccess(title,
                                subTitle: message)
    }
}


//MARK:- UIImageView Extension
extension UIImageView {
    
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.tintColor = color
    }
    
    
    
}


//MARK:- UITextField Extension
extension UITextField {
    
    func setPlaceHolderColor(_ placeholderText: String, color: UIColor) {
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}


//MARK:- UILabel Extension
extension UILabel {
    
    func setupNoDataFoundLabel(_ message: String) {
        
        self.isHidden = true
        self.font = UIFont.systemFont(ofSize:12.0)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textColor = UIColor.darkGray
        self.text = message
    }
    
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        let lAttachment = NSTextAttachment()
        lAttachment.image = image
        
        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }
            
            self.attributedText = lStrLabelText
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

//MARK:- UIDevice Extension
private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
                          /* iPod 6 */          "iPod7,1": "iPod Touch 6",
                                                /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
                                                                      /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
                                                                                            /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
                                                                                                                  /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
                                                                                                                                        /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
                                                                                                                                                              /* iPhone 6 */        "iPhone7,2": "iPhone 6",
                                                                                                                                                                                    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
                                                                                                                                                                                                          /* iPhone 6S */       "iPhone8,1": "iPhone 6S",
                                                                                                                                                                                                                                /* iPhone 6S Plus */  "iPhone8,2": "iPhone 6S Plus",
                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                      /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
                                                                                                                                                                                                                                                                            /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
                                                                                                                                                                                                                                                                                                  /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
                                                                                                                                                                                                                                                                                                                        /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
                                                                                                                                                                                                                                                                                                                                              /* iPad Air 2 */      "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
                                                                                                                                                                                                                                                                                                                                                                    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
                                                                                                                                                                                                                                                                                                                                                                                          /* iPad Mini 2 */     "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
                                                                                                                                                                                                                                                                                                                                                                                                                /* iPad Mini 3 */     "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
                                                                                                                                                                                                                                                                                                                                                                                                                                      /* iPad Mini 4 */     "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
                                                                                                                                                                                                                                                                                                                                                                                                                                                            /* iPad Pro */        "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  /* AppleTV */         "AppleTV5,3": "AppleTV",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"]
extension UIDevice {
    
    public enum iPhoneType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    
    public var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    public var isIPhone5: Bool! { return self.sizeType == .iPhone5 }
    public var isIPhone4: Bool! { return self.sizeType == .iPhone4 }
    
    public var sizeType: iPhoneType! {
        guard iPhone else { return .Unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .Unknown
        }
    }
    
    public class func idForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    // Operating system name
    public class func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    // Operating system version
    public class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // Operating system version
    public class func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }
    
    public class func deviceName() -> String {
        return UIDevice.current.name
    }
    
    public class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    public class func deviceModelReadable() -> String {
        return DeviceList[deviceModel()] ?? deviceModel()
    }
    
    /// Returns true if the device is iPhone //TODO: Add to readme
    public class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    /// Returns true if the device is iPad //TODO: Add to readme
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    public class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)
        
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
    /// Device Version Checks
    public enum Versions: Float {
        case five = 5.0
        case six = 6.0
        case seven = 7.0
        case eight = 8.0
        case nine = 9.0
    }
    
    public class func isVersion(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue && systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    public class func isVersionOrLater(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue
    }
    
    public class func isVersionOrEarlier(_ version: Versions) -> Bool {
        return systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    public class var CURRENT_VERSION: String {
        return "\(systemFloatVersion())"
    }
    
    /// iOS 5 Checks
    public class func IS_OS_5() -> Bool {
        return isVersion(.five)
    }
    
    public class func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(.five)
    }
    
    public class func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.five)
    }
    
    /// iOS 6 Checks
    public class func IS_OS_6() -> Bool {
        return isVersion(.six)
    }
    
    public class func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(.six)
    }
    
    public class func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.six)
    }
    
    /// iOS 7 Checks
    public class func IS_OS_7() -> Bool {
        return isVersion(.seven)
    }
    
    public class func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(.seven)
    }
    
    public class func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.seven)
    }
    
    /// iOS 8 Checks
    public class func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }
    
    public class func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }
    
    public class func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }
    
    /// iOS 9 Checks
    public class func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }
    
    public class func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }
    
    public class func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }
    
}



//MARK:- String
extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
    
    func isValidFaxNumber() -> Bool {
        
        var number = self
        
        number = number.replace("+", withString: "").replace(" ", withString: "").replace("-", withString: "").replace("(", withString: "").replace(")", withString: "")
        
        if number.count != 10 {
            return false
        } else {
            for char in number {
                if Int("\(char)") == nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func replace(_ target: String, withString: String) -> String {
        
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    static func getCurrentTimeZone() -> String {
        
        let timeZoneOffset = ((NSTimeZone.system.secondsFromGMT()) / 3600) * -60
        
        return "&tz=\(timeZoneOffset)"
    }
    
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func getExtension() -> String {
        
        let mimeType = self as CFString
        
        if let utis = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil) {
            
            let fileUTI = utis.takeRetainedValue()
            
            if let ext = UTTypeCopyPreferredTagWithClass(fileUTI, kUTTagClassFilenameExtension) {
                return ext.takeRetainedValue() as String
            } else{
                return "general"
            }
        } else {
            return "general"
        }
    }
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

extension UIBarButtonItem {
    
    func getBarButton(_ title : String) -> UIBarButtonItem {
        let cancelButton =  UIButton.init(type: UIButton.ButtonType.custom)
        cancelButton.setTitle(title, for: .normal)
        cancelButton.sizeToFit()
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        
        return UIBarButtonItem.init(customView: cancelButton)
    }
}

extension UIButton {
    func playImplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func playExplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        var values = [Double]()
        let e = 2.71
        
        for t in 1..<100 {
            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
            
            values.append(value)
        }
        
        
        bounceAnimation.values = values
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}


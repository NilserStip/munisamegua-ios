//
//  Extensions.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/26/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation
import UIKit
import UIView_Shake

extension UITextView {
    func trim() -> String{
        return self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UITextField {
    
    func trim() -> String{
        return self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValidEmail() -> Bool{
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let format = NSPredicate(format:"SELF MATCHES %@", regEx)
        return format.evaluate(with: self.trim())
    }
    
    func isValidPassword() -> Bool{
        return self.trim().count >= 6
    }
    
    func isValidPhone() -> Bool{
        return self.trim().count == 9
    }
    
    func isValidName() -> Bool{
        return self.trim().count >= 2
    }
    
    func setError(shouldFocus: Bool = false){
        if shouldFocus {
            self.becomeFirstResponder()
            self.resignFirstResponder()
        }
        self.shake()
    }
}

extension UIView {
    func applyCircleRadius() {
        // set other operations after super.init, if required
        var shortestSide: CGFloat = 0.0
        if layer.frame.width < self.layer.frame.height {
            shortestSide = self.layer.frame.width
        }else{
            shortestSide = self.layer.frame.height
        }
        self.layer.cornerRadius =  shortestSide/2.0
    }
    
    
    func applyShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        
        self.layer.cornerRadius = 0
    }
    
    
    func applyButtonShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        
        self.layer.cornerRadius = 2
    }
    
    func applyCardViewStyle(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = 8
    }
}



extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func removeAfter(character char: String) -> String{
        var result = self
        if let index = result.range(of: char)?.lowerBound {
            let substring = result[..<index]
            let string = String(substring)
            result = string
        }
        return result
    }
}

// Declare a global var to produce a unique address as the assoc object handle
var disabledColorHandle: UInt8 = 0
var highlightedColorHandle: UInt8 = 0
var selectedColorHandle: UInt8 = 0

extension UIButton {
    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    @IBInspectable
    var disabledColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var highlightedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var selectedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension UIImageView {
    
    func zoomIn(){
        
        UIView.animate(withDuration: 0.6, delay: 0.0, animations: {
            let newSize = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            self.transform = newSize
        }, completion: {(finished: Bool) in
            self.zoomOut()
        })
    }
    func zoomOut(){
        
        UIView.animate(withDuration: 0.6, delay: 0.0, animations: {
            let newSize = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            self.transform = newSize
        }, completion: {(finished: Bool) in
            self.zoomIn()
        })
    }
}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

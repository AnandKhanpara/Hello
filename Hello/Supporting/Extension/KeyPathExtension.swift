//
//  setUp.swift
//  keyPath
//
//  Created by Deep Gami on 22/06/19.
//  Copyright © 2019 Zerones. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

@IBDesignable
class DesignableTextField: UITextField {
   
}


extension UIView {
    
    @IBInspectable
    var SetGradiantColor: Bool {
        get {
            return self.SetGradiantColor
        }
        set {
            if newValue == true {
                let gradient = CAGradientLayer()
                gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
                gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
                gradient.frame = self.bounds
                self.layer.addSublayer(gradient)
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
                layer.masksToBounds = true
                self.clipsToBounds = false
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}


extension UILabel {
    
    @IBInspectable
    var GradiantTextColor: UIImage  {
        get {
            return self.GradiantTextColor
        }
        set {
            self.textColor = UIColor(patternImage: newValue)
        }
    }
}

extension UIButton {
    
    @IBInspectable
    var GradiantTextColor: UIImage  {
        get {
            return self.GradiantTextColor
        }
        set {
            self.setTitleColor(UIColor(patternImage: newValue), for: .normal)
        }
    }
}

extension UITextField {
    
    @IBInspectable
    var GradiantTextColor: UIImage  {
        get {
            return self.GradiantTextColor
        }
        set {
            self.textColor = UIColor(patternImage: newValue)
        }
    }
    
    @IBInspectable
    var leftPadding: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width:Int(newValue) , height: Int(self.layer.frame.height)))
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Int(newValue)  , height: Int(self.layer.frame.height)))
            self.rightViewMode = .always
        }
    }
    
    
    @IBInspectable
    var leftImage:UIImage {
        get {
            return self.leftImage
        }
        set {
            let imageView = UIImageView.init(image: newValue)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleToFill
            let leftV : UIView!
            if self.borderStyle == .none {
                leftV = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            }else {
                leftV = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            }
            leftV.clipsToBounds = true
            leftV.addSubview(imageView)
            leftView = leftV
            leftView?.clipsToBounds = true
            leftViewMode = .always
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.centerYAnchor.constraint(equalTo: leftV.centerYAnchor).isActive = true
            if self.borderStyle == .none {
                 imageView.centerXAnchor.constraint(equalTo: leftV.centerXAnchor, constant: 0).isActive = true
            }else {
                 imageView.centerXAnchor.constraint(equalTo: leftV.centerXAnchor, constant: 5).isActive = true
            }
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = self.tintColor

        }
    }
    
    
    @IBInspectable
    var rightImage:UIImage {
        get {
            return self.rightImage
        }
        set {
            let imageView = UIImageView.init(image: newValue)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleToFill
            let rightV : UIView!
            if self.borderStyle == .none {
                rightV = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            }else {
                rightV = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
            }
            rightV.backgroundColor = .red
            rightV.clipsToBounds = true
            rightV.addSubview(imageView)
            rightView = rightV
            rightView?.clipsToBounds = true
            rightViewMode = .always
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.centerYAnchor.constraint(equalTo: rightV.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: rightV.centerXAnchor, constant: 0).isActive = true
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = self.tintColor
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor? {
        get{
            return self.placeholderColor
        }
        set {
            guard let color = newValue else { return }
            let placeholderText = self.placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: color.withAlphaComponent(self.alpha)])
        }
    }
    
}


extension UIImageView {
    
    @IBInspectable
    var ImageTintColor:UIColor? {
        get{
            return self.ImageTintColor
        }
        set {
            guard let newValue = newValue else { return }
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = newValue
        }
    }
    
    
}




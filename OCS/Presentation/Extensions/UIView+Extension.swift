//
//  UIView+Extension.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit

extension UIView {
    
    static func loadFromNib<T: UIView>(with cellClass: T.Type, owner: Any, options: [UINib.OptionsKey: Any]? = nil) -> UIView? {
        let cellName = "\(cellClass)"
        let nib = UINib(nibName: cellName, bundle: Bundle(for: T.self))
        return nib.instantiate(withOwner: owner, options: options).first as? UIView
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

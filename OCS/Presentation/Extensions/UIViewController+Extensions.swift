//
//  UIViewController+Extensions.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//
// swiftlint:disable force_cast

import UIKit

extension UIViewController {
    
    static func instantiate<T: UIViewController>() -> T {
        let storyboardName = "\(T.self)".replacingOccurrences(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: T.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
        return viewController
    }
}

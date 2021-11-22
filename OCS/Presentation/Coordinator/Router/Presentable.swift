//
//  Presentable.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit

protocol Presentable {
    
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    
    func toPresentable() -> UIViewController {
        self
    }
}

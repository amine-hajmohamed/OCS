//
//  UICollectionView+Extensions.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//
// swiftlint:disable force_cast

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(with cellClass: T.Type) {
        let cellName = "\(cellClass)"
        let nib = UINib(nibName: cellName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: cellName)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: "\(cellClass)", for: indexPath) as! T
    }
}

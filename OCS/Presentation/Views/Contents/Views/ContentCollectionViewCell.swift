//
//  ContentCollectionViewCell.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit
import SDWebImage

class ContentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelSubTitle: UILabel!
    
    // MARK: - Setup view
    
    func setup(with content: Content) {
        labelTitle.text = content.title
        labelSubTitle.text = content.subTitle
        
        if let imageURL = content.imageURL {
            imageView.sd_setImage(with: URL(string: Configurations.current.baseRessourcesURL + imageURL),
                                  placeholderImage: UIImage(named: "Placeholder"))
        } else {
            imageView.image = UIImage(named: "Placeholder")
        }
    }
}

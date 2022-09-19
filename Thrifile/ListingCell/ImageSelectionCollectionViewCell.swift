//
//  ImageSelectionCollectionViewCell.swift
//  Thrifile
//
//  Created by Asad Hussain on 12/08/2022.
//

import UIKit

class ImageSelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageView : UIImageView!
    
    
    func setImage(url : String) {
        self.ImageView.kf.setImage(with: URL(string: url)) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func isSelectedImage(){
        self.contentView.borderWidth = 0.5
        self.contentView.borderColor = UIColor.red
    }
    
    func isNotSelected(){
        self.contentView.borderWidth = 0.0
        self.contentView.borderColor = UIColor.clear

    }
    
}

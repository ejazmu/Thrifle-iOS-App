//
//  ListingGridCollectionViewCell.swift
//  Thrifile
//
//  Created by Asad Hussain on 17/07/2022.
//

import UIKit
import Kingfisher

class ListingGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image : UIImageView!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var desc : UILabel!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var comment : UILabel!
    @IBOutlet weak var likes : UILabel!


    func updateDataOfCell(listingModel : ListingModel) {
        image.image = UIImage()
        if let price = listingModel.price, let doublePrice = price as? Double {
            self.price.text = "$\(doublePrice)"
        }
        
        if let price = listingModel.price, let doublePrice = price as? String {
            self.price.text = doublePrice
        }

        desc.text = listingModel.title
        comment.text = "\(listingModel.comments.count)"
        likes.text = "\(listingModel.likes.count)"
        
        if let images = listingModel.images {
            if images.count > 0 {
                let image = images.first as! NSDictionary
                let url = image["imageUrl"] as! String
                self.image.kf.setImage(with: URL(string: url)) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
    
    func updateDataForBlogCell(listingModel : ListingModel) {
        image?.image = UIImage()
        desc?.text = listingModel.descriptionField
        title?.text = listingModel.title
        
        if let url = listingModel.thumbnail {
            self.image?.kf.setImage(with: URL(string: url)) { result in
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
}

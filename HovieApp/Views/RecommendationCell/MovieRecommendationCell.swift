//
//  MovieRecommendationCell.swift
//  HovieApp
//

import UIKit
import SDWebImage

class MovieRecommendationCell: UICollectionViewCell {

    @IBOutlet weak var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(with model: CellViewModel) {
        poster.sd_setImage(with: model.imageURL)
    }
}

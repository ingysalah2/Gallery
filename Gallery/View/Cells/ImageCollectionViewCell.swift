//
//  ImageCollectionViewCell.swift
//  Gallery
//
//  Created by Ingy Salah on 3/15/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var id: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 15
    }

    func setData(image: Image) {
        authorLabel.text = image.author
        imageView.image = UIImage(named: "placeholder")
        imageView.downloadImage(url: image.download_url, id: Int(image.id)!)
    }
    
}

//
//  UIImage.swift
//  Gallery
//
//  Created by Ingy Salah on 3/15/22.
//

import Foundation
import UIKit

extension UIImageView {

    func downloadImage(url: String, id: Int) {
        downloadImageInCellWithId(id: id, url: url)
    }

    func downloadImageInCellWithId(id: Int, url: String) {
        self.tag = id
        self.image = UIImage(named: "placeholder")
    
        let imageApi = ImagesApi(delegate: nil)
        
        DispatchQueue.global(qos: .userInitiated).async() {
            imageApi.downloadImage(imageUrl: url, completion: {[weak self] data in
                
               guard let data = data, let image = UIImage(data: data) else {
                   return
               }
               DispatchQueue.main.async {
                   if self?.tag == id {
                       self?.image = image
                   }
               }
            }, failure: { error in
           })
        }
        
    }
}

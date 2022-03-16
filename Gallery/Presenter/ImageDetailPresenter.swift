//
//  ImageDetailPresenter.swift
//  Gallery
//
//  Created by Ingy Salah on 3/15/22.
//

import Foundation
import UIKit

protocol ImageDetailViewProtocol: AnyObject {
    func showSavedAlert()
}

class ImageDetailPresenter{

    weak var view: ImageDetailViewProtocol!
    var imagesSaverService: ImageSaverService!
    
    
    init(view: ImageDetailViewProtocol) {
        self.view = view
        imagesSaverService = ImageSaverService(delegate: self)
    }
    
    func onSaveButtonClick(image: UIImage) {
        imagesSaverService.writeToPhotoAlbum(image: image)
    }

}


extension ImageDetailPresenter: ImageSaverProtocol {
    func onSaveCompleted() {
        view.showSavedAlert()
    }
    
    
}

//
//  GalleryPresenter.swift
//  Gallery
//
//  Created by Ingy Salah on 3/13/22.
//

import Foundation
import UIKit

protocol GalleryViewProtocol: AnyObject {
    func onImagesReady(images: [Image])
    func showErrorAlert()
    func clearAndReloadData()
    func openImageDetailVC(image: Image)
}

class GalleryViewPresenter{

    weak var view: GalleryViewProtocol!
    var imagesApi: ImagesApi!
    
    
    init(view: GalleryViewProtocol) {
        self.view = view
        imagesApi = ImagesApi(delegate: self)
    }

    func onRefresh() {
        view.clearAndReloadData()
    }
    
    func getImages(page: Int) {
        DispatchQueue.global(qos: .background).async {
            self.imagesApi.getImages(page: page)
        }
    }
    
    func onImageCellClick(image: Image) {
        view.openImageDetailVC(image: image)
    }
}


extension GalleryViewPresenter: ImagesApiProtocol {
    
    func imagesReady(images: [Image]) {
        DispatchQueue.main.async {
            self.view.onImagesReady(images: images)
        }
    }
    
    func imagesFailed(error: BaseError) {
        DispatchQueue.main.async {
            self.view.showErrorAlert()
        }
    }
    
    func image(image: Data) {
        
    }
    
    

}

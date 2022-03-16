//
//  ImageSaverService.swift
//  Gallery
//
//  Created by Ingy Salah on 3/15/22.
//

import Foundation
import UIKit

protocol ImageSaverProtocol: AnyObject {
    func onSaveCompleted()
}

class ImageSaverService: NSObject {
    
    weak var delegate: ImageSaverProtocol!
    
    init(delegate: ImageSaverProtocol) {
        self.delegate = delegate
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        delegate?.onSaveCompleted()
    }
}

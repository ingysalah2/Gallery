//
//  ImageViewController.swift
//  Gallery
//
//  Created by Ingy Salah on 3/15/22.
//

import Foundation
import UIKit

class ImageDetailViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
 
    var image: Image!
    var presenter: ImageDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        presenter = ImageDetailPresenter(view: self)
        
        imageView.downloadImage(url: image.download_url, id: Int(image.id)!)
    }
    
    func setUpScrollView() {
        scrollView.delegate = self
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        if let image = imageView.image {
            presenter.onSaveButtonClick(image: image)
        }
    }
    
    @IBAction func onShareButtonClick(_ sender: Any) {
        
        if let image = imageView.image {
            
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view

            self.present(activityVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func onCloseButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageDetailViewController: ImageDetailViewProtocol {
    func showSavedAlert() {
        let alert = UIAlertController(title: nil, message: "Image is successfully saved ...", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
}

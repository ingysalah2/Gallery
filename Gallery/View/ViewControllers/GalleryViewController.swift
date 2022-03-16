//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Ingy Salah on 3/13/22.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var images: [Image] = []
    
    var presenter: GalleryViewPresenter!
    let refreshControl = UIRefreshControl()
    
    //Pagination handling
    var imagesPage = 0
    var lastPageReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = GalleryViewPresenter(view: self)
        setUpRefreshControl()
        setUpCollectionView()
        
        getImages()
    }
    
    func setUpCollectionView() {
        galleryCollectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
    }
    
    func setUpRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        galleryCollectionView.addSubview(refreshControl)
    }
    
    func getImages() {
        imagesPage = imagesPage + 1
        presenter.getImages(page: imagesPage)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        presenter.onRefresh()
    }
    
}

extension GalleryViewController: GalleryViewProtocol {
    
    func onImagesReady(images: [Image]) {
        self.images.append(contentsOf: images)
        galleryCollectionView.reloadData()
        
        if images.count < Configuration.imagesPageLimit {
            lastPageReached = true
        }
        
    }
    
    func clearAndReloadData() {
        images = []
        galleryCollectionView.reloadData()
        imagesPage = 0
        getImages()
        refreshControl.endRefreshing()
    }
    
    
    func showErrorAlert() {
    }
    
    func openImageDetailVC(image: Image) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        vc.image = image
        navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    
}



extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let image = images[indexPath.row]
        cell.setData(image: image)
        
        // Pagination handling
        if indexPath.row == images.count - 1 && !lastPageReached  {
            getImages()
        }
        
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.onImageCellClick(image: images[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }

}

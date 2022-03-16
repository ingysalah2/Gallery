//
//  GalleryApi.swift
//  Gallery
//
//  Created by Ingy Salah on 3/13/22.
//

import Foundation
import UIKit

protocol ImagesApiProtocol: AnyObject {
    func imagesReady(images: [Image])
    func imagesFailed(error: BaseError)
}

class ImagesApi {
    
    static var storedImages = NSCache<NSString, NSData>()
    
    weak var delegate: ImagesApiProtocol!
    var imagesDataTask: URLSessionDataTask!

    init(delegate: ImagesApiProtocol!) {
        self.delegate = delegate
    }
    
    func getImages(page: Int) {
        
        let url = "\(Configuration.picsumDomain)?page=\(page)&limit=\(Configuration.imagesPageLimit)"
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "GET"
        
        imagesDataTask = Http.shared.makeNewRequest(req: req, completion: { [weak self] data in
    
            guard let data = data else {
                self?.delegate?.imagesFailed(error: BaseError(errorCode: .ParsingError))
                return
            }
            
            do {
                let images = try JSONDecoder().decode([Image].self, from: data)
                self?.delegate?.imagesReady(images: images)
            }
            catch {
                self?.delegate?.imagesFailed(error: BaseError(errorCode: .ParsingError))
            }
            
            
            
        }, failure: { error in
            self.delegate?.imagesFailed(error: error)
        })
        imagesDataTask.resume()
    }
    
    func downloadImage(imageUrl: String, completion: @escaping (Data?) -> Void, failure: @escaping (BaseError) -> Void) -> (Void) {
            
        // cached image
        if let imageData = ImagesApi.storedImages.object(forKey: imageUrl as NSString) {
          print("using cached images")
          completion(imageData as Data)
          return
        }
        
        //download image
        let url = URL(string: imageUrl)!
        Http.shared.downloadImage(imageUrl: url, completion: {data, urlString in
            
            if let data = data, let urlString = urlString {
                let key = urlString.components(separatedBy: ".jpg")[0]
                ImagesApi.storedImages.setObject(data as NSData, forKey: key as NSString)
            }
            completion(data)
            
         }, failure: failure)
            
    }
    
}

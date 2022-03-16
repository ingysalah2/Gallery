//
//  Http.swift
//  Gallery
//
//  Created by Ingy Salah on 3/13/22.
//

import Foundation


public enum ErrorCode {
    case NetworkError
    case HTTPError
    case ParsingError
    case AuthenticationError
    case Cancelled
}

class BaseError {
    let errorCode: ErrorCode
    let description: String

    init(errorCode: ErrorCode, description: String) {
        self.errorCode = errorCode
        self.description = description
    }

    init(errorCode: ErrorCode) {
        self.errorCode = errorCode
        self.description = ""
    }

    func log() {
        print("ErrorCode: \(errorCode), Description: \(description)")
    }
}


public class Http: NSObject {

    public static let shared = Http.init()

    private let operationQueue: OperationQueue
    private var urlSession: URLSession!

    private override init() {
        operationQueue = OperationQueue.init()
        super.init()
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config)
    }

    func makeNewRequest(req: URLRequest, completion: @escaping (Data?) -> Void, failure: @escaping (BaseError) -> Void) -> URLSessionDataTask {

        let dataTask = urlSession.dataTask(with: req) { data, response, error in
            // Cancelled requests
            if let error = error {
                if error.localizedDescription == "cancelled" {
                    failure(BaseError(errorCode: .Cancelled))
                }
                else {
                    failure(BaseError(errorCode: .NetworkError, description: error.localizedDescription))
                }
                return
            }
            
            // No network
            guard let httpResponse = response as? HTTPURLResponse else {
                failure(BaseError(errorCode: .NetworkError))
                return
            }
            
            // Request completed, but may contain HTTP or parseing errors
            switch httpResponse.statusCode {
            case 200:
                completion(data)
            case 401:
                failure(BaseError(errorCode: .AuthenticationError))
            default:
                if let data = data, let dataStr = String(data: data, encoding: .utf8) {
                    print(dataStr)
                    failure(BaseError(errorCode: .HTTPError, description: "HTTP \(httpResponse.statusCode): \(dataStr)"))
                }
                else {
                    failure(BaseError(errorCode: .HTTPError, description: "HTTP \(httpResponse.statusCode):"))
                }
            }
        }
        return dataTask
    }
    
    func downloadImage(imageUrl: URL, completion: @escaping (Data?, String?) -> Void, failure: @escaping (BaseError) -> Void) -> (Void)  {
        
        let imageUrlString = imageUrl.absoluteString
        
        let task = urlSession.downloadTask(with: imageUrl) { localUrl, response, error in
          if let error = error {
            failure(BaseError(errorCode: .NetworkError, description: error.localizedDescription))
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
              failure(BaseError(errorCode: .ParsingError))
            return
          }
          
          guard let localUrl = localUrl else {
              failure(BaseError(errorCode: .ParsingError))
            return
          }
          
          do {
            let data = try Data(contentsOf: localUrl)
              completion(data, imageUrlString)
          } catch let error {
              failure(BaseError(errorCode: .ParsingError, description: error.localizedDescription))
          }
        }
        
        task.resume()
        
    }

}


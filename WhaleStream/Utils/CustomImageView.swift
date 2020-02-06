//
//  CustomImageView.swift
//  Big-n-Little
//
//  Created by wenlong qiu on 12/24/19.
//  Copyright © 2019 wenlong qiu. All rights reserved.
//

import UIKit
import SDWebImage
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoad: String?
    func loadImage(urlString: String) {
        
        lastURLUsedToLoad = urlString
        
        self.image = nil //gets rid of flicking
        
        //downloading image cost network data usage, so cache them
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else {return}

        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, err, _, _, _) in
            if let err = err {
//                print(err)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoad {
                return
            }
            
            guard let photoImage = image else {return}
            
            imageCache[url.absoluteString] = photoImage

            DispatchQueue.main.async {
                self.image = photoImage
            }
            
        }
        
//        //API for downloading content
//        URLSession.shared.dataTask(with: url) { (data, response, err) in //fetching data would be done in background
//            //if let for check nil, guard let for check not nil and unwrap
//            if let err = err {
//                print("Failed to fetch image with url", err)
//                return
//            }
//
//            //check for response status of 200(HTTP OK)???
//            //let response  = response as! HTTPURLResponse
//            //response.statusCode
//
//            if url.absoluteString != self.lastURLUsedToLoad { //if not equal means completion method overlap with second time loadImage(), but second datatask not executed. you want the second url and wants get rid the first data task. so return here
//                return
//            }
//
//
//            guard let imageData = data else {return}
//            let photoImage = UIImage(data: imageData)
//
//            imageCache[url.absoluteString] = photoImage
//
//            DispatchQueue.main.async {
//                self.image = photoImage
//            }
//        }.resume() ////resumes the task if suspended, Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task.
    }
}

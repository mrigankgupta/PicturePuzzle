//
//  WebService.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 22/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

final class WebService {
//    func getPuzzle(_ puzzle:Puzzle) -> (UIImage) {
//        return 
//    }
    func downloadImage(for url:String, completion:@escaping(UIImage) -> Void)->() {
        Alamofire.request(url).responseImage { response in
            //                debugPrint(response)
            //                print(response.request)
            //                print(response.response)
            guard let downloadedImage = response.result.value else {return}
            return completion(downloadedImage)
        }
    }
}

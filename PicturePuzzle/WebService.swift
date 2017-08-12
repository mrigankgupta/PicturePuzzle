//
//  WebService.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 22/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

enum Result {
    case error
    case success(UIImage)
}
final class WebService {
    func downloadImage(for urlString:String, completion:@escaping(Result) -> Void) {
        let url = URL(string: urlString)!
        URLSession.shared.downloadTask(with: url) { (location, _ , _) in
            if let location = location {
                do {
                    let imageData = try Data.init(contentsOf: location)
                    if let image = UIImage.init(data: imageData) {
                        DispatchQueue.main.async {
                            completion(.success(image))
                        }
                    }
                    return
                }catch {
                    DispatchQueue.main.async {
                        completion(.error)
                    }
                }
            }
        }.resume()
    }
}

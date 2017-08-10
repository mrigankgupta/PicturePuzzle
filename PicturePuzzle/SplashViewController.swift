//
//  SplashViewController.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 09/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

fileprivate let segueIdStoP = "SplashToPuzzle"

public protocol AdvertGame: class {
    func didReceivedImage(image:UIImage) -> Bool
    func didFailReceive(msg:String)
}

class SplashViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var numImage: UIImageView!
    public weak var delegate:AdvertGame?
    public weak var rootViewController: UIViewController?
    
    var currentPuzzle = Puzzle(row:3, col:4,
                               imageURL:"https://s3-eu-west-1.amazonaws.com/wagawin-ad-platform/media/testmode/banner-landscape.jpg")
    var downloadedImage: UIImage? = nil
    var cTimer:Timer?
    var counter = 3
    
    private let service = WebService()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.modalTransitionStyle = .crossDissolve
        if let downloadedImage = downloadedImage {
            self.bgImage.image = downloadedImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func load() {
        service.downloadImage(for: currentPuzzle.imageURL) {[weak self] (result) in
            switch(result) {
            case .error:
                self?.delegate?.didFailReceive(msg: "Error in loading image")
            case .success(let image):
                self?.downloadedImage = image
                let show = self?.delegate?.didReceivedImage(image: image)
                if show == true {
                    
                    self?.rootViewController?.present(self!, animated: true, completion: {
                        //start timer
                        self?.cTimer = self?.startTimer(timeInterval: 1.0, initialDelay: 3.0)
                    })
                }
            }
        }
    }
    
}

extension SplashViewController {
    @objc func countDown() {
        counter = counter-1
        if counter > 0 {
            
        }else {
            cTimer?.invalidate()
            let puzzleVC = self.storyboard?.instantiateViewController(withIdentifier: "PuzzleViewController") as! PuzzleViewController
            puzzleVC.puzzleImage = self.downloadedImage
            puzzleVC.currentPuzzle = self.currentPuzzle
            self.rootViewController?.navigationController?.pushViewController(puzzleVC, animated: false)
            self.dismiss(animated: true, completion:nil)
        }
    }
    
    func startTimer(timeInterval:TimeInterval, initialDelay:TimeInterval) ->Timer {
        let now = Date.init()
        let timer = Timer(fireAt: now.addingTimeInterval(initialDelay), interval: timeInterval, target: self, selector: #selector(self.countDown), userInfo:nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        timer.fire()
        return timer
    }
    
}

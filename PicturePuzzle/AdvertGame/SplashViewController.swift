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

public protocol AdvertGameNotifier: class {
    func didReceivedImage(image:UIImage) -> Bool
    func didFailReceive(msg:String)
}

class SplashViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var numLabel: UILabel!
    
    public weak var delegate:AdvertGameNotifier?
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
                        self?.cTimer = Timer(timeInterval: 1.0, initialDelay: 3.0, aSelector: #selector(self?.countDown), target: self as Any)
                    })
                }
            }
        }
    }
    
}

private extension SplashViewController {
    
    @objc func countDown() {
        if counter > 0 {
            numLabel.text = "\(counter)"
            self.animate(view: numLabel, duration: 1)
            counter = counter-1
        }else {
            cTimer?.invalidate()
            self.presetPuzzleController()
            self.dismiss(animated: true, completion:nil)
        }
    }
    
    func animate(view:UIView, duration:TimeInterval) {
        view.alpha = 1.0
        view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: duration) {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 14.0, y: 14.0)
        }
    }
    
    func presetPuzzleController() {
        let puzzleVC:PuzzleViewController = PuzzleViewController.storyBoardInstance(storyBoard: "AdvertGame")
        puzzleVC.puzzleImage = self.downloadedImage
        puzzleVC.currentPuzzle = self.currentPuzzle
        self.rootViewController?.navigationController?.pushViewController(puzzleVC, animated: false)
    }
}


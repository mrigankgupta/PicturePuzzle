//
//  PresenterViewController.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 09/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    
    lazy var splVC: SplashViewController = {
        let splashVC:SplashViewController = SplashViewController.storyBoardInstance(storyBoard: "AdvertGame")
        splashVC.delegate = self
        splashVC.rootViewController = self
        return splashVC
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splVC.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension RootViewController : AdvertGameNotifier {
    
    func didReceivedImage(image: UIImage) -> Bool {
        return true
    }
    
    func didFailReceive(msg: String) {
        
    }
}

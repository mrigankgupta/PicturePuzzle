//
//  PuzzleViewController.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 17/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//
import UIKit

class PuzzleViewController: UIViewController {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: VerticalProgressView!
    @IBOutlet weak var gradientView: UIView!
    
    fileprivate let gapBtwSlice:CGFloat = 1.0
    
    public var currentPuzzle: Puzzle!
    public var puzzleImage: UIImage!
    var timer: Timer?
    let totalTime = 21.0
    var time = 21.0
    
    lazy var sliced:[Slice] = {[unowned self]()->[Slice] in
        var ordered = self.puzzleImage?.slice(row:self.currentPuzzle.row, col: self.currentPuzzle.col) ?? [Slice]()
        for i in 0..<ordered.count {
            let rand = Int(arc4random()) % ordered.count
            ordered.swapAt(i, rand)
        }
        return ordered
        }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        installLongPressGesture()
        installProgressBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer(timeInterval: 1.0, initialDelay: 2.0, aSelector: #selector(self.startTime), target: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        installGradientLayer(view: gradientView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressGesture(_ gesture:UILongPressGestureRecognizer?=nil) {
        if let gesture = gesture {
            switch(gesture.state) {
            case .began:
                guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {break}
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            case .ended:
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
        }
    }
}

extension PuzzleViewController: UICollectionViewDataSource {
    //MARK: Collection Data Source Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleViewController", for: indexPath)
        let slicedImageView = cell.viewWithTag(1) as? UIImageView
        slicedImageView?.image = sliced[indexPath.item].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliced.count
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let person = sliced.remove(at: sourceIndexPath.item)
        sliced.insert(person, at: destinationIndexPath.item)
        if isOrdered(sliced) {
            //TODO:Show Alert
            print("success")
        }
    }
}

extension PuzzleViewController: UICollectionViewDelegateFlowLayout {
    //MARK: Collection Flow Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: slicedPictureWidth(), height: slicedPictureHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: gapBtwSlice, left: gapBtwSlice , bottom: gapBtwSlice, right: gapBtwSlice)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return gapBtwSlice
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return gapBtwSlice
    }
}

private extension PuzzleViewController {
    //MARK: Private Methods
    func slicedPictureWidth() -> CGFloat {
        return (collectionView.frame.size.width - gapBtwSlice*CGFloat(currentPuzzle.col+1))/CGFloat(currentPuzzle.col)
    }
    
    func slicedPictureHeight() -> CGFloat {
        return (collectionView.frame.size.height - gapBtwSlice*CGFloat(currentPuzzle.row+1))/CGFloat(currentPuzzle.row)
    }
    
    func isOrdered(_ array:[Slice]) -> Bool {
        for i in 0..<array.count {
            guard array[i].index == i else {return false}
        }
        return true
    }
    
    @objc func startTime() {
        if time > 0.0 {
            let progress = time/totalTime
            progressBar.progress = Float(progress)
            time = time - 1
        }else {
            progressBar.progress = 0.0
            timer?.invalidate()
        }
    }
    
    func installLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.2
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func installProgressBar() {
        progressBar.trackImage = UIImage(assetIdentifier: .trackImage)
        progressBar.fillColor = Pallet.ColorProgressBar.color()
        progressBar.cornerRadius = 0.0
        progressBar.insetX = 7
        progressBar.insetY = 7
    }
    
    func installGradientLayer(view:UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.locations = [0,NSNumber(value:0.09),1]
        gradientLayer.colors = [Pallet.ColorStartGradient.cgColor(),Pallet.ColorStartGradient.cgColor(),Pallet.ColorStopGradient.cgColor()]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

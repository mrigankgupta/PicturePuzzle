//
//  PuzzleViewController.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 17/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import UIKit
class PuzzleViewController: UIViewController {
    fileprivate let gapBtwSlice:CGFloat = 2.0

    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: VerticalProgressView!

    var currentPuzzle = Puzzle(row:3, col:4, imageURL:"")
    var puzzleImage: UIImage? = UIImage(assetIdentifier: .defaultImage)
    var timer: Timer?
    
    lazy var sliced:[Slice] = {
        [unowned self]()->[Slice] in
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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.2
        collectionView.addGestureRecognizer(longPressGesture)
        progressBar.trackImage = UIImage(assetIdentifier: .trackImage)
        progressBar.cornerRadius = 0.0
//        progressBar.insetX = 10
//        progressBar.insetY = 10
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            let percent = arc4random()%100
            let p = Float(percent)/100.0
            print("\(p)")
            self.progressBar.progress = Float(p)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressGesture(_ longPress:UILongPressGestureRecognizer?=nil) {
        guard let longPress = longPress else {
            return
        }
        let touchPoint = longPress.location(in: longPress.view)
        switch longPress.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {break}
            collectionView.beginInteractiveMovementForItem(at:indexPath)
        case .cancelled:
            collectionView.cancelInteractiveMovement()
        case .ended:
            collectionView.endInteractiveMovement()
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(touchPoint)
        default:
            collectionView.cancelInteractiveMovement()
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
}

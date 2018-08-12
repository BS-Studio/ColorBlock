//
//  ColorBlockViewController.swift
//  OutfitBlock
//
//  Created by Ri Zhao on 2018-08-04.
//  Copyright © 2018 Ri Zhao. All rights reserved.
//

import UIKit

final class ColorBlockCollectionViewController: UICollectionViewController, ColorPaletteCollectionViewDelegate{
    
    //MARK: variables
    fileprivate let reuseIdentifier = "colorBlockCell"
    var panColorBlockCollectionViewGestureRecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer()
    var colorViewDictionary : [Int: UIColor] = [0: .red , 1: .orange , 2 : .yellow , 3: .green , 4: .blue]
    var currentColorPaletteViewIndex: Int? = nil
    var numberOfColorBlocks : Int = 3{
        didSet{
            removePaletteViewIfIndexSet()
            collectionView?.reloadData()
            collectionView?.setNeedsLayout()
        }
    }
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGestureRecognizers()
    }

    func setUpGestureRecognizers(){
        panColorBlockCollectionViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panColorBlockCollectionViewGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panColorBlockCollectionViewGestureRecognizer)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let velocity = gesture.velocity(in: view)
        let translation = abs(gesture.translation(in: view).y)
        if (gesture.state == .ended && translation > 300){
            if (velocity.y < 0 && numberOfColorBlocks < 5){ //dragging up
                numberOfColorBlocks += 1
            }else if (velocity.y > 0 && numberOfColorBlocks > 3){ //dragging down
                numberOfColorBlocks -= 1
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removePaletteViewIfIndexSet()
        if (!((collectionView.cellForItem(at: indexPath)?.subviews.count)! > 1 )){
            let paletteCollectionView = ColorPaletteCollectionView(frame: (collectionView.cellForItem(at: indexPath)?.bounds)!, collectionViewLayout: UICollectionViewFlowLayout.init())
            paletteCollectionView.paletteDelegate = self
            paletteCollectionView.parentIndex = indexPath.item
            collectionView.cellForItem(at: indexPath)?.addSubview(paletteCollectionView)
            paletteCollectionView.bringSubview(toFront: collectionView.cellForItem(at: indexPath)!)
            currentColorPaletteViewIndex = indexPath.item
        }
    }
    
    func changeBackgroundColor(toPaletteColor paletteColor: UIColor, withIndex index: Int) {
        let path = IndexPath.init(row: index, section: 0)
        collectionView?.cellForItem(at: path)?.backgroundColor = paletteColor
        colorViewDictionary[index] = paletteColor
        collectionView?.setNeedsLayout()
    }
    
    func removePaletteViewIfIndexSet(){
        if let paletteIndex = currentColorPaletteViewIndex{
            dismissPaletteCollectionView(forIndex: paletteIndex)
        }
    }
    
    func dismissPaletteCollectionView(forIndex index: Int) {
        let path = IndexPath.init(row: index, section: 0)
        let cell = collectionView?.cellForItem(at: path)
        for view in (cell?.subviews)!{
            view.removeFromSuperview()
        }
        collectionView?.setNeedsLayout()
        currentColorPaletteViewIndex = nil
    }
    
}

// MARK: ColorBlocksCollectionView Data Delegate Methods
extension ColorBlockCollectionViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColorBlocks
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = colorViewDictionary[indexPath.item]
        return cell
    }
}

// MARK: ColorBlocksCollectionView Layout Delegates
extension ColorBlockCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / CGFloat(numberOfColorBlocks))
    }
}



//
//  ColorPaletteCollectionView.swift
//  OutfitBlock
//
//  Created by Ri Zhao on 2018-08-05.
//  Copyright © 2018 Ri Zhao. All rights reserved.
//

import UIKit
private let reuseIdentifier = "ColorPaletteCell"

//MARK: Color Block Delegate Methods
protocol ColorPaletteCollectionViewDelegate : class {
    func changeBackgroundColor(toPaletteColor paletteColor: UIColor, withIndex index: Int)
    func dismissPaletteCollectionView(forIndex index: Int)
}

class ColorPaletteCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{     
    var parentIndex = 0
    let colorsArray : [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .brown, .black, .white]
    weak var paletteDelegate : ColorPaletteCollectionViewDelegate?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.clipsToBounds = true
        self.register(ColorPaletteCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorPaletteCollectionViewCell
        cell.backgroundColor = colorsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 3, height: self.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let paletteColor = (collectionView.cellForItem(at: indexPath)?.backgroundColor)!
        paletteDelegate?.dismissPaletteCollectionView(forIndex: parentIndex)
        paletteDelegate?.changeBackgroundColor(toPaletteColor: paletteColor, withIndex: parentIndex)

    }
    
}

//
//  MetalCV.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 12.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class MetalCV: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let metals: [Metal] = {
        let fe = Metal(name: "Ferrum", mark: ["FerrumMark_1", "FerrumMark_2", "FerrumMark_3", "FerrumMark_4", "FerrumMark_5"], density: nil)
        let al = Metal(name: "Aluminium", mark: ["AluminiumMark"], density: nil)
        let ti = Metal(name: "Titanium", mark: ["TitaniumMark"], density: nil)

        return [fe, al, ti, fe, al, ti, fe, al, ti]
    }()
    
    var cellId: String?
    var chosenMetalDelegate: ChosenMetalDelegate?
    
    func setup() {
        self.delegate = self
        self.dataSource = self
        self.isHidden = true
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 28.0
        let width: CGFloat = self.frame.width
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: cellId!, for: indexPath) as! CvCell
        let metal = metals[(indexPath as NSIndexPath).item]
        cell.title.text = metal.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenMetalDelegate!.getCurrentMetal(index: indexPath.item)
    }
}

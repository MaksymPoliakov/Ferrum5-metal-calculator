//
//  MarkCV.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 14.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit


class MarkCV: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChosenMetalDelegate {

    let metals: [Metal] = {
        let fe = Metal(name: "Ferrum", mark: ["FerrumMark_1", "FerrumMark_2", "FerrumMark_3", "FerrumMark_4", "FerrumMark_5"], density: nil)
        let al = Metal(name: "Aluminium", mark: ["AluminiumMark"], density: nil)
        let ti = Metal(name: "Titanium", mark: ["TitaniumMark"], density: nil)
        
        return [fe, al, ti, fe, al, ti, fe, al, ti]
    }()
    
    var pickedMetal: Int = 0 {
        willSet {
            print("pickedMetal newValue \(newValue)")
            self.reloadData()
        }
    }
    
    var cellId: String?
    
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
        return metals[pickedMetal].mark!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: cellId!, for: indexPath) as! CvCell
        let metal = metals[pickedMetal]
        cell.title.text = metal.mark?[(indexPath as NSIndexPath).item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func getCurrentMetal(index: Int) {
        pickedMetal = index
    }
}

//
//  CvCell.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 09.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class CvCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel! {
        didSet {
            title.textAlignment = .center
            title.textColor = .black

        }
    }
    
}

//
//  RolleTypeSector.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 14.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class RolledTypeSector: NSObject {

    var minValue: CGFloat!
    var maxValue: CGFloat!
    var midValue: CGFloat!
    var sector: Int!
    
    func sectorDescription() -> String {
        
        return "\(sector), \(minValue), \(midValue), \(maxValue)"
    }

}

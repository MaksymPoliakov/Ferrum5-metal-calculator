//
//  BrainProtocol.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 16.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import Foundation


protocol BrainProtocol {
    
    func calculate(geometricParameters: [String: Float], density: Float, type: String, mode: Int)
}

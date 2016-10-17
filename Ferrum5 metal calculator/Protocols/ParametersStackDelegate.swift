//
//  ParametersStackDelegate.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 16.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import Foundation


protocol ParametersStackDelegate: class {
    
    func appendValueToStack(_ value: String?, key: String)
}

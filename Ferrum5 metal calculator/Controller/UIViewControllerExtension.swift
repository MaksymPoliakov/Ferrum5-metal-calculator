//
//  UIViewControllerExtension.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 10.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    var index: Int? {
        guard let i = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.index(of: self) else {
            return nil
        }
        return i
    }
}

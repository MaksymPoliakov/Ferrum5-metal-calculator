//
//  RolledTypeWheel.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 14.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

class RolledTypeWheel: UIControl {
    
    var delegate: MainViewController?
    var container: UIView! {
        didSet {
            guard let container = container else {
                return
            }
            container.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.black.cgColor
            container.layer.cornerRadius = container.frame.width * 0.5
        }
    }
    var numberOfSections: Int!
    var deltaAngle: CGFloat!
    var startTransform: CGAffineTransform!
    var sectors: [RolledTypeSector] = []
    var currentSector: Int! = 0
    var minAlphavalue: CGFloat = 0.6
    var maxAlphavalue: CGFloat = 1.0
    var chosenType: UIImageView!
    
    func setup(delegate: MainViewController?, sectionsNumber: Int) {
        self.delegate = delegate
        self.numberOfSections = sectionsNumber
        self.currentSector = 0
        drawWheel()
        chosenType.frame.size = CGSize(width: 100.0, height: 100.0)
        chosenType.center = self.container.center
        container.isHidden = true

    }
    
    func drawWheel() {

        container = UIView(frame: self.frame)
        
        let angleSize: CGFloat = CGFloat(2 * M_PI) / CGFloat(numberOfSections)
        
        for i in 0..<numberOfSections {

            let im = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            im.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            im.layer.position = CGPoint(x: container.bounds.size.width / 2, y: container.bounds.size.height / 2)
            im.transform = CGAffineTransform(rotationAngle: angleSize * CGFloat(i))
            im.tag = i
            
            if i == 0 {
                im.alpha = maxAlphavalue
            } else {
                im.alpha = minAlphavalue
            }
            
            let sectorImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 50, height: 50))
            sectorImage.image = UIImage(named: "rolledType_\(i).png")
            im.addSubview(sectorImage)
            container.addSubview(im)
        }
        
        container.isUserInteractionEnabled = false
        self.addSubview(container)
        
        chosenType = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 70)))
        chosenType.image = UIImage(named: "rolledType_0.png")
        chosenType.center = self.center
        self.addSubview(chosenType)
        
        sectors.reserveCapacity(numberOfSections)
        
        if numberOfSections % 2 == 0 {
            buildSectorsEven()
        } else {
            buildSectorsOdd()
        }
        
        self.delegate?.wheelDidChangeValue(getSectorName(currentSector))
    }
    
    func buildSectorsOdd() {
        
        let fanWidth: CGFloat = CGFloat(2 * M_PI) / CGFloat(numberOfSections)
        var mid: CGFloat = 0

        for i in 0..<numberOfSections {
            let sector = RolledTypeSector()
            
            sector.midValue = mid
            sector.minValue = mid - fanWidth / 2
            sector.maxValue = mid + fanWidth / 2
            sector.sector = i
            
            mid -= fanWidth
            
            if (sector.minValue <= CGFloat(-M_PI)) {
                mid = -mid
                mid -= fanWidth
            }
            
            sectors.append(sector)
        }
    }
    
    func buildSectorsEven() {

        let fanWidth: CGFloat = CGFloat(2 * M_PI) / CGFloat(numberOfSections)
        var mid: CGFloat = 0
        
        for i in 0..<numberOfSections {
            let sector = RolledTypeSector()
            
            sector.midValue = mid
            sector.minValue = mid - fanWidth / 2
            sector.maxValue = mid + fanWidth / 2
            sector.sector = i
            
            if sector.maxValue - fanWidth < CGFloat(-M_PI) {
                mid = CGFloat(M_PI)
                sector.midValue = mid
                sector.minValue = fabs(sector.maxValue)
            }
            
            mid -= fanWidth
            
            sectors.append(sector)
        }
    }

    func calculateDistanceFromCenter(_ point: CGPoint) -> CGFloat {
        let center = CGPoint(x: container.bounds.size.width / 2, y: container.bounds.size.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt(dx * dx + dy * dy)
    }

    func getSectorByValue(_ value: Int) -> UIView {
        
        var res = UIView()
        let views = container.subviews
        for im in views {
            if im.tag == value {
                res = im
            }
        }
        
        return res
    }
    
    func getSectorName(_ position: Int) -> String {
        var res = ""
        switch (position) {
        case 0:
            res = "Труба"
            break
            
        case 1:
            res = "Уголок"
            break
            
        case 2:
            res = "Лист"
            break
            
        case 3:
            res = "Пруток"
            break
            
        case 4:
            res = "Труба профильная"
            break
            
        case 5:
            res = "Швеллер"
            break
            
        case 6:
            res = "Балка"
            break
            
        default:
            break
        }
        return res
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let touchPoint = touch.location(in: self)
        let dist = calculateDistanceFromCenter(touchPoint)

        if dist < 40 || dist > 100 {

            UIView.animate(withDuration: 0.1, animations: {
                if !self.container.isHidden {
                    self.chosenType.frame.size = CGSize(width: 100.0, height: 100.0)
                    self.chosenType.center = self.container.center
                    self.container.isHidden = true
                    self.delegate?.typeLabel.isHidden = false
                } else {
                    self.chosenType.frame.size = CGSize(width: 70.0, height: 70.0)
                    self.container.isHidden = false
                    self.chosenType.center = self.container.center
                    self.delegate?.typeLabel.isHidden = true
                }
            })
            return false
        }
        
        let dx = touchPoint.x - container.center.x
        let dy = touchPoint.y - container.center.y
        
        deltaAngle = atan2(dy, dx)
        
        startTransform = container.transform
        
        let im = self.getSectorByValue(currentSector)
        im.alpha = minAlphavalue
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let pt = touch.location(in: self)
        
        let dx = pt.x - container.center.x
        let dy = pt.y - container.center.y
        let ang = atan2(dy, dx)
        let angleDifference = deltaAngle - ang
        container.transform = startTransform.rotated(by: -angleDifference)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        let radians = atan2(container.transform.b, container.transform.a)
        var newVal: CGFloat = 0.0
        for s in sectors {
            
            if (s.minValue > 0 && s.maxValue < 0) {
                if (s.maxValue > radians || s.minValue < radians) {
                    if (radians > 0) {
                        newVal = radians - CGFloat(M_PI);
                    } else {
                        newVal = CGFloat(M_PI) + radians;
                    }
                    currentSector = s.sector;
                }
            }
                
            else if (radians > s.minValue && radians < s.maxValue) {
                newVal = radians - s.midValue
                currentSector = s.sector
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            let t = self.container.transform.rotated(by: -newVal)
            self.container.transform = t
        })
        
        self.delegate?.wheelDidChangeValue(getSectorName(currentSector))
        
        let im = self.getSectorByValue(currentSector)
        im.alpha = maxAlphavalue
        chosenType.image = UIImage(named: "rolledType_\(currentSector!).png")

    }

}

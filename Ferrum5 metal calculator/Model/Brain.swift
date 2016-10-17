//
//  Brain.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 16.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import Foundation


class Brain: BrainProtocol {
    
    var result: Float = 0.0
    
    func calculate(geometricParameters: [String : Float], density: Float, type: String, mode: Int) {
        switch type {
        case "Труба":
            let d = geometricParameters["Диаметр"]! / 1000
            let t = geometricParameters["Толщ. стенки"]! / 1000
            let F = Float(M_PI) * t * (d - t)
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }
            
        case "Уголок":
            let h = geometricParameters["Высота"]! / 1000
            let w = geometricParameters["Ширина"]! / 1000
            let t = geometricParameters["Толщ. стенки"]! / 1000
            let F = t * (h + w - t)
            
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }

        case "Лист":
            let t = geometricParameters["Толщина"]! / 1000
            let w = geometricParameters["Ширина"]! / 1000
            let F = t * w
            
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }

        case "Пруток":
            let d = geometricParameters["Диаметр"]! / 1000
            let F = Float(M_PI) * d * d * 0.25
            
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }

        case "Труба профильная":
            let h = geometricParameters["Высота"]! / 1000
            let w = geometricParameters["Ширина"]! / 1000
            let t = geometricParameters["Толщ. стенки"]! / 1000
            let F = 2 * t * (h + w - (2 * t))
            
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }

        case "Швеллер":
            let h = geometricParameters["Высота"]! / 1000
            let w = geometricParameters["Ширина"]! / 1000
            let t = geometricParameters["Толщ. стенки"]! / 1000
            let F = t * ((2 * h) + w - (2 * t))
            
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }

        case "Балка":
            let h = geometricParameters["Высота балки"]! / 1000
            let w = geometricParameters["Ширина балки"]! / 1000
            let t = geometricParameters["Толщ. перемычки"]! / 1000
            let t2 = geometricParameters["Толщ. полок"]! / 1000
            let F = (2 * w * t2) + ((h - (2 * t2)) * t)
            
            switch mode {
            case 0:
                let m = geometricParameters["Вес"]
                result = m! / (F * density)
            case 1:
                let l = geometricParameters["Длина"]
                result = F * l! * density
            default:
                break
            }

        default:
            break
        }
    }
    
}

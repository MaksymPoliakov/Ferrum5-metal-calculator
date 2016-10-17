//
//  MainViewController.swift
//  Ferrum5 metal calculator
//
//  Created by Maksym Poliakov on 25.09.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, RolledTypeWheelProtocol, ParametersStackDelegate {
    
    let bgImage: UIImageView = {
//        let img = UIImageView.init(image: UIImage(named: "bg.png"))
        let img = UIImageView()
        img.backgroundColor = UIColor(white: 0.7, alpha: 1)
        img.frame = UIScreen.main.bounds
        return img
    }()
    
    @IBOutlet weak var wheel: RolledTypeWheel! {
        didSet {
            guard let wheel = wheel else {
                return
            }
            wheel.frame.size = CGSize(width: 200.0, height: 200.0)
            wheel.setup(delegate: self, sectionsNumber: 7)
        }
    }
    
    @IBOutlet weak var metalBtn: UIButton! {
        didSet {
            metalBtn.addTarget(nil, action: #selector(selectMetal(sender: )), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var markBtn: UIButton! {
        didSet {
            markBtn.addTarget(nil, action: #selector(selectMark(sendor: )), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var metalCV: MetalCV! {
        didSet {
            guard let cv = metalCV else {
                return
            }
            cv.cellId = "metalCell"
            cv.setup()
        }
    }
    
    @IBOutlet weak var metalSV: UIStackView!
    
    @IBOutlet weak var markCV: MarkCV! {
        didSet {
            guard let cv = markCV else {
                return
            }
            cv.cellId = "markCell"
            cv.setup()
        }
    }
    @IBOutlet weak var markSV: UIStackView!
    
    @IBOutlet weak var parametersSV: UIStackView! {
        didSet {
            guard let sv = parametersSV else {
                return
            }
            sv.spacing = 5
            parameters.forEach { item in
                item.parametersStackDelegate = self
                sv.addArrangedSubview(item)
            }
            
        }
    }
    
    var parameters: [ParameterSV]! = {
        let first = ParameterSV()
        first.title.text = "Диаметр"
        first.field.placeholder = "Диаметр"
        let second = ParameterSV()
        second.title.text = "Толщ. стенки"
        second.field.placeholder = "Толщ. стенки"
        let third = ParameterSV()
        third.title.text = "Вес"
        third.field.placeholder = "Вес"
        let fourth = ParameterSV()
        fourth.isHidden = true
        let fifth = ParameterSV()
        fifth.isHidden = true
        
        return [first, second, third, fourth, fifth]
    }()
    
    var parametersStack = [String: Float]() 
    
    var brain = Brain()
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var vSpacingMarkBtn: NSLayoutConstraint!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    var calculationMode: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalCV.chosenMetalDelegate = markCV
        view.insertSubview(bgImage, at: 0)

    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func selectMetal(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.metalCV.isHidden = !self.metalCV.isHidden
            self.vSpacingMarkBtn.constant = self.metalCV.isHidden ? 16.0 : 114.0
            if !self.markCV.isHidden {
                self.markCV.isHidden = true
            }
        }
    }
    
    @IBAction func selectMark(sendor: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.markCV.isHidden = !self.markCV.isHidden
            if !self.metalCV.isHidden {
                self.metalCV.isHidden = true
                self.vSpacingMarkBtn.constant = 16.0
            }
        }
    }
    
    func wheelDidChangeValue(_ newValue: String) {
        self.typeLabel.text = newValue
        self.updateParameterSV(withType: newValue)
    }
    
    func appendValueToStack(_ value: String?, key: String) {
        if value != nil {
            if value!.characters.first == "." {
                let newVal = "0" + value!
                let num = Float(newVal)
                parametersStack[key] = num
            } else {
                let num = Float(value!)
                parametersStack[key] = num
            }
        }
    }
    
    @IBAction func changeCalculationMode(_ sender: UISegmentedControl) {
        self.calculationMode = sender.selectedSegmentIndex
        switch calculationMode {
        case 0:
            self.parameters.last?.title.text = "Вес"
            self.parameters.last?.field.placeholder = "Вес"
            self.parameters.last?.field.text = ""
            self.resultLabel.text = "Длина: " + "0" + " м"
            if self.parametersStack["Длина"] != nil {
                self.parametersStack.removeValue(forKey: "Длина")
            }
        case 1:
            self.resultLabel.text = "Вес: " + "0" + " кг"
            self.parameters.last?.title.text = "Длина"
            self.parameters.last?.field.placeholder = "Длина"
            self.parameters.last?.field.text = ""
            if self.parametersStack["Вес"] != nil {
                self.parametersStack.removeValue(forKey: "Вес")
            }
        default:
            break
        }
    }

    @IBAction func Calculate(_ sender: UIButton) {
        self.brain.calculate(geometricParameters: parametersStack, density: 7800.0, type: typeLabel.text!, mode: calculationMode)
        switch calculationMode {
        case 0:
            self.resultLabel.text = "Длина: " + "\(brain.result)" + " м"
        case 1:
            self.resultLabel.text = "Вес: " + "\(brain.result)" + " кг"
        default:
            break
        }
    }
    
    func updateParameterSV(withType type: String) {
        self.parametersStack = [:]
        parameters.forEach { (item) in
            item.isHidden = true
            item.field.text = ""
            item.title.alpha = 0.0
        }
        switch type {
        case "Труба":
            parameters[0].title.text = "Диаметр"
            parameters[0].field.placeholder = "Диаметр"
            parameters[0].isHidden = false
            parameters[1].title.text = "Толщ. стенки"
            parameters[1].field.placeholder = "Толщ. стенки"
            parameters[1].isHidden = false
            parameters[4].isHidden = false

            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }
            
        case "Уголок":
            parameters[0].title.text = "Высота"
            parameters[0].field.placeholder = "Высота"
            parameters[0].isHidden = false
            parameters[1].title.text = "Ширина"
            parameters[1].field.placeholder = "Ширина"
            parameters[1].isHidden = false
            parameters[2].title.text = "Толщ. стенки"
            parameters[2].field.placeholder = "Толщ. стенки"
            parameters[2].isHidden = false
            parameters[4].isHidden = false
            
            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }

        case "Лист":
            parameters[0].title.text = "Толщина"
            parameters[0].field.placeholder = "Толщина"
            parameters[0].isHidden = false
            parameters[1].title.text = "Ширина"
            parameters[1].field.placeholder = "Ширина"
            parameters[1].isHidden = false
            parameters[4].isHidden = false
            
            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }

        case "Пруток":
            parameters[0].title.text = "Диаметр"
            parameters[0].field.placeholder = "Диаметр"
            parameters[0].isHidden = false
            parameters[4].isHidden = false
            
            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }
            
        case "Труба профильная":
            parameters[0].title.text = "Высота"
            parameters[0].field.placeholder = "Высота"
            parameters[0].isHidden = false
            parameters[1].title.text = "Ширина"
            parameters[1].field.placeholder = "Ширина"
            parameters[1].isHidden = false
            parameters[2].title.text = "Толщ. стенки"
            parameters[2].field.placeholder = "Толщ. стенки"
            parameters[2].isHidden = false
            parameters[4].isHidden = false
            
            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }
            
        case "Швеллер":
            parameters[0].title.text = "Высота"
            parameters[0].field.placeholder = "Высота"
            parameters[0].isHidden = false
            parameters[1].title.text = "Ширина"
            parameters[1].field.placeholder = "Ширина"
            parameters[1].isHidden = false
            parameters[2].title.text = "Толщ. стенки"
            parameters[2].field.placeholder = "Толщ. стенки"
            parameters[2].isHidden = false
            parameters[4].isHidden = false
            
            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }

        case "Балка":
            parameters[0].title.text = "Высота балки"
            parameters[0].field.placeholder = "Высота балки"
            parameters[1].title.text = "Ширина балки"
            parameters[1].field.placeholder = "Ширина балки"
            parameters[2].title.text = "Толщ. перемычки"
            parameters[2].field.placeholder = "Толщ. перемычки"
            parameters[3].title.text = "Толщ. полок"
            parameters[3].field.placeholder = "Толщ. полок"
            parameters[0].isHidden = false
            parameters[1].isHidden = false
            parameters[2].isHidden = false
            parameters[3].isHidden = false
            parameters[4].isHidden = false

            switch calculationMode {
            case 0:
                parameters[4].title.text = "Вес"
                parameters[4].field.placeholder = "Вес"
            case 1:
                parameters[4].title.text = "Длина"
                parameters[4].field.placeholder = "Длина"
            default:
                break
            }

        default:
        break
        }
        
    }
    
}

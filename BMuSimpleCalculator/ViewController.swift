//
//  ViewController.swift
//  BMuSimpleCalculator
//
//  Created by Jashion on 2023/3/19.
//

import UIKit

class ViewController: UIViewController {
    let div = "÷"
    let mutip = "×"
    let sub = "−"
    let add = "+"
    
    let dot = "."
    let error = "Error"
    
    var numberOnScreen = 0.0
    var previousNumber = 0.0
    var performingMath = false
    var canOperation = false
    var operation = ""
    
    var maxNumberCount = 0 //留出一位用来显示：-和.
    var realNumberCount = 0
    
    let formatter = NumberFormatter() //处理整数或者小数位位超过realNumberCount的情况
    let formatter2 = NumberFormatter() //处理整数位和小数位之和超过realNumberCount的情况
                 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxNumberCount = Int(resultLabel.frame.width / ("0" as String).size(withAttributes: [NSAttributedString.Key.font : resultLabel.font!]).width)
        realNumberCount = maxNumberCount - 1
        
        //max number count
        maxNumberCountLabel.text = "最多显示" + "\(maxNumberCount)" + "位整数或者" + "\(maxNumberCount - 1)" + "位小数"
        
        //format
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = realNumberCount - 1
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = realNumberCount
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.nilSymbol = error
        
        formatter2.usesSignificantDigits = true
        formatter2.minimumSignificantDigits = 1
        formatter2.maximumSignificantDigits = realNumberCount
        formatter2.numberStyle = .decimal
        formatter2.groupingSeparator = ""
        formatter2.nilSymbol = error
    }
            
    func checkNumberContainDecimals(_ number: Double) -> Bool {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return false
        } else {
            return true
        }
    }
    
    //formatter
    func doubleToString(number: Double) -> String {
        if let value = formatter.string(from: number as NSNumber) {
            return value
        }
        return error
    }
    
    func stringToDouble(string: String) -> Double {
        if let value = formatter.number(from: string) as? Double {
            return value
        }
        return 0.0
    }
    
    //formatter2
    func doubleToString2(number: Double) -> String {
        if let value = formatter2.string(from: number as NSNumber) {
            return value
        }
        return error
    }
    
    func stringToDouble2(string: String) -> Double {
        if let value = formatter2.number(from: string) as? Double {
            return value
        }
        return 0.0
    }

    func handleNumber() {
        let textString = doubleToString(number: numberOnScreen)
        var count = realNumberCount
        if textString.contains("-") {
            count += 1
        }
        if textString.contains(".") {
            count += 1
        }
        if textString.count <= count {
            if textString.elementsEqual("-0"){
                resultLabel.text = "0"
                numberOnScreen = 0
            } else {
                resultLabel.text = textString
            }
        } else {
            resultLabel.text = doubleToString2(number: numberOnScreen)
            numberOnScreen = stringToDouble2(string: resultLabel.text!)
        }
    }
    
    @IBAction func pressNumberButton(_ sender: UIButton) {
        if performingMath == true {
            resultLabel.text = ""
            performingMath = false
        }
        if let text = resultLabel.text {
            let number = sender.titleLabel?.text ?? ""
            if text == "0" {
                resultLabel.text = number
            } else if text.count == 2, text.contains("-"), text.contains("0"){
                let result = "-" + number
                resultLabel.text = result
            } else {
                let result = text + number
                var count = realNumberCount
                if result.contains("-") {
                    count += 1
                }
                if result.contains(".") {
                    count += 1
                }
                if result.count <= count {
                    resultLabel.text = result
                }
            }
            if let num = Double(resultLabel.text!) {
                numberOnScreen = num
            }
        }
        canOperation = true
    }
    
    @IBAction func pressDecimalButton(_ sender: UIButton) {
        if let text = resultLabel.text, !text.contains(dot) {
            var count = realNumberCount
            if text.contains("-") {
                count = maxNumberCount
            }
            if text.count < count {
                resultLabel.text = text + dot
            }

        }
    }
    
    @IBAction func pressOperationButton(_ sender: UIButton) {
        operation = sender.titleLabel?.text ?? ""
        performingMath = true
        if let text = resultLabel.text, let num = Double(text) {
            previousNumber = num
        }
        canOperation = false
    }
    
    @IBAction func pressEqualButton(_ sender: UIButton) {
        if canOperation, let text = resultLabel.text, let num = Double(text) {
            switch operation {
            case add:
                numberOnScreen = previousNumber + num
                handleNumber()
            case sub:
                numberOnScreen = previousNumber - num
                handleNumber()
            case mutip:
                numberOnScreen = previousNumber * num
                handleNumber()
            case div:
                if num != 0 {
                    numberOnScreen = previousNumber / num
                    handleNumber()
                } else {
                    resultLabel.text = error
                }
            default:
                break
            }
            performingMath = false
            canOperation = false
        }
        
    }
    
    @IBAction func pressClearButton(_ sender: UIButton) {
        previousNumber = 0
        numberOnScreen = 0
        operation = ""
        performingMath = false
        canOperation = false
        resultLabel.text = "0"
    }
    
    @IBAction func pressDeleteButton(_ sender: UIButton) {
        if let text = resultLabel.text, text.count > 1 {
            if text.elementsEqual("Error") {
                resultLabel.text = "0"
            } else if text.count == 2, text.contains("-"){
                resultLabel.text = "0"
            } else {
                resultLabel.text = String(text.dropLast(1))
            }
        } else {
            resultLabel.text = "0"
        }
    }
    
    @IBAction func pressPlusMinusButton(_ sender: UIButton) {
        if let text = resultLabel.text, let number = Double(text) {
            let newNumber = -number
            numberOnScreen = newNumber
            resultLabel.text = doubleToString(number: newNumber)
        }
    }
    
    @IBAction func pressPercentageButton(_ sender: UIButton) {
        if let text = resultLabel.text, let number = Double(text) {
            let newNumber = number / 100
            numberOnScreen = newNumber
            let textString = doubleToString(number: newNumber)
            if textString.elementsEqual("-0") {
                resultLabel.text = "0"
                numberOnScreen = 0
            } else {
                resultLabel.text = textString
            }
        }
    }

}


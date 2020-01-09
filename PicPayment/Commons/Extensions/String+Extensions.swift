//
//  String+Extensions.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 16/07/19.
//  Copyright © 2019 Hundily Cerqueira Silva. All rights reserved.
//

import Foundation
import SwiftDate

extension String {
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        return Set(self).isSubset(of: nums)
    }
    
    func toDateFormatted(with format: String) -> String {
        let date = toDate("yyyy.MM.dd", region: .brazil)
        return date?.toFormat(format) ?? ""
    }
    
    func maskAgency() -> String {
        if self.isNumeric {
            var characters = Array(self)
            
            characters.insert(".", at: 2)
            characters.insert("-", at: 9)
            
            return String(characters)
        } else {
            return self
        }
    }
    
    func isValidCPF() -> Bool {
        let numbers = compactMap({ Int(String($0)) })
        
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = slice.count + 2
            
            let digit = 11 - slice.reduce(into: 0) {
                number -= 1
                $0 += $1 * number
                } % 11
            
            return digit > 9 ? 0 : digit
        }
        
        let dv1 = digitCalculator(numbers.prefix(9))
        let dv2 = digitCalculator(numbers.prefix(10))
        
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailValidate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValidEmail = emailValidate.evaluate(with: self)
        return isValidEmail
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z0-9$@$!%*#?&]{3,}$"
        let passwordValidate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValidPassword = passwordValidate.evaluate(with: self)
        
        return isValidPassword
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func modifyCreditCardString() -> String {
        let trimmedString = self.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
}


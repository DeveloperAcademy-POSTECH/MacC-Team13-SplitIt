//
//  NumberFormatterHelper.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/16.
//

import Foundation

class NumberFormatterHelper {
    let numberFormatter: NumberFormatter
    
    init() {
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .decimal
    }
    
    func number(from formattedNumber: String) -> Int? {
        // formattedNumber를 number로 변환
        let trimmedNumber = formattedNumber.replacingOccurrences(of: ",", with: "")
        return self.numberFormatter.number(from: trimmedNumber)?.intValue
    }
    
    func formattedString(from number: Int) -> String {
        // number를 formattedNumber로 변환
        return self.numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

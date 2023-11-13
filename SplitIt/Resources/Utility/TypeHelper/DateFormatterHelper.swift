//
//  DateFormatterHelper.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/23.
//

import Foundation

class DateFormatterHelper {
    let dateFormatter: DateFormatter
    
    init() {
        self.dateFormatter = DateFormatter()
    }
    
    func dateToResult(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}

//
//  BankListData.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa

struct BankListData {
    var bankList: Observable<[Bank]> {
        return Observable.just([
            Bank(backIdx: 0, name: "선택 안함"),
            Bank(backIdx: 1, name: "NH농협"),
            Bank(backIdx: 2,name: "카카오뱅크"),
            Bank(backIdx: 3,name: "KB국민은행"),
            Bank(backIdx: 4,name: "신한은행"),
            Bank(backIdx: 5,name: "토스뱅크"),
            Bank(backIdx: 6,name: "우리은행"),
            Bank(backIdx: 7,name: "IBK기업은행"),
            Bank(backIdx: 8,name: "하나은행"),
            Bank(backIdx: 9,name: "새마을금고"),
            Bank(backIdx: 10,name: "대구은행"),
            Bank(backIdx: 11,name: "경남은행")
        ])
    }
    
}

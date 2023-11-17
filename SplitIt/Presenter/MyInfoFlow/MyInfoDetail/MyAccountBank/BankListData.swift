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
            Bank(backIdx: 2, name: "카카오뱅크"),
            Bank(backIdx: 3, name: "KB국민은행"),
            Bank(backIdx: 4, name: "신한은행"),
            Bank(backIdx: 5, name: "토스뱅크"),
            Bank(backIdx: 6, name: "우리은행"),
            Bank(backIdx: 7, name: "IBK기업은행"),
            Bank(backIdx: 8, name: "하나은행"),
            Bank(backIdx: 9, name: "새마을금고"),
            Bank(backIdx: 10, name: "대구은행"),
            Bank(backIdx: 11, name: "경남은행"),
            Bank(backIdx: 12, name: "부산은행"),
            Bank(backIdx: 13, name: "케이뱅크"),
            Bank(backIdx: 14, name: "신협은행"),
            Bank(backIdx: 15, name: "우체국"),
            Bank(backIdx: 16, name: "SC제일은행"),
            Bank(backIdx: 17, name: "광주은행"),
            Bank(backIdx: 18, name: "수협은행"),
            Bank(backIdx: 19, name: "전북은행"),
            Bank(backIdx: 20, name: "저축은행"),
            Bank(backIdx: 21, name: "제주은행"),
            Bank(backIdx: 22, name: "한국씨티은행"),
            Bank(backIdx: 23, name: "KDB산업"),
            Bank(backIdx: 24, name: "산림조합중앙회"),
            Bank(backIdx: 25, name: "SBI저축은행"),
            Bank(backIdx: 26, name: "중국은행"),
            Bank(backIdx: 27, name: "HSBC은행"),
            Bank(backIdx: 28, name: "중국공상"),
            Bank(backIdx: 29, name: "도이치은행"),
            Bank(backIdx: 30, name: "JP모간체이스은행"),
            Bank(backIdx: 31, name: "BNP파리바은행"),
            Bank(backIdx: 32, name: "중국건설은행"),
            Bank(backIdx: 33, name: "뱅크오브아메리카")
        ])
    }
    
}

//
//  PayData.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa


struct PayData {
    
    let payData: BehaviorRelay<[SocialPay]>
    static var shared = PayData()
    
    
    init() {
        payData = BehaviorRelay<[SocialPay]> (value: [
            SocialPay(socialPayIdx: 1, name: "토스페이", isTrue: false),
            SocialPay(socialPayIdx: 2, name: "카카오페이", isTrue: false),
            SocialPay(socialPayIdx: 3, name: "네이버페이", isTrue: false)
        ])
    }
    
    
    var payDataObservable: Observable<[SocialPay]> {
        return payData.asObservable()
    }
    

}


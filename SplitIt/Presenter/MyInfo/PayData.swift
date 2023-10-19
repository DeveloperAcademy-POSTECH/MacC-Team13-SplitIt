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
    
    //pay icon들 색깔 지정해주기 위해서 Driver로 전달
    var tossPayEnabled: Driver<Bool> {
        return payData.map { payColor in
            return payColor.first(where: { $0.socialPayIdx == 1 })?.isTrue ?? false
        }
        .asDriver(onErrorJustReturn: false)
    }
    
    var kakaoPayEnabled: Driver<Bool> {
        return payData.map { payColor in
            return payColor.first(where: { $0.socialPayIdx == 2})?.isTrue ?? false
        }
        .asDriver(onErrorJustReturn: false)
    }
    
    var naverPayEnabled: Driver<Bool> {
        return payData.map { payColor in
            return payColor.first(where: { $0.socialPayIdx == 3})?.isTrue ?? false
        }
        .asDriver(onErrorJustReturn: false)
    }
    
}


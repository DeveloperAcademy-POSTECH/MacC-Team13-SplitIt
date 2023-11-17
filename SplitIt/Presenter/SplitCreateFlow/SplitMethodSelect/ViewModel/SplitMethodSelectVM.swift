//
//  SplitMethodSelectVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/01.
//

import Foundation
import RxSwift
import RxCocoa

class SplitMethodSelectVM {
    struct Input {
        let methodBtnTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let showMethodTapped: ControlEvent<IndexPath>
        let methodList: Observable<[SplitMethod]>
        let csInfoCount: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let showMethodTapped = input.methodBtnTapped
        let methodListSubject = BehaviorSubject<[SplitMethod]>(value: SplitMethod.list)
        let csInfoCountDriver = Driver<String>.just(SplitRepository.share.csInfoArr.value.first!.title)
        return Output(showMethodTapped: showMethodTapped,
                      methodList: methodListSubject.asObservable(),
                      csInfoCount: csInfoCountDriver)
    }
}

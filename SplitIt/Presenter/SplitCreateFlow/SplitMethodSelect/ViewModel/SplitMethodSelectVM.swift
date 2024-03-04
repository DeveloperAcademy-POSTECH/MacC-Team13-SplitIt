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
    var splitMethodService: SplitMethodServiceType
    
    init(splitMethodService: SplitMethodServiceType) {
        self.splitMethodService = splitMethodService
    }
    
    struct Input {
        let methodBtnTapped: ControlEvent<IndexPath>
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showMethodTapped: ControlEvent<IndexPath>
        let methodList: Observable<[SplitMethod]>
        let csInfoCount: Driver<String>
        let backToPreVC: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showMethodTapped = input.methodBtnTapped
        let methodListSubject = BehaviorSubject<[SplitMethod]>(value: SplitMethod.list)
        let csInfoCountDriver = Driver<String>.just("\(splitMethodService.getCurrentSplitCSInfoCount() + 1)차")
        let backToPreVC = input.backButtonTapped.asDriver()
        
        return Output(showMethodTapped: showMethodTapped,
                      methodList: methodListSubject.asObservable(),
                      csInfoCount: csInfoCountDriver,
                      backToPreVC: backToPreVC)
    }
}

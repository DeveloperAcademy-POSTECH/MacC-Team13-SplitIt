//
//  ResultCellVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/22.
//

import RxSwift
import RxCocoa
import UIKit

class ResultCellVM {
    
    var disposeBag = DisposeBag()

    struct Input {
        let exclItems: Driver<[ExclItem]>
    }
    
    struct Output {
        let exclItemNames: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        let exclItems = input.exclItems
        let exclItemNames = BehaviorRelay<[String]>(value: [])
        
        exclItems
            .asDriver()
            .map { $0.map { $0.name} }
            .drive(exclItemNames)
            .disposed(by: disposeBag)

        return Output(exclItemNames: exclItemNames)
    }
}



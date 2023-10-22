//
//  ExclMemberEditVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/22.
//

import RxSwift
import RxCocoa
import UIKit

class ExclMemberEditVM {
    
    var disposeBag = DisposeBag()
    
    var sections = BehaviorRelay<ExclMemberEditSectionModel>(value: ExclMemberEditSectionModel.init(type: ExclMemberEditSectionType.data(.init(exclItem: .init(csInfoIdx: "", name: ""), items: []))))
    
    let index: IndexPath
    
    init(index: IndexPath) {
        self.disposeBag = DisposeBag()
        self.index = index
    }
    
    struct Input {
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let presentResultView: Driver<Void>
    }
    
    
    
    func transform(input: Input) -> Output {
        let presentResultView = input.nextButtonTapSend.asDriver()
        let allExclMemberListRepository = SplitRepository.share.exclMemberArr
        let exclItemListRepository = SplitRepository.share.exclItemArr

        presentResultView
            .drive(onNext: {
                // MARK: ResultView 로 전환될 때의 비즈니스 로직
            })
            .disposed(by: disposeBag)
        
        // MARK: ExclMember가 바뀌면 item관련 Repository에게 신호를 전함
        allExclMemberListRepository
            .map{ _ in return exclItemListRepository.value }
            .bind(to: exclItemListRepository)
            .disposed(by: disposeBag)
        
        exclItemListRepository
            .map { $0[self.index.row] }
            .subscribe(onNext: { [weak self]exclItem in
                guard let self = self else { return }
                let idx = exclItem.exclItemIdx
                var list: [ExclMember] = []
                SplitRepository.share.exclMemberArr.value.forEach { exMember in
                    if exMember.exclItemIdx == idx {
                        list.append(exMember)
                        print(exMember.name)
                    }
                }
                let ob = BehaviorRelay(value: ExclMemberEditSectionModel(type: ExclMemberEditSectionType.data(ExclMemberEditSection.init(exclItem: exclItem, items: list))))
                
                ob
                    .bind(to: sections)
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        return Output(presentResultView: presentResultView)
    }
    
}




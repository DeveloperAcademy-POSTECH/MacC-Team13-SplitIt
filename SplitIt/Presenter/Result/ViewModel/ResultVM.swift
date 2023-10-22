//
//  ResultVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import RxSwift
import RxCocoa
import UIKit

class ResultVM {
    
    var disposeBag = DisposeBag()
    
    let sections = BehaviorRelay<[ResultSection]>(value: [])

    let tappedSectionIndex = BehaviorRelay<Int>(value: -1) //TODO: 추후 ResultCellVM
    struct Input {
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let presentResultView: Driver<Void>
        let currentSplit: Driver<Split>
    }
    
    init() {
        let result1 = Result(name: ["홍승완", "진준호", "이주환"], payment: 10000, exclItems: ["소주", "맥주"])
        let result2 = Result(name: ["조채원", "하태민", "김선길"], payment: 25000, exclItems: ["양주","노래방"])
        
        let resultSection1 = ResultSection(header: SplitRepository.share.csInfoArr.value[0], items: [result1, result2])
        let resultSection2 = ResultSection(header: SplitRepository.share.csInfoArr.value[0], items: [result2, result1])
        let resultSection3 = ResultSection(header: SplitRepository.share.csInfoArr.value[0], items: [result2, result1, result2, result1])
        let addSplitSection = ResultSection(header: SplitRepository.share.csInfoArr.value[0], items: [])
        
        sections.accept([resultSection1, resultSection2, resultSection3, addSplitSection])
    }
    
    func transform(input: Input) -> Output {
        // MARK: output -> 타이틀, 날짜
        let split = SplitRepository.share.splitArr.map{$0.first!}.asDriver(onErrorJustReturn: Split())
        let splitValue = SplitRepository.share.splitArr.value.first!
        
        let csInfos = SplitRepository.share.csInfoArr.value

        // MARK: output
        let presentResultView = input.nextButtonTapSend.asDriver()
        let sectionSetted = BehaviorRelay<Int>(value: 0)
        
        return Output(presentResultView: presentResultView,
                      currentSplit: split)
    }
    
    // MARK: Repository로부터 ExclItem관련 Sections를 self.sections에 bind (삭제 예정)
    func fetchSections() {
        let allExclMemberList = SplitRepository.share.exclMemberArr.value
        let exclItemList = SplitRepository.share.exclItemArr.value
        
        let targets = exclItemList.map { exclItem in
            let idx = exclItem.exclItemIdx
            let exclMemberList = allExclMemberList.filter{ $0.exclItemIdx == idx }
            return ExclMemberSection(exclItem: exclItem, items: exclMemberList)
        }
        
        var targetModels = targets.map {
            ExclMemberSectionModel(type: ExclMemberSectionType.data($0))
        }
        
        let addExclItemButton = ExclMemberSectionModel.addExclItemButton
        targetModels.append(addExclItemButton)
        
//        sections.accept(targetModels)
    }
}


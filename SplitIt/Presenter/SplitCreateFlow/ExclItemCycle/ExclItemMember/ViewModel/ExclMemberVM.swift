//
//  ExclMemberVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import RxSwift
import RxCocoa
import UIKit

class ExclMemberVM {
    
    var disposeBag = DisposeBag()
    
    let sections = BehaviorRelay<[ExclMemberSectionModel]>(value: [])
    
    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let presentResultView: Driver<Void>
    }
    
    
    
    func transform(input: Input) -> Output {
        let presentResultView = input.nextButtonTapSend.asDriver()
        let allExclMemberListRepository = SplitRepository.share.exclMemberArr
        let exclItemListRepository = SplitRepository.share.exclItemArr
        
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                // MARK: 삭제 예정
                //fetchSections()
            })
            .disposed(by: disposeBag)

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
        
        // MARK: item관련 Repository를 RxDatasource의 Section 타입에 맞게 변환하여 bind
        exclItemListRepository
            // MARK: type => data
            .map{ repo -> [ExclMemberSectionModel] in
                var exclMemberSectionModels: [ExclMemberSectionModel] = []
                repo.forEach { exclItem in
                    let exclMemberList = allExclMemberListRepository.value.filter{ $0.exclItemIdx == exclItem.exclItemIdx }
                    let exclMemberSectionModel = ExclMemberSectionModel(type: .data(ExclMemberSection(exclItem: exclItem, items: exclMemberList)))
                    exclMemberSectionModels.append(exclMemberSectionModel)
                }
                return exclMemberSectionModels
            }
            // MARK: type => addButton
            .map{ sectionModels in
                var result = sectionModels
                let addButton = ExclMemberSectionModel.addExclItemButton
                result.append(addButton)
                return result
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
        return Output(presentResultView: presentResultView)
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
        
        sections.accept(targetModels)
    }
}


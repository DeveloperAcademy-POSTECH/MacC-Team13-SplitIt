//
//  HistoryVM.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/18.
//
import Foundation
import RxSwift
import RxCocoa

class HistoryVM {
    var historyService: HistoryServiceType
    let disposeBag = DisposeBag()
    
    init(historyService: HistoryServiceType
    ) {
        self.historyService = historyService
    }
    
    struct Input { 
        let selectedIndexPath: ControlEvent<IndexPath>
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let sectionRelay: BehaviorRelay<[CreateDateSection]>
        let isNotEmpty: BehaviorRelay<Bool>
        let selectedSplitIdx: BehaviorRelay<String>
        let moveToBackView: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        var splits: [Split] = []
        let sectionRelay = BehaviorRelay(value: [CreateDateSection]())
        let isNotEmpty = BehaviorRelay(value: true)
        let selectedSplitIdx = BehaviorRelay<String>(value: "")
        let moveToBackView = input.backButtonTapped.asDriver()
        
        historyService.fetchAllSplit()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] splitArr in
                guard let self = self else { return }
                splits = splitArr
                isNotEmpty.accept(splitArr.count != 0)
                sectionRelay.accept(self.createSection(splitArr: splitArr))
            })
            .disposed(by: disposeBag)
        
        input.selectedIndexPath
            .asDriver()
            .drive { indexPath in
                let splitIdx = splits[indexPath.row].splitIdx
                selectedSplitIdx.accept(splitIdx)
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(sectionRelay: sectionRelay, 
                      isNotEmpty: isNotEmpty,
                      selectedSplitIdx: selectedSplitIdx,
                      moveToBackView: moveToBackView)
    }
    
    private func createSection(splitArr: [Split]) -> [CreateDateSection] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        var section: [CreateDateSection] = []
        
        if let firstSplit = splitArr.first {
            var currentDate = dateFormatter.string(from: firstSplit.createDate)
            var currentGroup: [Split] = []
            
            for split in splitArr {
                let splitCreateDate = dateFormatter.string(from: split.createDate)
                
                if currentDate == splitCreateDate {
                    currentGroup.append(split)
                } else {
                    currentDate = splitCreateDate
                    let newDateSection = CreateDateSection(items: currentGroup)
                    section.append(newDateSection)
                    currentGroup = [split]
                }
            }
            
            let newDateSection = CreateDateSection(items: currentGroup)
            section.append(newDateSection)
        }
        
        return section
    }
    
    func transformToHistoryModel(split: Split) -> HistoryModel {
        let csInfoArr: [CSInfo] = historyService.getCSInfoWithSplitIdx(splitIdx: split.splitIdx)
        let csMemberArr: [CSMember] = historyService.getCSMemberWithCSInfoIdx(csInfoIdxArr: csInfoArr.map { $0.csInfoIdx })
        
        var title: String {
            if split.title == "" {
                return csInfoArr.map { $0.title }.joined(separator: ", ")
            } else {
                return split.title
            }
        }
        
        let csMembers: String = csMemberArr.map { $0.name }.joined(separator: ", ")
        let totalAmount: String = NumberFormatterHelper().formattedString(from: csInfoArr.map { $0.totalAmount }.reduce(0, +))
        
        return HistoryModel(title: title, csMembers: csMembers, totalAmount: totalAmount)
    }
}

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
    
    let disposeBag = DisposeBag()
    let repo = SplitRepository.share
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let viewWillDisappear: Observable<Bool>
    }
    
    struct Output {
        let sectionRelay: BehaviorRelay<[CreateDateSection]>
        let isNotEmpty: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let sectionRelay = BehaviorRelay(value: [CreateDateSection]())
        let isNotEmpty = BehaviorRelay(value: true)
        
        input.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.repo.fetchSplitArrFromDBForHistoryView()
                UserDefaults.standard.set("History", forKey: "ShareFlow")
            })
            .disposed(by: disposeBag)
        
        repo.splitArr.asDriver()
            .drive(onNext: { _ in
                sectionRelay.accept(self.createSection())
            })
            .disposed(by: disposeBag)
        
        repo.splitArr
            .map { $0.count != 0 }
            .bind(to: isNotEmpty)
            .disposed(by: disposeBag)
        
        return Output(sectionRelay: sectionRelay, isNotEmpty: isNotEmpty)
    }
    
    private func createSection() -> [CreateDateSection] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        var section: [CreateDateSection] = []
        
        if let firstSplit = repo.splitArr.value.first {
            var currentDate = dateFormatter.string(from: firstSplit.createDate)
            var currentGroup: [Split] = []
            
            for split in repo.splitArr.value {
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
}

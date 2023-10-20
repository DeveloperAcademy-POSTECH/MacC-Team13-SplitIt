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
        let viewDidLoad: Driver<Void>
    }
    
    struct Output {
        let sectionRelay: BehaviorRelay<[CreateDateSection]>
        let isNotEmpty: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let sectionRelay = BehaviorRelay(value: [CreateDateSection]())
        let isNotEmpty = BehaviorRelay(value: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        var currentDateString = ""
        var sections: [CreateDateSection] = []
        var newItems: [Split] = []
        
        input.viewDidLoad
            .drive(onNext: {
                // self.repo.fetchSplitArrFromDBForHistoryView()
            })
            .disposed(by: disposeBag)
        
        repo.splitArr.asDriver()
            .map{ _ = $0.map {
                if currentDateString == "" {
                    currentDateString = dateFormatter.string(from: $0.createDate)
                }

                if dateFormatter.string(from: $0.createDate) == currentDateString {
                    newItems.append($0)
                } else {
                    sections.append(CreateDateSection(items: newItems))
                    newItems = []
                    newItems.append($0)
                    currentDateString = dateFormatter.string(from: $0.createDate)
                }
            }}
            .drive(onNext: {
                sections.append(CreateDateSection(items: newItems))
                sectionRelay.accept(sections)
            })
            .disposed(by: disposeBag)
        
        repo.splitArr
            .map { $0.count != 0 }
            .bind(to: isNotEmpty)
            .disposed(by: disposeBag)
        
        print(isNotEmpty.value)
        
        return Output(sectionRelay: sectionRelay, isNotEmpty: isNotEmpty)
    }
}

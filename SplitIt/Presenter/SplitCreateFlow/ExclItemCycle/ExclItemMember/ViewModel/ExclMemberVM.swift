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
    
    let sections = BehaviorRelay<[TargetSectionModel]>(value: [])

    struct Input {
        let viewDidLoad: Driver<Void> // viewDidLoad
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let presentResultView: Driver<Void>
    }
    
    
    
    func transform(input: Input) -> Output {
        // section 입력
        let items1 = [Target(name: "나", isTarget: false),Target(name: "하태민", isTarget: false), Target(name: "제롬", isTarget: false), Target(name: "완", isTarget: false), Target(name: "조채원", isTarget: false)]
        let dataSection = TargetSection(title: "술", price: "9,000", items: items1)
        let dataSectionModel = TargetSectionModel(type: .data(dataSection))
        
        let items2 = [Target(name: "가나다라마바", isTarget: false),Target(name: "가나다", isTarget: false), Target(name: "가나", isTarget: false), Target(name: "가나다라", isTarget: false), Target(name: "키득키득입니다만", isTarget: false)]
        let dataSection2 = TargetSection(title: "돼지고기", price: "11,000", items: items2)
        let dataSectionModel2 = TargetSectionModel(type: .data(dataSection2))
        
        let items3 = [Target(name: "안녕", isTarget: false),Target(name: "하세요", isTarget: false), Target(name: "반갑습니다", isTarget: false), Target(name: "어쩌라구요", isTarget: false), Target(name: "몰라요", isTarget: false), Target(name: "으아악", isTarget: false),Target(name: "안녕", isTarget: false),Target(name: "하세요", isTarget: false), Target(name: "반갑습니다", isTarget: false), Target(name: "어쩌라구요", isTarget: false), Target(name: "몰라요", isTarget: false), Target(name: "으아악", isTarget: false)]
        let dataSection3 = TargetSection(title: "백화점", price: "5,500,000", items: items3)
        let dataSectionModel3 = TargetSectionModel(type: .data(dataSection3))
        
        let buttonSectionModel = TargetSectionModel(type: .button(TargetSection.button))
        let presentResultView = input.nextButtonTapSend.asDriver()
        
        input.viewDidLoad
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                // MARK: Repository로부터 차수 데이터 받아오기
                
                
                sections.accept([dataSectionModel,dataSectionModel2,dataSectionModel3, buttonSectionModel])
            })
            .disposed(by: disposeBag)

        presentResultView
            .drive(onNext: {
                // MARK: ResultView 로 전환될 때의 비즈니스 로직

            })
            .disposed(by: disposeBag)

        return Output(presentResultView: presentResultView)
    }
}


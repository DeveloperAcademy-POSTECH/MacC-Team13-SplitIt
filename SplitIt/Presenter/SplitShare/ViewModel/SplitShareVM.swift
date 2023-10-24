//
//  SplitShareVM.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import Foundation
import RxCocoa
import RxSwift

class SplitShareVM {
    let disposeBag = DisposeBag()
    let repo = SplitRepository.share
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let splitIdx: String
    }
    
    struct Output {
        let split: BehaviorRelay<[Split]>
        let splitResult: BehaviorRelay<[SplitMemberResult]>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .drive(onNext: {
                self.repo.fetchSplitArrFromDBWithSplitIdx(splitIdx: input.splitIdx)
            })
            .disposed(by: disposeBag)
        
        // 멤버별 정리
        var splitResultArr: [SplitMemberResult] = []
        let csInfos = repo.csInfoArr.value
        
        for csInfo in csInfos {
            // 현재 차수의 member, 제외 아이템
            let currentCSMembers = repo.csMemberArr.value.filter { $0.csInfoIdx == csInfo.csInfoIdx }
            let currentExclItems = repo.exclItemArr.value.filter { $0.csInfoIdx == csInfo.csInfoIdx }
            
            // 현재 차수의 총금액 + 제외 아이템 금액
            let currentTotalAmount = currentExclItems.map { $0.price }.reduce(0, +) + csInfo.totalAmount
            
            // 제외 아이템을 빼지 않은 인당 금액
            let personPrice: Int = currentTotalAmount / currentCSMembers.count
            
            // 현재 차수의 멤버별 결과 배열
            var currentMemberResultArr: [CSMemberResult] = []
            
            for csMember in currentCSMembers {
                // 새로운 CSMemberResult를 만들어서 배열어 넣기
                let newCSMemberResult = CSMemberResult(name: csMember.name, price: personPrice, exclItem: [])
                currentMemberResultArr.append(newCSMemberResult)
            }
            
            for exclItem in currentExclItems {
                // 현재 제외 항목의 금액
                let currentExclItemPrice = exclItem.price
                
                // 현재 제외 멤버 (먹은 사람, 안먹은 사람 둘 다 있음)
                let currentExclMembers = repo.exclMemberArr.value.filter { $0.exclItemIdx == exclItem.exclItemIdx }
                
                // 안먹은 멤버의 이름만 모은 배열
                let exclMemberNames = currentExclMembers.filter { $0.isTarget == true }.map { $0.name }
                
                // 현재 제외 멤버 당 금액
                let count = exclMemberNames.count == 0 ? 1 : exclMemberNames.count
                let personExclPrice: Int = currentExclItemPrice / count
                
                for index in 0...currentMemberResultArr.count-1 {
                    if exclMemberNames.contains(currentMemberResultArr[index].name) {
                        currentMemberResultArr[index].price -= personExclPrice
                        currentMemberResultArr[index].exclItem.append(exclItem.name)
                    }
                }
            }
            
            for memberResult in currentMemberResultArr {
                let splitResultMemberNames = splitResultArr.map { $0.memberName }
                
                if splitResultMemberNames.contains(memberResult.name) {
                    
                    let index = splitResultMemberNames.firstIndex(of: memberResult.name)
                    
                    splitResultArr[index!].memberPrice += memberResult.price
                    
                    if !memberResult.exclItem.isEmpty {
                        let exclData = csInfo.title + " [\(memberResult.exclItem.joined(separator: ", "))]"
                        splitResultArr[index!].exclDatas.append(exclData)
                    }
                } else {
                    var exclDataArr: [String] = []
                    if !memberResult.exclItem.isEmpty {
                        let exclData = csInfo.title + " [\(memberResult.exclItem.joined(separator: ", "))]"
                        exclDataArr.append(exclData)
                    }
                    
                    let newSplitResult = SplitMemberResult(memberName: memberResult.name, memberPrice: memberResult.price, exclDatas: exclDataArr)
                    splitResultArr.append(newSplitResult)
                }
            }
        }
        
        for i in 0...splitResultArr.count-1 {
            for csInfo in csInfos {
                let csMemberNames = repo.csMemberArr.value.filter { $0.csInfoIdx == csInfo.csInfoIdx }.map { $0.name }
                if !csMemberNames.contains(splitResultArr[i].memberName) {
                    let exclData = "\(csInfo.title) [참여 X]"
                    splitResultArr[i].exclDatas.append(exclData)
                }
            }
        }
        
        let split: BehaviorRelay<[Split]> = repo.splitArr
        let splitResult: BehaviorRelay<[SplitMemberResult]> = BehaviorRelay(value: splitResultArr)
        
        return Output(split: split, splitResult: splitResult)
    }
}

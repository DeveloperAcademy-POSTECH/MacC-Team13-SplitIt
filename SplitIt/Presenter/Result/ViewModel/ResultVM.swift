//
//  ResultVM.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import RxSwift
import RxCocoa
import UIKit

/// SplitArr로부터 CSInfo의 개수를 구함.
/// CSInfo의 개수만큼 ResultSection의 빈 배열을 만들어줌, header는 csInfo이며, 이때 items는 [Result]타입이며, []로 비워줌
/// CSInfo의 포함된 csMember들을 찾아냄. (csInfoIdx를 이용하여 csMemberArr를 필터링하여 각 csInfo에 맞는 csMember리스트를 구함)
/// 1. csMemberList에서 각각 Result 단일타입을 만들어 줄 수 있음.
///     Result는 각 csMember의 name,을 가지고 payment = 0, exclItems는 빈 [String] 배열을 갖도록 만듦.
/// 각 csInfo로부터 csInfoIdx를 구하여 csMemberArr를 탐색하여 각 csInfo에 맞는 csMember들을 구함.
/// 각 csInfo의 totalAmount를 통하여 총액을 구할 수 있음

class ResultVM {
    
    var disposeBag = DisposeBag()
    
    let sections = BehaviorRelay<[ResultSection]>(value: [])
    let csInfos: BehaviorRelay<[CSInfo]> = SplitRepository.share.csInfoArr
    
    let csMembers: BehaviorRelay<[CSMember]> = SplitRepository.share.csMemberArr
    
    let results: BehaviorRelay<[Result]> = BehaviorRelay(value: [])
    
    
    let tappedSectionIndex = BehaviorRelay<Int>(value: -1) //TODO: 추후 ResultCellVM
    struct Input {
        let nextButtonTapSend: Driver<Void> // 다음 버튼
    }
    
    struct Output {
        let presentResultView: Driver<Void>
        let splitTitle: Driver<String>
        let splitDateString: Driver<String>
    }
    
    init() {
        csInfos.map { csInfos -> [ResultSection] in
            var sections: [ResultSection] = []
            sections = csInfos.map { csInfo in
                var results: [Result] = []
                // 이제 각 items인 [Result]를 채워줘야함.
                // 각 Result를 만들어서 results에 append 해야함
                // name:[String], paymet:Int, exclItems:[ExclItem]이 들어감. //TODO: 추후 ExclItem교체
                
                // 먼저 name을 구해야함.
                // csInfoIdx를 통해서 csMemberArr을 필터링 하여 csMembers를 구할 수 있음.
                let currentMembers = SplitRepository.share.csMemberArr.value.filter { currentMember in
                    return currentMember.csInfoIdx == csInfo.csInfoIdx
                }
                // 이 csMembers의 name들을 각각 Result에 뿌려줘야함
                results = currentMembers.map { csMember -> Result in
                    return Result(name: [csMember.name], payment: 0, exclItems: [])
                }
                
                
                // MARK: 계산로직
                let exclItems = SplitRepository.share.exclItemArr.value.filter { exclItem in
                    return exclItem.csInfoIdx == csInfo.csInfoIdx
                }
                
                let totalExclItemsPayment = exclItems.map{ $0.price }.reduce(0, +)
                let totalAmountExceptExclItem = csInfo.totalAmount - totalExclItemsPayment
                let eqaulPayment = totalAmountExceptExclItem / results.count
                
                results = results.map { result -> Result in
                    var resResult = result
                    resResult.payment = eqaulPayment
                    return resResult
                }
                
                // 이제 각 exclItem을 모두 돌아보며
                // 각 exclItem을 가진 csMember들을 모두 구하고
                // 그 exclItem.price / csMember명수 만큼의 가격을
                // 각 csMember에게 더해준다.
                
                let exclMembersValue = SplitRepository.share.exclMemberArr.value
                
                exclItems.forEach { exclItem in
                    
                    // 해당 exclItem에 연관된 멤버를 구함
                    let relatedExclMembers = exclMembersValue.filter { exclMember in
                        return exclMember.exclItemIdx == exclItem.exclItemIdx && exclMember.isTarget
                    }
                    // 돈낼사람들
                    let payMembers = exclMembersValue.filter { exclMember in
                        return exclMember.exclItemIdx == exclItem.exclItemIdx && !exclMember.isTarget
                    }
                    // 연관멤버의 수만큼 가격을 1/n
                    let equalPrice = exclItem.price / payMembers.count
                    
                    // 기존 results를 돌아봄
                    results = results.map { result in
                        // 각 result를 봄
                        var resResult = result
                        
                        // 해당 exclItem에서 제외된 멤버에게 exclItem을 추가해주기
                        relatedExclMembers.forEach { relatedExclMember in
                            if relatedExclMember.name == resResult.name.first! {
                                resResult.exclItems.append(exclItem)
                                // MARK: 여기 지금 안먹은사람한테 append하고있음
                                //                                resResult.exclItems.append(exclItem.name)
                                //TODO: 이부분 나중에 name이 아니라 exclItem 그대로 넣어줄것
                            }
                        }
                        
                        // 제외가 아닌 멤버에게 equalPrice더해주기, exclItem 추가
                        payMembers.forEach { payMember in
                            if payMember.name == resResult.name.first! {
                                //TODO: 이부분 나중에 name이 아니라 exclItem 그대로 넣어줄것
                                resResult.payment = resResult.payment + equalPrice
                            }
                        }
                        return resResult
                    }
                }
                //                //
                //                results.forEach {
                //                    print("이름: \($0.name.first!)")
                //                    print("제외항목: \($0.exclItems)")
                //                    print("낼 금액: \($0.payment)")
                //                    print("---------------------")
                //                }
                
                let resultSection = ResultSection(header: csInfo, items: results)
                return resultSection
            }
            return sections
        }
        // 공통된 ExclItem을 가진 member를 reduce
        .map { $0.map { section -> ResultSection in
            var resultSection = section
            let results = resultSection.items
            var uniqueResults: [Result] = []
            results.forEach { result in
                if let index = uniqueResults.firstIndex(where: { $0.exclItems == result.exclItems }) {
                    uniqueResults[index].name.append(contentsOf: result.name)
                } else {
                    uniqueResults.append(result)
                }
                resultSection.items = uniqueResults
            }
            return resultSection
        }}
        // addSplitButton 섹션 추가
        .map { sections in
            var resSections = sections
            var lastSection = resSections.last!
            lastSection.isFold = false
            resSections.removeLast()
            resSections.append(lastSection)
            let addSplitSection = ResultSection(header: SplitRepository.share.csInfoArr.value[0], items: [])
            resSections.append(addSplitSection)
            return resSections
        }
        .asDriver(onErrorJustReturn: [])
        .drive(sections)
        .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        // MARK: output -> 타이틀, 날짜
        let dateFormatter = DateFormatterHelper()
        let presentResultView = input.nextButtonTapSend.asDriver()
        let split = SplitRepository.share.splitArr.map{$0.first!}.asDriver(onErrorJustReturn: Split())
        let currentSplitValue = SplitRepository.share.splitArr.value.first!
        let currentSplitIdx = currentSplitValue.splitIdx
        let currentCSInfos = SplitRepository.share.csInfoArr.value.filter{$0.splitIdx == currentSplitIdx}
        let tempSplitTitle = currentCSInfos.map{$0.title}.joined(separator: ", ")
        
        let splitTitle = split
            .map{ $0.title }
            .map{ text in
                if text.isEmpty {
                    return tempSplitTitle
                } else {
                    return text
                }
            }
            .asDriver()
        
        let splitDateString = split
            .map{ $0.createDate }
            .map(dateFormatter.dateToResult)
            .asDriver()

        return Output(presentResultView: presentResultView,
                      splitTitle: splitTitle,
                      splitDateString: splitDateString)
    }
}


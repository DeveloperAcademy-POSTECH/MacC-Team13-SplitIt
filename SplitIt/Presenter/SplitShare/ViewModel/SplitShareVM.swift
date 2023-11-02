//
//  SplitShareVM.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import RxCocoa
import RxSwift

class SplitShareVM {
    let disposeBag = DisposeBag()
    let repo = SplitRepository.share
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let viewDidAppear: Observable<Bool>
        let shareButtonTapped: ControlEvent<Void>
        let currentTableViewScrollState: ControlProperty<CGPoint>
        let tableView: UITableView
        let csAddButtonTapped: ControlEvent<Void>
        let editButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let split: BehaviorRelay<[Split]>
        let splitResult: BehaviorRelay<[SplitMemberResult]>
        let buttonState: BehaviorRelay<Bool>
        let sendItems: BehaviorRelay<[Any]>
        let showNewCSCreateFlow: ControlEvent<Void>
        let showCSEditView: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let idx = SplitRepository.share.splitArr.value.first!.splitIdx
        SplitRepository.share.fetchSplitArrFromDBWithSplitIdx(splitIdx:idx)
        
        let split: BehaviorRelay<[Split]> = repo.splitArr
        let splitResult: BehaviorRelay<[SplitMemberResult]> = BehaviorRelay(value: self.calcSplitResult())
        let sendItems = BehaviorRelay<[Any]>(value: [])
        let shareButtonState = BehaviorRelay(value: false)
        let showNewCSCreateFlow = input.csAddButtonTapped
        let showCSEditView = input.editButtonTapped
        
        input.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive (onNext: { _ in
                let idx = SplitRepository.share.splitArr.value.first!.splitIdx
                SplitRepository.share.fetchSplitArrFromDBWithSplitIdx(splitIdx: idx)
                splitResult.accept (self.calcSplitResult ())
            })
            .disposed(by: disposeBag)
                
        input.viewDidAppear
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { _ in
                if input.tableView.contentSize.height < input.tableView.frame.height * 1.6 {
                    shareButtonState.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.currentTableViewScrollState
            .asDriver()
            .drive(onNext: { offset in
                if input.tableView.contentSize.height / 3 < offset.y { shareButtonState.accept(true) }
            })
            .disposed(by: disposeBag)
        
        input.shareButtonTapped
            .asDriver()
            .drive(onNext: {
                guard let image = input.tableView.screenshot() else { return }
                sendItems.accept(self.makeSendItem(image: image))
            })
            .disposed(by: disposeBag)
        
        showNewCSCreateFlow
            .asDriver()
            .drive(onNext: {
                self.repo.createNewCS()
            })
            .disposed(by: disposeBag)
        
        return Output(split: split, splitResult: splitResult, buttonState: shareButtonState, sendItems: sendItems, showNewCSCreateFlow: showNewCSCreateFlow, showCSEditView: showCSEditView)
    }
    
    // 결과 계산 로직 메서드
    private func calcSplitResult() -> [SplitMemberResult] {
        
        var splitResultArr: [SplitMemberResult] = []
        let csInfos = repo.csInfoArr.value
        
        for csInfo in csInfos {
            // 현재 차수의 member, 제외 아이템
            let currentCSMembers = repo.csMemberArr.value.filter { $0.csInfoIdx == csInfo.csInfoIdx }
            let currentExclItems = repo.exclItemArr.value.filter { $0.csInfoIdx == csInfo.csInfoIdx }
            
            // 제외 아이템을 빼지 않은 인당 금액\
            let personPrice: Int = (csInfo.totalAmount - currentExclItems.map { $0.price }.reduce(0, +)) / currentCSMembers.count
            
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
                
                // 먹은 멤버의 이름만 모은 배열
                let exclMemberNames = currentExclMembers.filter { $0.isTarget == false }.map { $0.name }
                
                // 현재 먹은 멤버 당 금액
                let count = exclMemberNames.count == 0 ? 1 : exclMemberNames.count
                let personExclPrice: Int = currentExclItemPrice / count
                
                for index in 0...currentMemberResultArr.count-1 {
                    if exclMemberNames.contains(currentMemberResultArr[index].name) {
                        currentMemberResultArr[index].price += personExclPrice
                    } else {
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
        
        return splitResultArr
    }
    
    // Image 받아와서 공유 item 만드는 메서드
    private func makeSendItem(image: UIImage) -> [Any] {
        var items: [Any] = []
        
        let acount = UserDefaults.standard.string(forKey: "userAccount") ?? ""
        let bank = UserDefaults.standard.string(forKey: "userBank") ?? ""
        
        if acount == "" || bank == "" {
            items = [image]
        } else {
            let userInfo = "\(String(describing: acount)) \(String(describing: bank))"
            items = [image, userInfo]
        }
        
        return items
    }
}

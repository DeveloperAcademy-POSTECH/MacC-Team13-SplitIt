//
//  EditCSListVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/31.
//

import RxSwift
import Foundation
import RxCocoa
import UIKit

final class EditCSItemVM {
    var disposeBag = DisposeBag()
    
    let maxTextCount = 8
    let csInfoIdx: String
    
    init(csinfoIdx: String) {
        self.csInfoIdx = csinfoIdx
    }
    
    struct Input {
        let viewDidAppear: Observable<Bool>
        let titlePriceEditTapped: ControlEvent<UITapGestureRecognizer>
        let memberEditTapped: ControlEvent<UITapGestureRecognizer>
        let exclItemEditTapped: ControlEvent<UITapGestureRecognizer>
        let delButtonTapped: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let csTitle: Driver<String>
        let csTotalAmount: Driver<NSMutableAttributedString>
        let csMember: Driver<NSMutableAttributedString>
        let csExclItemString: Driver<NSMutableAttributedString>
        let pushCSEditTitlePriceView: Driver<UITapGestureRecognizer>
        let pushCSMemberEditView: Driver<UITapGestureRecognizer>
        let pushCSExclItemEditView: Driver<UITapGestureRecognizer>
        let popDeleteCSInfo: Driver<UITapGestureRecognizer>
        let deleteBtnHidden: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let dataModel = SplitRepository.share
        let csCount = dataModel.csInfoArr.value.count > 1 ? false : true
        let exclList = dataModel.exclItemArr.asDriver()
        let csMemberList = dataModel.csMemberArr.asDriver()
        let csinfo = dataModel.csInfoArr
                .asDriver()
                .flatMap { csinfoList -> Driver<CSInfo> in
                    if let firstcsinfo = csinfoList.first {
                        return Driver.just(firstcsinfo)
                    } else {
                        return Driver.empty()
                    }
                }
        

        let title = csinfo.map { $0.title }
        let totalAmount: Driver<NSMutableAttributedString> = csinfo.map { [weak self] csinfo in
            guard let self = self else { return NSMutableAttributedString(string: "") }
            return self.totalAmountAttributeString(price: csinfo.totalAmount)
        }
        
        let member: Driver<NSMutableAttributedString> = csMemberList.map { [weak self] members in
            guard let self = self else { return NSMutableAttributedString(string: "") }
            return self.memberAttributeString(member: members)
        }
        
        let exclString: Driver<NSMutableAttributedString> = exclList.map { [weak self] items in
            guard let self = self else { return NSMutableAttributedString(string: "") }
            return self.exclItemAttributeString(items: items)
        }

        let titlePriceEditView = input.titlePriceEditTapped.asDriver()
        let memberEditView = input.memberEditTapped.asDriver()
        let exclEditView = input.exclItemEditTapped.asDriver()
        let delbtn = input.delButtonTapped.asDriver()
        
//        input.viewDidAppear
//            .subscribe { [weak self]_ in
//                guard let self = self else { return }
////                dataModel.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: self.csInfoIdx)
//            }
//            .disposed(by: disposeBag)
        
        return Output(csTitle: title,
                      csTotalAmount: totalAmount,
                      csMember: member,
                      csExclItemString: exclString,
                      pushCSEditTitlePriceView: titlePriceEditView,
                      pushCSMemberEditView: memberEditView,
                      pushCSExclItemEditView: exclEditView,
                      popDeleteCSInfo: delbtn,
                      deleteBtnHidden: Driver<Bool>.just(csCount))
    }
    
    func memberAttributeString(member: [CSMember]) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanBody,
            .foregroundColor: UIColor.TextPrimary
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption1,
            .foregroundColor: UIColor.TextPrimary
        ]
        
        var name = ""
        var count = ""
        
        switch member.count {
        case 0:
            name = ""
            count = ""
        case 1:
            name = member[0].name
            let numberString = NSAttributedString(string: name, attributes: numberAttributes)
            let finalString = NSMutableAttributedString()
            finalString.append(numberString)
            return finalString
        default:
            name = member[1].name
            count = "\(member.count - 1)"
        }
        
        let numberString = NSAttributedString(string: name, attributes: numberAttributes)
        let textString = NSAttributedString(string: " 외 \(count)인", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
    
    func exclItemAttributeString(items: [ExclItem]) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanBody,
            .foregroundColor: UIColor.TextPrimary,
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption1,
            .foregroundColor: UIColor.TextPrimary
        ]
        
        var name = ""
        var count = ""
        
        switch items.count {
        case 0:
            let numberString = NSAttributedString(string: "따로 정산할 것이 없어요!", attributes: numberAttributes)
            let finalString = NSMutableAttributedString()
            finalString.append(numberString)
            return finalString
            
        case 1:
            name = items[0].name
            let numberString = NSAttributedString(string: name, attributes: numberAttributes)

            let finalString = NSMutableAttributedString()
            finalString.append(numberString)
            return finalString
            
        default:
            name = items[1].name
            count = "\(items.count - 1)"
        }
        
        let numberString = NSAttributedString(string: name, attributes: numberAttributes)
        let textString = NSAttributedString(string: " 외 \(count)건", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
    
    func totalAmountAttributeString(price: Int) -> NSMutableAttributedString {
        
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.NumRoundedCaption1,
            .foregroundColor: UIColor.TextPrimary
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.NumRoundedBody,
            .foregroundColor: UIColor.TextPrimary
        ]

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "\(price)"

        let numberString = NSAttributedString(string: "₩", attributes: numberAttributes)
        let textString = NSAttributedString(string: " \(formattedPrice)", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
}


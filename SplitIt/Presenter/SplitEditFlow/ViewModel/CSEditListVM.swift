//
//  CSEditListVM.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class CSEditListVM {
    var disposeBag = DisposeBag()
    
    let dataModel = SplitRepository.share
    
    private var data: Observable<CSInfo> = Observable.just(CSInfo.init(splitIdx: ""))
    
    init() {
        dataModel.fetchSplitArrFromDBWithSplitIdx(splitIdx: "652fe13e384fd0feba2561be")
        dataModel.csInfoArr
            .observe(on: MainScheduler.asyncInstance)
            .map { $0.first! }
            .subscribe(onNext: {
                self.dataModel.inputCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: $0.csInfoIdx)
            })
            .disposed(by: disposeBag)
        disposeBag = DisposeBag()
        
        data = dataModel.csInfoArr.map { $0.first! }.asObservable()
    }
    
    var itemsObservable: Observable<[ExclItem]> {
        return dataModel.exclItemArr.asObservable()
    }
    
    var titleObservable: Observable<String> {
        return data.map { $0.title }
    }
    
    var totalObservable: Observable<String> {
        return data.map { "\($0.totalAmount)" }
    }

    var membersObservable: Observable<String> {
        return dataModel.csMemberArr
            .observe(on: MainScheduler.asyncInstance)
            .map {
                if $0.count > 2 {
                    return "\($0[0].name), \( $0[1].name) 외 \($0.count - 2)인"
                }
                return "\($0[0].name), \($0[1].name)"
            }
            .asObservable()
    }
    
    struct Input {
        let titleBtnTap: ControlEvent<Void>
        let totalPriceTap: ControlEvent<Void>
        let memberTap: ControlEvent<Void>
//        let sectionHeaderSelectedSubject: ControlEvent<CSEditListHeader>
        let exclItemTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let pushTitleEditVC: Observable<Void>
        let pushPriceEditVC: Observable<Void>
        let pushMemberEditVC: Observable<Void>
//        let sectionHeaderSelectedObservable: Observable<CSEditListHeader>
        let pushExclItemEditVC: Observable<IndexPath>
//        let pushExclItemEditVC: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let title = input.titleBtnTap.asObservable()
        let price = input.totalPriceTap.asObservable()
        let member = input.memberTap.asObservable()
        let exclcell = input.exclItemTap.asObservable()
        
        return Output(pushTitleEditVC: title, pushPriceEditVC: price, pushMemberEditVC: member, pushExclItemEditVC: exclcell)
    }
    
}

func setStackView(titleBtn: UIButton, st: String) -> UIStackView {
    let view = UILabel()
    view.font = .systemFont(ofSize: 15)
    let titleLB = UILabel()
    
    titleLB.do { label in
        titleLB.text = st
        titleLB.textColor = .lightGray
        titleLB.font = .systemFont(ofSize: 12)
    }
    
    titleBtn.do { button in
        button.setTitle("수정하기", for: .normal)
        button.tintColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .left
    }
    
    let roundView = UIView(frame: .zero)
    roundView.layer.cornerRadius = 8
    roundView.layer.borderWidth = 1
    roundView.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
    
    roundView.addSubview(view)
    roundView.addSubview(titleBtn)
    
    view.snp.makeConstraints { make in
        make.leading.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
    }
    
    titleBtn.snp.makeConstraints { make in
        make.trailing.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
    }
    
    roundView.snp.makeConstraints { make in
        make.height.equalTo(43)
    }
    
    
    let titleStackView = UIStackView(arrangedSubviews: [titleLB,roundView])
    titleStackView.axis = .vertical
    titleStackView.spacing = 4
    
    return titleStackView
}

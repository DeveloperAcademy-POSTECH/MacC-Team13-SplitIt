//
//  EditCSListView.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/31.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import Reusable

class EditCSListView: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let headerView = NaviHeader()
    let titleLabel = UILabel()
    let totalAmountLabel = UILabel()
    let titlePriceEditBtn = DefaultEditButton()
    let memberLabel = UILabel()
    let memberEditBtn = DefaultEditButton()
    let exclLabel = UILabel()
    let exclEditBtn = DefaultEditButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        headerView.do {
            $0.applyStyle(.edit)
            $0.setBackButton(viewController: self)
        }
        
        titleLabel.do {
            $0.text = "완마카세 장보기"
            $0.textColor = .TextPrimary
            $0.font = .KoreanTitle3
        }
        
        totalAmountLabel.do {
            $0.attributedText = attributeStringSet2(st1: "₩", st2: "30,000")
        }
        
        memberLabel.do {
            $0.attributedText = attributeStringSet1(st1: "반갑코리", st2: "외 5인")
        }
        
        exclLabel.do {
            $0.attributedText = attributeStringSet1(st1: "소주 안먹음", st2: "외 1건")
        }
    }
    
    func setLayout() {
        let subtitle = UILabel().then {
            $0.text = "이름 / 총액"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        let titlePriceView = setTitleView()
        
        let subMember = UILabel().then {
            $0.text = "함께한 사람들"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        let memberView = setMemberView()
        
        let subExcl = UILabel().then {
            $0.text = "따로 계산할 것"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        let exclView = setExclView()
        
        
        [headerView, subtitle, titlePriceView, subMember, memberView, subExcl, exclView].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titlePriceView).inset(12)
            $0.leading.equalTo(titlePriceView).inset(16)
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9.5)
            $0.leading.equalTo(titleLabel)
        }
        
        titlePriceEditBtn.snp.makeConstraints {
            $0.top.equalTo(totalAmountLabel)
            $0.trailing.equalTo(titlePriceView).inset(16)
        }
        
        titlePriceView.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(81)
        }
        
        subMember.snp.makeConstraints {
            $0.top.equalTo(titlePriceView.snp.bottom).offset(16)
            $0.leading.equalTo(subtitle)
        }
        
        memberView.snp.makeConstraints {
            $0.top.equalTo(subMember.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titlePriceView)
            $0.height.equalTo(43)
        }
        
        memberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        memberEditBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        subExcl.snp.makeConstraints {
            $0.top.equalTo(memberView.snp.bottom).offset(16)
            $0.leading.equalTo(subtitle)
        }
        
        exclView.snp.makeConstraints {
            $0.top.equalTo(subExcl.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titlePriceView)
            $0.height.equalTo(43)
        }
        
        exclLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        exclEditBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        
    }
    
    func setBinding() {
        
    }

}

// MARK: View Draw Function
extension EditCSListView {
    private func setTitleView() -> UIView {
        let totalPriceStack = UIView().then {
            $0.addSubview(titleLabel)
            $0.addSubview(totalAmountLabel)
            $0.addSubview(titlePriceEditBtn)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
        }
        return totalPriceStack
    }
    
    private func setMemberView() -> UIView {
        let view = UIView().then {
            $0.addSubview(memberLabel)
            $0.addSubview(memberEditBtn)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
        }
        return view
    }
    
    private func setExclView() -> UIView {
        let view = UIView().then {
            $0.addSubview(exclLabel)
            $0.addSubview(exclEditBtn)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
        }
        return view
    }
    
    func attributeStringSet1(st1: String, st2: String) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanBody
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption2
        ]
        let numberString = NSAttributedString(string: st1, attributes: numberAttributes)
        let textString = NSAttributedString(string: " \(st2)", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
    
    func attributeStringSet2(st1: String, st2: String) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption2
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanBody
        ]
        let numberString = NSAttributedString(string: st1, attributes: numberAttributes)
        let textString = NSAttributedString(string: " \(st2)", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
}

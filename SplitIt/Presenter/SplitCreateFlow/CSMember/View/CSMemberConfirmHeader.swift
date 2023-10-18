//
//  CSMemberConfirmHeader.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxSwift
import RxCocoa

class CSMemberConfirmHeader: UITableViewHeaderFooterView, Reusable {

    let disposeBag = DisposeBag()

    let viewModel = CSMemberConfirmHeaderVM()
    
    let title = UILabel()
    let totalAmount = UILabel()
    let memberCount = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        contentView.do {
            $0.backgroundColor = UIColor(hex: 0xE5E4E0)
            // MARK: Bottom Border만 추가
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
        }
        
        title.do {
            $0.font = .systemFont(ofSize: 27)
        }
        
        totalAmount.do {
            $0.font = .systemFont(ofSize: 22)
        }
    }
    
    func setLayout() {
        [title, totalAmount, memberCount].forEach { contentView.addSubview($0)
        }

        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        totalAmount.snp.makeConstraints {
            $0.leading.equalTo(title.snp.leading)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        memberCount.snp.makeConstraints {
            $0.centerY.equalTo(totalAmount.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setBinding() {
        let input = CSMemberConfirmHeaderVM.Input(viewDidLoad: Driver.just(()))
        let output = viewModel.transform(input: input)
        
        output.title
            .drive(title.rx.text)
            .disposed(by: disposeBag)
        
        output.totalAmount
            .drive(totalAmount.rx.text)
            .disposed(by: disposeBag)
        
        output.memberCount
            .drive(memberCount.rx.text)
            .disposed(by: disposeBag)

        output.memberCount
            .map(setMemberCountDifferentFontSize)
            .drive(memberCount.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    func setMemberCountDifferentFontSize(text: String) -> NSAttributedString {
        let startIndex = text.index(text.startIndex, offsetBy: 1)
        let endIndex = text.index(text.endIndex, offsetBy: -1)
        let location = text.distance(from: text.startIndex, to: startIndex)
        let rangeLengh = text.distance(from: startIndex, to: endIndex)
        let largeTextRange = NSRange(location: location, length: rangeLengh)
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)], range: largeTextRange)
        return attributedText
    }
}
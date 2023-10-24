//
//  ResultSectionHeader.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxSwift
import RxCocoa

class ResultSectionHeader: UICollectionReusableView, Reusable {
    
    var disposeBag = DisposeBag()
    
//    var viewModel: ResultSectionHeaderVM!
    var viewModel: ResultVM!
    
    var indexPath = IndexPath()
    
    let titleView = UIView()
    let titleInfo = UILabel()
    let orderView = UIView()
    let orderInfo = UILabel()
    let toggleButton = UIButton()
    let leftLine = UIView()
    let rightLine = UIView()
    
    let unfoldView = UIView()
    
    let csTitleInfo = UILabel()
    let memberInfo = UILabel()
    let totalAmountInfo = UILabel()
    let memberlabel = UILabel()
    let totalAmountLabel = UILabel()
    let memberSuffixLabel = UILabel()
    let totalAmountSuffixLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.do {
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        titleView.do {
            $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        
        orderView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
        
        disposeBag = DisposeBag()
    }
    
    func setAttribute() {
        // TODO: 접힐때 maskedCorners 활용

        self.do {
            $0.clipsToBounds = true
        }
        
        titleView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        orderView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        orderInfo.do {
            $0.textColor = UIColor.TextPrimary
            $0.font = .KoreanCaption2
        }
        
        titleInfo.do {
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .KoreanCaption2
        }
        
        toggleButton.do {
            $0.setImage(UIImage(named: "ArrowTriangleIconDown"), for: .normal)
        }
        
        leftLine.do {
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        rightLine.do {
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        csTitleInfo.do {
            $0.textColor = UIColor.TextPrimary
            $0.font = .KoreanTitle3
        }
        
        totalAmountLabel.do {
            $0.textColor = UIColor.TextSecondary
            $0.font = .KoreanCaption2
            $0.text = "총액"
        }
        
        totalAmountInfo.do {
            $0.textColor = UIColor.TextPrimary
            $0.font = .KoreanBody
        }
        
        memberlabel.do {
            $0.textColor = UIColor.TextSecondary
            $0.font = .KoreanCaption2
            $0.text = "인원"
        }
        
        memberInfo.do {
            $0.textColor = UIColor.TextPrimary
            $0.font = .KoreanBody
        }
        
        memberSuffixLabel.do {
            $0.text = "명"
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        totalAmountSuffixLabel.do {
            $0.text = "KRW"
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
    }
    
    func setLayout() {
        [titleView, orderView, leftLine, rightLine, unfoldView].forEach {
            addSubview($0)
        }
        
        orderView.addSubview(orderInfo)
        
        titleView.addSubview(titleInfo)
        titleView.addSubview(toggleButton)
        
        [csTitleInfo, memberInfo, totalAmountInfo, memberlabel, totalAmountLabel, totalAmountSuffixLabel, memberSuffixLabel].forEach {
            unfoldView.addSubview($0)
        }
        
        orderView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(27)
        }
        
        orderInfo.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.centerY.height.equalTo(orderView)
            $0.leading.equalTo(orderView.snp.trailing).offset(-1)
            $0.trailing.equalToSuperview()
        }

        titleInfo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
        
        toggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(15)
        }
        
        leftLine.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(27)
            $0.leading.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(80)
        }
        
        rightLine.snp.makeConstraints {
            $0.top.equalTo(leftLine)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(80)
        }
        
        let foldHeaderHeight = 27
        let topInset = 16
        
        unfoldView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(foldHeaderHeight + topInset)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(75)
        }
        
        csTitleInfo.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        memberlabel.snp.makeConstraints {
            $0.top.equalTo(csTitleInfo.snp.bottom).offset(8)
            $0.leading.equalTo(csTitleInfo)
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.centerY.equalTo(memberlabel.snp.centerY)
            $0.leading.equalTo(memberlabel.snp.trailing).offset(20)
        }
        
        memberInfo.snp.makeConstraints {
            $0.top.equalTo(memberlabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }

        totalAmountInfo.snp.makeConstraints {
            $0.centerY.equalTo(memberInfo.snp.centerY)
            $0.leading.equalTo(totalAmountLabel)
        }
        
        memberSuffixLabel.snp.makeConstraints {
            $0.leading.equalTo(memberInfo.snp.trailing).offset(2)
            $0.centerY.equalTo(memberInfo)
        }
        totalAmountSuffixLabel.snp.makeConstraints {
            $0.leading.equalTo(totalAmountInfo.snp.trailing).offset(2)
            $0.centerY.equalTo(totalAmountInfo)
        }
    }

    func configureAddSplit() {
        [titleView, orderView, leftLine, rightLine].forEach {
            $0.isHidden = true
        }
        
        self.backgroundColor = .red
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
    }
    
    // TODO: 접힐때의 Layout 및 값 설정
    func configureFold(item: CSInfo, sectionIndex: Int) {
        let numberFormatter = NumberFormatterHelper()

        orderView.backgroundColor = backgroundColor(forSectionIndex: sectionIndex)

        titleInfo.text = item.title
        csTitleInfo.text = item.title
        totalAmountInfo.text = numberFormatter.formattedString(from: item.totalAmount)
        memberInfo.text = SplitRepository.share.csMemberArr.value.filter{$0.csInfoIdx == item.csInfoIdx}.count.formatted()
        orderInfo.text = "\(sectionIndex + 1) 번째"
        
        maskedCornersInFold()
    }
    
    // TODO: 펼칠때의 Layout 및 값 설정
    func configureUnfold(item: CSInfo, sectionIndex: Int) {
        let numberFormatter = NumberFormatterHelper()
        
        orderView.backgroundColor = backgroundColor(forSectionIndex: sectionIndex)
        
        titleInfo.text = item.title
        csTitleInfo.text = item.title
        totalAmountInfo.text = numberFormatter.formattedString(from: item.totalAmount)
        memberInfo.text = SplitRepository.share.csMemberArr.value.filter{$0.csInfoIdx == item.csInfoIdx}.count.formatted()
        orderInfo.text = "\(sectionIndex + 1) 번째"
        
        maskedCornersInUnFold()
    }
    
    func backgroundColor(forSectionIndex sectionIndex: Int) -> UIColor {
        return [UIColor.AppColorBrandCherry, UIColor.AppColorBrandPear, UIColor.AppColorBrandRadish, UIColor.AppColorBrandMushroom][sectionIndex % 4]
    }
    
    func maskedCornersInFold() {
        self.do {
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        titleView.do {
            $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        orderView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    func maskedCornersInUnFold() {
        self.do {
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        titleView.do {
            $0.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
        
        orderView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    
    func setBinding() {
        toggleButton.rx.tap
            .map { [weak self] _ in
                guard let self = self else { return 0 }
                return self.indexPath.section
            }
            .bind(to: viewModel.tappedSectionIndex)
            .disposed(by: disposeBag)
    }
}


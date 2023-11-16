//
//  ExclItemCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/29.
//

import UIKit
import Then
import Reusable
import SnapKit

class ExclItemCell: UITableViewCell, Reusable {

    let exclItemName = UILabel()
    let modifyLabel = UILabel()
    let modifyChevron = UIImageView()
    let exclMemberCountLabel = UILabel()
    let exclMembers = UILabel()
    let currencyLabel = UILabel()
    let exclItemPrice = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    
    func setAttribute() {
        self.backgroundColor = .SurfaceBrandCalmshell
        self.selectionStyle = .none
        
        contentView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.layer.cornerRadius = 4
            $0.layer.borderColor = UIColor.BorderTertiary.cgColor
            $0.layer.borderWidth = 1
            $0.frame = $0.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        }
        
        exclItemName.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        modifyLabel.do {
            $0.text = "수정하기"
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
            setUnderLine(label: $0)
        }
        
        modifyChevron.do {
            $0.image = UIImage(named: "ChevronRightIconGray")
            $0.contentMode = .scaleAspectFill
            $0.tintColor = .SurfaceTertiary
        }
        
        exclMemberCountLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
        
        exclMembers.do {
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
        }
        
        currencyLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
            $0.text = "₩"
        }
        
        exclItemPrice.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanTitle3
        }
    }
    
    func setLayout() {
        [exclItemName, modifyLabel, modifyChevron, exclMemberCountLabel, exclMembers, currencyLabel, exclItemPrice].forEach {
            contentView.addSubview($0)
        }
        
        exclItemName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(12)
            $0.height.equalTo(24)
        }
        
        modifyLabel.snp.makeConstraints {
            $0.centerY.equalTo(exclItemName)
            $0.trailing.equalTo(modifyChevron.snp.leading).offset(-5)
        }
        
        modifyChevron.snp.makeConstraints {
            $0.centerY.equalTo(exclItemName)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(8)
            $0.height.equalTo(14)
        }
        
        exclMemberCountLabel.snp.makeConstraints {
            $0.top.equalTo(exclItemName.snp.bottom).offset(8)
            $0.leading.equalTo(exclItemName)
            $0.height.equalTo(15)
        }
        
        exclMembers.snp.makeConstraints {
            $0.leading.equalTo(exclItemName)
            $0.height.equalTo(27)
            $0.top.greaterThanOrEqualTo(exclMemberCountLabel.snp.bottom).offset(5)
            $0.bottom.lessThanOrEqualTo(exclItemPrice.snp.top).offset(-8)
        }
        
        exclItemPrice.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(26)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.centerY.equalTo(exclItemPrice)
            $0.trailing.equalTo(exclItemPrice.snp.leading).offset(-4)
        }
    }

    func configure(item: ExclItemInfo) {
        let numberFormatter = NumberFormatterHelper()
        let priceToString = numberFormatter.formattedString(from: item.exclItem.price)
        let membersToString = item.items.filter{$0.isTarget}.map{$0.name}.joined(separator: ", ")
        exclItemName.text = item.exclItem.name
        exclMemberCountLabel.text = "제외된 멤버 \(item.items.filter{$0.isTarget}.count)명"
        exclMembers.text = "\(membersToString)"
        exclItemPrice.text = "\(priceToString)"
    }
    
    func setUnderLine(label: UILabel) {
        let textAttribute = NSMutableAttributedString(string: label.text ?? "")
        textAttribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: textAttribute.length))
        label.attributedText = textAttribute
    }
}


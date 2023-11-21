//
//  HistorySplitCell.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/18.
//
import UIKit
import RxCocoa
import RxSwift
import Reusable
import Then
import SnapKit

class HistorySplitCell: UICollectionViewCell, Reusable {
    
    let viewModel = HistorySplitCellVM()
    
    let splitTitleLabel = UILabel()
    let csMemberLabel = UILabel()
    let amountStackView = UIStackView()
    let totalAmountLabel = UILabel()
    let krwLabel = UILabel()
    let enterEditLabel = UILabel()
    let enterEditImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAtrribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setAtrribute() {
        contentView.do {
            $0.backgroundColor = .SurfaceWhite
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
        }
        
        splitTitleLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        csMemberLabel.do {
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption2
            $0.numberOfLines = 1
        }
        
        totalAmountLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .NumRoundedBody
        }
        
        krwLabel.do {
            $0.text = "₩"
            $0.textColor = .TextPrimary
            $0.font = .NumRoundedCaption1
        }
        
        enterEditLabel.do {
            $0.text = "자세히 보기"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption2
            setUnderLine(label: $0)
        }
        
        enterEditImage.do {
            $0.image = UIImage(named: "ChevronRightIconGray")
        }
    }
    
    private func setLayout() {
        [splitTitleLabel,csMemberLabel,amountStackView,enterEditLabel,enterEditImage].forEach {
            contentView.addSubview($0)
        }
        
        [totalAmountLabel,krwLabel].forEach {
            amountStackView.addSubview($0)
        }
        
        let width = (self.bounds.width - 32) / 2
        
        splitTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.lessThanOrEqualTo(width + 38)
        }
        
        csMemberLabel.snp.makeConstraints {
            $0.top.equalTo(splitTitleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(splitTitleLabel.snp.leading)
            $0.width.lessThanOrEqualTo(width)
        }
        
        amountStackView.snp.makeConstraints {
            $0.bottom.equalTo(csMemberLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.lessThanOrEqualTo(width)
        }
        
        krwLabel.snp.makeConstraints {
            $0.trailing.equalTo(totalAmountLabel.snp.leading).offset(-4)
            $0.bottom.equalToSuperview()
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        enterEditLabel.snp.makeConstraints {
            $0.top.equalTo(splitTitleLabel.snp.top)
            $0.trailing.equalTo(enterEditImage.snp.leading).offset(-5)
        }
        
        enterEditImage.snp.makeConstraints {
            $0.top.equalTo(enterEditLabel.snp.top)
            $0.bottom.equalTo(enterEditLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(8)
        }
    }
    
    func configure(split: Split, index: Int) {
        self.splitTitleLabel.text = split.title == "" ? viewModel.getCSTitles(splitIdx: split.splitIdx) : split.title
        self.csMemberLabel.text = viewModel.getCSMembers()
        self.totalAmountLabel.text = viewModel.getTotalAmount()
    }
    
    private func setUnderLine(label: UILabel) {
        let textAttribute = NSMutableAttributedString(string: label.text ?? "")
        textAttribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: textAttribute.length))
        label.attributedText = textAttribute
    }
}

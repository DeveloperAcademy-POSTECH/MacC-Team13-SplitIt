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
    let csTitleLabel = UILabel()
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
            $0.backgroundColor = .SurfacePrimary
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
        }
        
        splitTitleLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        csTitleLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
            $0.numberOfLines = 1
        }
        
        csMemberLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
            $0.numberOfLines = 1
        }
        
        totalAmountLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        krwLabel.do {
            $0.text = "KRW"
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
        
        enterEditLabel.do {
            $0.text = "수정하기"
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
        
        enterEditImage.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .SurfaceTertiary
        }
    }
    
    private func setLayout() {
        [splitTitleLabel,csTitleLabel,csMemberLabel,amountStackView,enterEditLabel,enterEditImage].forEach {
            contentView.addSubview($0)
        }
        
        [totalAmountLabel,krwLabel].forEach {
            amountStackView.addSubview($0)
        }
        
        let width = (self.bounds.width - 32) / 2
        
        splitTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.lessThanOrEqualTo(width)
        }
        
        csTitleLabel.snp.makeConstraints {
            $0.top.equalTo(splitTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(splitTitleLabel.snp.leading)
            $0.width.lessThanOrEqualTo(width)
        }
        
        csMemberLabel.snp.makeConstraints {
            $0.top.equalTo(csTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(splitTitleLabel.snp.leading)
            $0.width.lessThanOrEqualTo(width)
        }
        
        amountStackView.snp.makeConstraints {
            $0.bottom.equalTo(csMemberLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.lessThanOrEqualTo(width)
        }
        
        krwLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(krwLabel.snp.leading).offset(-4)
        }
        
        enterEditImage.snp.makeConstraints {
            $0.top.equalTo(splitTitleLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(8)
            $0.height.equalTo(13.8)
        }
        
        enterEditLabel.snp.makeConstraints {
            $0.centerY.equalTo(enterEditImage.snp.centerY)
            $0.trailing.equalTo(enterEditImage.snp.leading).offset(-5)
        }
    }
    
    func configure(split: Split, index: Int) {
        self.splitTitleLabel.text = split.title
        self.csTitleLabel.text = viewModel.getCSTitles(splitIdx: split.splitIdx)
        self.csMemberLabel.text = viewModel.getCSMembers()
        self.totalAmountLabel.text = viewModel.getTotalAmount()
        self.csTitleLabel.backgroundColor = backgroundColor(forSectionIndex: index)
    }
    
    private func backgroundColor(forSectionIndex sectionIndex: Int) -> UIColor {
        return [UIColor.AppColorBrandCherry, UIColor.AppColorBrandPear, UIColor.AppColorBrandRadish, UIColor.AppColorBrandMushroom][sectionIndex % 4]
    }
}

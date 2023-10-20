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
    let totalAmountLabel = UILabel()
    let krwLabel = UILabel()
    let enterEditButton = UIButton()
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
    
    func setAtrribute() {
        contentView.do {
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
        }
        
        splitTitleLabel.do {
            $0.text = "split title"
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 18)
        }
        
        csTitleLabel.do {
            $0.text = "csInfo title 조합"
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.numberOfLines = 1
        }
        
        csMemberLabel.do {
            $0.text = "csMember name 조합"
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.numberOfLines = 1
        }
        
        totalAmountLabel.do {
            $0.text = "총 액수"
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 18)
        }
        
        krwLabel.do {
            $0.text = "KRW"
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        enterEditLabel.do {
            $0.text = "수정하기"
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        enterEditImage.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.black
        }
    }
    
    func setLayout() {
        [splitTitleLabel, csTitleLabel, csMemberLabel, totalAmountLabel, krwLabel, enterEditButton].forEach {
            contentView.addSubview($0)
        }
        
        enterEditButton.addSubview(enterEditLabel)
        enterEditButton.addSubview(enterEditImage)
        
        splitTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        csTitleLabel.snp.makeConstraints {
            $0.top.equalTo(splitTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(splitTitleLabel.snp.leading)
        }
        
        csMemberLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalTo(splitTitleLabel.snp.leading)
        }
        
        krwLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().offset(-16)
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.bottom.equalTo(krwLabel.snp.bottom)
            $0.trailing.equalTo(krwLabel.snp.leading).offset(-4)
        }
        
        enterEditButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(15)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        enterEditImage.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.width.equalTo(10)
            $0.height.equalTo(13.8)
        }
        
        enterEditLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
    }
    
    func configure(split: Split) {
        self.splitTitleLabel.text = split.title
        self.csTitleLabel.text = viewModel.getCSTitles(splitIdx: split.splitIdx)
        self.csMemberLabel.text = viewModel.getCSMembers()
        self.totalAmountLabel.text = viewModel.getTotalAmount()
    }
}

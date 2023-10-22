//
//  ResultCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit
import Then
import Reusable
import SnapKit

class ResultCell: UICollectionViewCell, Reusable {

    let name = UILabel()
    let payment = UILabel()
    
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
        
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor.clear

        contentView.do {
            contentView.backgroundColor = UIColor.clear
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hex: 0xCCCCCC).cgColor
            $0.clipsToBounds = true
        }
        
        name.do {
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 12, weight: .light)
        }
        
        payment.do {
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.text = "각 25000 KRW"
        }
    }
    
    func setLayout() {
        [name, payment].forEach {
            contentView.addSubview($0)
        }
        
        name.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        // TODO: top 수정해야함 -> collectionView의 bottom으로
        payment.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    func configure(item: Result) {
        name.text = item.name.joined(separator: ", ")
    }
}


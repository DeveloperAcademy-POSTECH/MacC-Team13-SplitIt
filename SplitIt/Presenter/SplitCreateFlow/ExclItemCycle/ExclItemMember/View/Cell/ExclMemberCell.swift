//
//  ExclMemberCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit
import Then
import Reusable
import SnapKit

class ExclMemberCell: UICollectionViewCell, Reusable {

    let name = UILabel()
    
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
        contentView.do {
            $0.backgroundColor = UIColor.systemBackground
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
        }
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor.clear

        contentView.do {
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
    }
    
    func setLayout() {
        contentView.addSubview(name)
        
        name.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }

    func configure(item: ExclMember) {
        name.text = item.name
        name.textColor = item.isTarget ? .TextInvert : .TextPrimary
        
        contentView.do {
            $0.backgroundColor = item.isTarget ? .SurfaceInvert : UIColor.clear
            $0.layer.borderColor = item.isTarget ? UIColor.BorderPrimary.cgColor : UIColor.BorderTertiary.cgColor
            $0.layer.borderWidth = 1
        }
    }
}


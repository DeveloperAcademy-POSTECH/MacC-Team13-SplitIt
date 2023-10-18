//
//  ExclMemberSectionHeader.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit
import SnapKit
import Then
import Reusable

class ExclMemberSectionHeader: UICollectionReusableView, Reusable {
    let headerTitle = UILabel()
    let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        self.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
        }
        
        headerTitle.do {
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 12, weight: .light)
        }
        
        deleteButton.do {
            $0.setImage(UIImage(named: "XMark"), for: .normal)
        }
    }
    
    func setLayout() {
        [headerTitle, deleteButton].forEach { addSubview($0)}
        
        headerTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(headerTitle.snp.centerY)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.width.equalTo(15)
        }
    }
    
    // Rx의 MultiSection에서 section의 headerTitle를 세팅
    func configure(item: TargetSection, sectionIndex: Int) {
        self.backgroundColor = backgroundColor(forSectionIndex: sectionIndex)
        headerTitle.text = "[\(item.title) 값 / \(item.price) KRW]"
    }
    
    func backgroundColor(forSectionIndex sectionIndex: Int) -> UIColor {
        return sectionIndex % 2 == 1 ? UIColor(hex: 0xD3D3D3) : UIColor(hex: 0xF1F1F1)
    }
}

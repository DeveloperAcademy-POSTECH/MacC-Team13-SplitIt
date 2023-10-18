//
//  ExclAddCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit
import Then
import Reusable
import SnapKit

class ExclAddCell: UICollectionViewCell, Reusable {

    let addLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor.clear
        
        contentView.do {
            $0.backgroundColor = UIColor.clear
        }
        
        addLabel.do {
            $0.text = "따로 계산할 항목 추가하기"
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    func setLayout() {
        [addLabel].forEach { addSubview($0) }

        addLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}



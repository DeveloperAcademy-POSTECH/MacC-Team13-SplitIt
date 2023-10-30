//
//  BankCell.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import SnapKit
import Then

class BankCell: UICollectionViewCell {
    
    let nameLabel = UILabel()
    let bar = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setLayout()
        setAttribute()
       
    }

    func setAddView() {
        [nameLabel, bar].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        bar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.width.equalTo(326)
            make.height.equalTo(2)
        }
    }
    
    func setAttribute() {
        
        nameLabel.textAlignment = .left
        
        bar.do {
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.gray.cgColor
        }
       
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



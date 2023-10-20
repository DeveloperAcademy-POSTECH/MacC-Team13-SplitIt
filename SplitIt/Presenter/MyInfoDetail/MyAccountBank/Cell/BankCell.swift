//
//  BankCell.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import SnapKit

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
        contentView.addSubview(nameLabel)
        contentView.addSubview(bar)
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints { make in
          
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
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
        
        bar.layer.borderWidth = 1
        bar.layer.masksToBounds = true
        bar.layer.borderColor = UIColor.gray.cgColor
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



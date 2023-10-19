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

    override init(frame: CGRect) {
        super.init(frame: frame)

        
        setAddView()
        setLayout()
        setAttribute()
       
    }

    func setAddView() {
        contentView.addSubview(nameLabel)
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setAttribute() {
        nameLabel.textAlignment = .center
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



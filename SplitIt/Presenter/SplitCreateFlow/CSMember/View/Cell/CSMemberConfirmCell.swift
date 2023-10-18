//
//  CSMemberConfirmCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import Then
import Reusable
import SnapKit

class CSMemberConfirmCell: UITableViewCell, Reusable {

    let name = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAttribute() {
        self.backgroundColor = UIColor(hex: 0xE5E4E0)
        
        contentView.do {
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
        }
        
        name.do {
            $0.textColor = UIColor(hex: 0x202020)
        }
    }
    
    func setLayout() {
        contentView.addSubview(name)
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        name.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func configure(item: String, row: Int) {
        if row == 0 {
            configureUniqueMember(name: item)
        } else {
            configureMember(name: item)
        }
    }
    
    private func configureUniqueMember(name: String) {
        self.name.text = "\(name) (나)"
        self.name.textColor = UIColor(hex: 0xF1F1F1)
        contentView.backgroundColor = UIColor(hex: 0x343434)
    }
    
    private func configureMember(name: String) {
        self.name.text = name
        self.name.textColor = UIColor(hex: 0x202020)
        contentView.backgroundColor = UIColor(hex: 0xF8F7F4)
    }
}
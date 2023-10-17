//
//  CSMemberConfirmCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

//
//  CSMemberConfirmTableViewCell.swift
//  MacC_Tutorial
//
//  Created by 홍승완 on 2023/10/12.
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
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    func setAttribute() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        contentView.do {
            $0.backgroundColor = UIColor.clear
        }
    }
    
    func setLayout() {
        contentView.addSubview(name)
        
        name.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func configure(item: String) {
        name.text = item
    }
}

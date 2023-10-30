//
//  CSMemberCell.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/29.
//

import UIKit
import Reusable
import SnapKit
import Then

class CSMemberCell: UITableViewCell, Reusable {
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
    }
    
    private func setAttribute() {
        self.backgroundColor = .SurfaceDeactivate
        self.selectionStyle = .none
        
        contentView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        nameLabel.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
    }
    
    private func setLayout() {
        [nameLabel].forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
    }
    
    func configure(item: CSMember) {
        nameLabel.text = item.name
    }
}

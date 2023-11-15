//
//  CSMemberSearchCell.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/09.
//

import UIKit
import SnapKit
import Then
import Reusable

class CSMemberSearchCell: UITableViewCell, Reusable {
    
    let nameLabel = UILabel()
    let checkMark = UIImageView()
    
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
        
        contentView.backgroundColor = .SurfacePrimary
        contentView.layer.borderWidth = 0
        checkMark.tintColor = .TextDeactivate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
    
    func setAttribute() {
        self.backgroundColor = .SurfaceDeactivate
        self.selectionStyle = .none
        
        contentView.do {
            $0.backgroundColor = .SurfacePrimary
            $0.layer.borderWidth = 0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        nameLabel.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        checkMark.do {
            $0.image = UIImage(systemName: "checkmark")
        }
    }
    
    func setLayout() {
        [nameLabel,checkMark].forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        checkMark.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(item: MemberCheck) {
        nameLabel.text = item.name
        
        if item.isCheck {
            contentView.backgroundColor = .SurfaceBrandCherry
            checkMark.tintColor = .TextPrimary
            contentView.layer.borderColor = UIColor.BorderPrimary.cgColor
            contentView.layer.borderWidth = 1
        } else {
            contentView.backgroundColor = .SurfacePrimary
            checkMark.tintColor = .TextDeactivate
        }
    }
}

//
//  ExclItemInfoModalCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/30.
//

import UIKit
import Then
import Reusable
import SnapKit

class ExclItemInfoModalCell: UITableViewCell, Reusable {

    let name = UILabel()
    let checkMark = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setAttribute()
//        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAttribute()
        setLayout()
    }
    
    func setAttribute() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
            $0.frame = $0.frame.inset(by: UIEdgeInsets(top: 4,
                                                       left: 12,
                                                       bottom: 4,
                                                       right: 12))
        }
        
        name.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        checkMark.do {
            $0.image = UIImage(systemName: "checkmark")
        }
    }
    
    func setLayout() {
        [name,checkMark].forEach {
            contentView.addSubview($0)
        }
        
        name.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(12)
        }
        
        checkMark.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
        }
    }

    func configure(item: ExclItemTable) {
        name.text = item.name

        self.contentView.layer.borderColor = item.isTarget
        ? UIColor.AppColorGrayscale1000.cgColor
        : UIColor.SurfaceBrandCalmshell.cgColor
        
        self.contentView.backgroundColor = item.isTarget
        ? .SurfaceBrandWatermelon
        : .SurfaceBrandCalmshell
        
        self.checkMark.tintColor = item.isTarget
        ? .TextPrimary
        : .TextDeactivate
    }
}


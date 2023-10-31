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
        }
    }
    
    func setLayout() {
        contentView.addSubview(name)
        
        name.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(12)
        }
    }

    func configure(item: ExclItemTable) {
        name.text = item.name
        
        UIView.transition(with: self, duration: 0.22, options: .transitionCrossDissolve) {
            self.name.textColor = item.isTarget ? .SurfaceBrandCalmshell : .TextPrimary
            self.contentView.layer.borderColor = item.isTarget ? UIColor.SurfaceBrandWatermelonPressed.cgColor : UIColor.SurfaceBrandCalmshell.cgColor
        }
        UIView.animate(withDuration: 0.22) {
            self.contentView.backgroundColor = item.isTarget ? .SurfaceBrandWatermelon : .SurfaceBrandCalmshell
        }

        self.layoutIfNeeded()
    }
}


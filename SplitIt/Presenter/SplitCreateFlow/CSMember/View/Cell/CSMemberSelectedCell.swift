//
//  CSMemberSelectedCell.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/09.
//

import UIKit
import Reusable
import SnapKit
import Then

class CSMemberSelectedCell: UICollectionViewCell, Reusable {
    
    let nameLabel = UILabel()
    let xMark = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 13.0, left: 0, bottom: 13, right: 0))
    }
    
    private func setAttribute() {
        backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .SurfacePrimary
            $0.layer.cornerRadius = 13.5
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        nameLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        xMark.do {
            $0.image = UIImage(named: "DeleteIconTypeD")
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setLayout() {
        [nameLabel].forEach { contentView.addSubview($0) }
    }
    
    func configure(item: MemberCheck) {
        nameLabel.text = item.name
        
        if item.name != "정산자" {
            contentView.addSubview(xMark)
            
            xMark.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-12)
                $0.height.equalTo(18.5)
            }
            
            nameLabel.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(12)
            }
            
        } else {
            xMark.removeFromSuperview()
            
            nameLabel.snp.remakeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    func calculateCellWidth(item: MemberCheck) -> CGFloat {
        let text = item.name
        let textWidth = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.KoreanCaption1]).width
        
        let plusWidth = item.name == "정산자" ? 30 : 50.5
        
        return textWidth + plusWidth
    }
}

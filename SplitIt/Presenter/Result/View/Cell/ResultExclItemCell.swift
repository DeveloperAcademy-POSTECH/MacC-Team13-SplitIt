//
//  ResultExclItemCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/22.
//


import UIKit
import SnapKit
import Then
import Reusable
import RxSwift
import RxCocoa

class ResultExclItemCell: UICollectionViewCell, Reusable {
    
    let exclItemName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        contentView.do {
            contentView.backgroundColor = UIColor.SurfaceSecondary
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        exclItemName.do {
            $0.text = "- 제외항목"
            $0.textColor = UIColor.TextInvert
            $0.font = .KoreanCaption2
        }
    }
    
    func setLayout() {
        contentView.addSubview(exclItemName)
        
        exclItemName.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(15)
        }
    }
    
    func configure(item: String) {
        exclItemName.text = "- \(item)"
    }
}


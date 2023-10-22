//
//  ResultSectionBackground.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit
import SnapKit
import Then
import Reusable

class ResultSectionBackground: UICollectionReusableView, Reusable {
    let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        backgroundView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
        }
    }
    
    func setLayout() {
        self.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


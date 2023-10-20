//
//  HistorySectionHeader.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/19.
//

import UIKit
import SnapKit
import Then
import Reusable

class HistorySectionHeader: UICollectionReusableView, Reusable {
    let headerTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        headerTitle.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 12)
        }
    }
    
    func setLayout() {
        addSubview(headerTitle)
        
        headerTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
    }
    
    func configure(item: String) {
        headerTitle.text = item
    }
}

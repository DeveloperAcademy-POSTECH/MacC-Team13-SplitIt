//
//  SplitShareSectionHeader.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import Then
import SnapKit

class SplitShareSectionHeader: UIView {
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    private func setAttribute() {
        titleLabel.do {
            $0.font = .KoreanTitle2
            $0.textColor = .TextPrimary
        }
        
        dateLabel.do {
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
    }
    
    private func setLayout() {
        [titleLabel,dateLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}

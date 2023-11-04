//
//  SplitShareSectionFooter.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/02.
//

import UIKit
import Then
import SnapKit

class SplitShareSectionFooter: UIView {
    let mainTitle = UILabel()
    let subTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        mainTitle.do {
            $0.text = "Created by iOS App Split it!"
            $0.font = UIFont.systemFont(ofSize: 8, weight: .bold)
            $0.textColor = .TextPrimary
        }
        
        subTitle.do {
            $0.text = "Copyright 2023. Whipping cream on citron tea. All right reserved."
            $0.font = UIFont.systemFont(ofSize: 8)
            $0.textColor = .TextPrimary
        }
    }
    
    private func setLayout() {
        [mainTitle,subTitle].forEach {
            addSubview($0)
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}

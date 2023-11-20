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
    let imageView = UIImageView()
    
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
            $0.font = .ReceiptFooter1
            $0.textColor = .TextPrimary
            $0.setKernSpacing()
        }
        
        subTitle.do {
            $0.text = "Copyright 2023. Whipping cream on citron tea. All right reserved."
            $0.font = .ReceiptFooter2
            $0.textColor = .TextPrimary
            $0.setKernSpacing()
        }
        
        imageView.do {
            $0.image = UIImage(named: "Receipt")
        }
    }
    
    private func setLayout() {
        [mainTitle,subTitle,imageView].forEach {
            addSubview($0)
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().inset(18)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom)
            $0.leading.equalToSuperview().inset(18)
            $0.bottom.equalTo(imageView.snp.bottom)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}

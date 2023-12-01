//
//  CSMemberEmptyBackGroundView.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/09.
//

import UIKit
import Then
import SnapKit

class CSMemberEmptyBackGroundView: UIView {
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = .SurfacePrimary
        layer.borderColor = UIColor.BorderPrimary.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
        
        mainLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        subLabel.do {
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
    }
    
    private func setLayout() {
        [mainLabel,subLabel].forEach {
            addSubview($0)
        }
        
        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-42)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(42)
        }
    }
    
    func configure(item: String) {
        if item == "" {
            mainLabel.text = "멤버 내역이 없어요"
            subLabel.text = "멤버명을 입력하여 멤버를 추가하세요"
        } else {
            mainLabel.text = "'\(item)'은 내역에 없어요"
            subLabel.text = "키보드의 'return' 혹은 '추가' 버튼을 탭하세요"
        }
    }
}


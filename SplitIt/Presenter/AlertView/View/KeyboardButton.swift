//
//  KeyboardButton.swift
//  SplitIt
//
//  Created by cho on 2023/10/27.
//

import UIKit
import SnapKit


class KeyboardButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    convenience init(title: String) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        setupButton()
    }
    
    private func setupButton() {
        // 버튼에 대한 설정을 여기에 추가해주세요.
        setTitleColor(.black, for: .normal)
        backgroundColor = .systemYellow
        layer.cornerRadius = 5.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        snp.makeConstraints { make in
            make.height.equalTo(47)
            make.width.equalTo(123)
        }
 

    }
}

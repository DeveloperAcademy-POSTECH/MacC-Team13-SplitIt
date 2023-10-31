//
//  KeyboardButton.swift
//  SplitIt
//
//  Created by cho on 2023/10/27.
//

import UIKit
import SnapKit


class KeyboardButton: UIButton {
    var btnTitle: String = ""
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
        btnTitle = title
        
        setupButton()
    }
    
    private func setupButton() {
        
        let customFont = UIFont(name: "ONEMobileRegular", size: 30) ?? UIFont.systemFont(ofSize: 20)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: customFont]
        let attributedString = NSAttributedString(string: btnTitle, attributes: attributes)
        setAttributedTitle(attributedString, for: .normal)
        
        setTitle(btnTitle, for: .normal)
        backgroundColor = UIColor(hex: 0xFCFCFE)
  
        setTitleColor(.black, for: .normal)
      
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
      


    }
}

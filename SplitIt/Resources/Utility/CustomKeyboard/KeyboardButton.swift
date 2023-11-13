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
        
        let keyboardHeight = KeyboardButton.getKeyboardHeightForCurrentDevice()
        let btnWidth = Int((UIScreen.main.bounds.width - 24) / 3)
        let btnHeight = Int(keyboardHeight - 50) / 4
        
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.KoreanTitle1]
        let attributedString = NSAttributedString(string: btnTitle, attributes: attributes)
        setAttributedTitle(attributedString, for: .normal)
        
        setTitle(btnTitle, for: .normal)
        backgroundColor = UIColor(hex: 0xFCFCFE)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 8
        layer.masksToBounds = true
     
        snp.makeConstraints { make in
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
    
    static func getKeyboardHeightForCurrentDevice() -> CGFloat {
        let screenSize = UIScreen.main.nativeBounds.size
        let isIPhoneXSeries = (screenSize.height == 2436 || screenSize.height == 2688 || screenSize.height == 1792 || screenSize.height == 2532)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch screenSize.height {
            case 1136:
                return isIPhoneXSeries ? 335 : 216
            case 1334:
                return isIPhoneXSeries ? 335 : 216
            case 1920, 2208:
                return isIPhoneXSeries ? 348 : 226
            case 2436, 2688, 1792, 2532:
                return 291
            default:
                return 216
            }
        } else {
            return 291
        }
    }
    
   
}

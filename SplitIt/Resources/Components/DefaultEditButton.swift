//
//  DefaultEditButton.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/31.
//

import UIKit

final class DefaultEditButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setButtonUI() {
        let atrString = NSMutableAttributedString(string: "수정하기")
        atrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: atrString.length))
        
        let image = UIImage(systemName: "chevron.right")!
            .withRenderingMode(.alwaysTemplate)
        
        tintColor = .AppColorGrayscale1000
        setAttributedTitle(atrString, for: .normal)
        setImage(image, for: .normal)
        titleLabel?.font = .KoreanCaption2
        titleLabel?.textColor = .TextPrimary
        semanticContentAttribute = .forceRightToLeft
    }
}

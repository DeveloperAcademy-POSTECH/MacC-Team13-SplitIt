//
//  UILabel+.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/16.
//

import UIKit

extension UILabel {
    func setLineSpacing(_ spacing: CGFloat) {
        guard let labelText = self.text else { return }
        
        // 현재의 속성 가져오기
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let existingAttributes = self.attributedText?.attributes(at: 0, effectiveRange: nil) {
            attributes = existingAttributes
        }
        
        // 기존의 텍스트 정렬 속성 유지
        let existingTextAlignment = self.textAlignment
        
        // 새로운 행 간격 속성 추가
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attributes[.paragraphStyle] = paragraphStyle
        
        // 새로운 속성으로 레이블 설정
        let attributedString = NSMutableAttributedString(string: labelText, attributes: attributes)
        self.attributedText = attributedString
        
        // 기존의 텍스트 정렬 속성을 다시 적용
        self.textAlignment = existingTextAlignment
    }
    
    func setKernSpacing(spacingValue: Double = -1) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: spacingValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
    
    func countCurrentLines() -> Int {
        guard let text = self.text as NSString? else { return 0 }
        guard let font = self.font else { return 0 }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        if let kernAttribute = self.attributedText?.attributes(at: 0, effectiveRange: nil).first(where: { key, _ in
            return key == .kern
        }) {
            attributes[.kern] = kernAttribute.value
        }
        attributes[.font] = font
        
        let labelTextSize = text.boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 130, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        return Int(ceil(labelTextSize.height / font.lineHeight))
    }
}

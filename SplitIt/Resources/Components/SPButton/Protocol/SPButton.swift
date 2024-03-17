//
//  SPButtonProtocol.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit

protocol SPButton: UIButton {
    func configureUniqueProperties()
    func configureUnpressedProperties()
    func configurePressedProperties()
}

extension SPButton {
    func updateVerticalPosition(_ target: UIButton, by y: CGFloat) {
        target.frame = CGRect(origin: CGPoint(x: target.frame.minX,
                                            y: target.frame.minY + y),
                            size: target.frame.size)
    }
    
    // 공통 프로퍼티
    func configureCommonProperties(_ target: UIButton) {
        target.layer.masksToBounds = false
        target.layer.borderWidth = 1
        target.layer.shadowRadius = 0
        target.layer.shadowOpacity = 1
    }
   
    // 활성 상태 프로퍼티
    func configureActiveProperties(_ target: UIButton) {
        target.setTitleColor(.TextPrimary, for: .normal)
        target.layer.borderColor = UIColor.BorderPrimary.cgColor
        target.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    // 활성 상태 프로퍼티 텍스트 색 반전
    func configureActivePropertiesInvert(_ target: UIButton) {
        target.setTitleColor(.TextInvert, for: .normal)
        target.layer.borderColor = UIColor.BorderPrimary.cgColor
        target.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    // 비활성 상태 프로퍼티
    func configureDeactiveProperties(_ target: UIButton) {
        target.setTitleColor(.TextDeactivate, for: .normal)
        target.layer.borderColor = UIColor.BorderDeactivate.cgColor
        target.layer.shadowColor = UIColor.BorderDeactivate.cgColor
    }
}

//
//  UIView+.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit


extension UIView {
    
    /// UIView의 cornerRadius를 각각 설정해줄 수 있습니다.
    /// -> example:   view.roundCorners(corners: [.topLeft, .topRight], radius: 20)
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

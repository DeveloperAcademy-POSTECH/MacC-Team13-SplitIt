//
//  UIColor+.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import UIKit

//MARK: 토마토 Task, 아래는 예시
extension UIColor {
    class var JSRed: UIColor { return UIColor(hex: 0xFF6E65) }
    class var JSBlue: UIColor { return UIColor(hex: 0x66CCFF) }
    class var JSPuple: UIColor { return UIColor(hex: 0xDD77DD) }
    class var JSGreen: UIColor { return UIColor(hex: 0x66EE66) }
    class var JSGray: UIColor { return UIColor(hex: 0xC7C7C7) }
    class var JSYellow: UIColor { return UIColor(hex: 0xFDD15F) }
}

// MARK: UIColor extension: "hex 값으로 Color를 세팅합니다."
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    convenience init(hex: Int) {
           self.init(
               red: (hex >> 16) & 0xFF,
               green: (hex >> 8) & 0xFF,
               blue: hex & 0xFF
           )
       }

    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}

 

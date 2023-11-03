//
//  UIDevice+.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/11/03.
//

import UIKit

public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }

    enum ScreenType: String {
        case iPhoneSE
        case defaultDevice
    }

    var screenType: ScreenType {
        guard iPhone else { return .defaultDevice }
        switch UIScreen.main.nativeBounds.width {
        case 750: // for iPhone SE Generation 3
            return .iPhoneSE
        default: // for Other Devices
            return .defaultDevice
        }
    }
    
}

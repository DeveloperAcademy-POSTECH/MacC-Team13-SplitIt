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
        case iPhoneSEAndMini
        case defaultDevice
    }

    var screenType: ScreenType {
        guard iPhone else { return .defaultDevice }
        switch UIScreen.main.nativeBounds.width {
        case 750: // iPhone SE Generation 3
            return .iPhoneSEAndMini
        case 1080: // iPhone Mini Series
            return .iPhoneSEAndMini
        default: // for Other Devices
            return .defaultDevice
        }
    }
}

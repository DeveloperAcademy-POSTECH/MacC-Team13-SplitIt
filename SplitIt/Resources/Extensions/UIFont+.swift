//
//  UIFont+.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/10/18.
//

import UIKit

struct AppFontName {
    static let OneL = "ONEMobileLight"
    static let OneR = "ONEMobileRegular"
    static let OneB = "ONEMobileBold"
    static let EdcR = "EliceDigitalCodingver.H"
    static let EdcB = "EliceDigitalCodingver.H-Bd"
}

extension UIFont {
    
    // MARK: Receipt Typeface
    
    /**
     30pt / Receipt / Title 1
     - parameters:
        - property: $receipt-title1
     */
    class var ReceiptTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.EdcR, size: 28)!
        case .defaultDevice:
            return UIFont(name: AppFontName.EdcR, size: 30)!
        }
    }

    /**
     27pt / Receipt / Title 2
     - parameters:
        - property: $receipt-title2
     */
    class var ReceiptTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.EdcR, size: 25)!
        case .defaultDevice:
            return UIFont(name: AppFontName.EdcR, size: 27)!
        }
    }

    /**
     24pt / Receipt / Title 3
     - parameters:
        - property: $receipt-title3
     */
    class var ReceiptTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.EdcR, size: 22)!
        case .defaultDevice:
            return UIFont(name: AppFontName.EdcR, size: 24)!
        }
    }

    /**
     21pt / Receipt / Subtitle
     - parameters:
        - property: $receipt-subtitle
     */
    class var ReceiptSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.EdcR, size: 19)!
        case .defaultDevice:
            return UIFont(name: AppFontName.EdcR, size: 21)!
        }
    }

    /**
     18pt / Receipt / Body
     - parameters:
        - property: $receipt-body
     */
    class var ReceiptBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.EdcR, size: 16)!
        case .defaultDevice:
            return UIFont(name: AppFontName.EdcR, size: 18)!
        }
    }

    /**
     15pt / Receipt / Caption 1
     - parameters:
        - property: $receipt-caption1
     */
    class var ReceiptCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.EdcR, size: 14)!
        case .defaultDevice:
            return UIFont(name: AppFontName.EdcR, size: 15)!
        }
    }

    /**
     12pt / Receipt / Caption 2
     - parameters:
        - property: $receipt-caption2
     */
    class var ReceiptCaption2: UIFont {
        return UIFont(name: AppFontName.EdcR, size: 12)!
    }
    
    
    // MARK: Korean Typeface

    /**
     30pt / Korean / Title 1
     - parameters:
        - property: $korean-title1
     */

    class var KoreanTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneR, size: 28)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneR, size: 30)!
        }
    }

    /**
     27pt / Korean / Title 2
     - parameters:
        - property: $korean-title2
     */
    class var KoreanTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneR, size: 25)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneR, size: 27)!
        }
    }

    /**
     24pt / Korean / Title 3
     - parameters:
        - property: $korean-title3
     */
    class var KoreanTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneR, size: 22)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneR, size: 24)!
        }
    }

    /**
     21pt / Korean / Subtitle
     - parameters:
        - property: $korean-subtitle
     */
    class var KoreanSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneR, size: 19)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneR, size: 21)!
        }
    }

    /**
     18pt / Korean / Body
     - parameters:
        - property: $korean-body
     */
    class var KoreanBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneR, size: 16)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneR, size: 18)!
        }
    }

    /**
     16pt / Korean / ButtonText
     - parameters:
        - property: $korean-button-text
     */
    class var KoreanButtonText: UIFont {
        return UIFont(name: AppFontName.OneB, size: 16)!
    }

    /**
     12pt / Korean / SmallButtonText
     - parameters:
        - property: $korean-small-button-text
     */
    class var KoreanSmallButtonText: UIFont {
        return UIFont(name: AppFontName.OneB, size: 12)!
    }

    /**
     15pt / Korean / Caption 1
     - parameters:
        - property: $korean-caption1
     */
    class var KoreanCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneR, size: 14)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneR, size: 15)!
        }
    }

    /**
     12pt / Korean / Caption 2
     - parameters:
        - property: $korean-caption2
     */
    class var KoreanCaption2: UIFont {
        return UIFont(name: AppFontName.OneL, size: 12)!
    }
}

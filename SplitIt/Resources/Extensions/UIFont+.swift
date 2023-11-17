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
    
    // MARK: Number Typeface
    /**
     32pt / Num / Title 1
     - parameters:
        - property: $num-title1
     */
    class var NumTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 30, weight: .light)
        case .defaultDevice:
            return systemFont(ofSize: 32, weight: .light)
        }
    }

    /**
     29pt / Num / Title 2
     - parameters:
        - property: $num-title2
     */
    class var NumTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 27, weight: .light)
        case .defaultDevice:
            return systemFont(ofSize: 29, weight: .light)
        }
    }

    /**
     26pt / Num / Title 3
     - parameters:
        - property: $num-title3
     */
    class var NumTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 24, weight: .light)
        case .defaultDevice:
            return systemFont(ofSize: 26, weight: .light)
        }
    }

    /**
     23pt / Num / Subtitle
     - parameters:
        - property: $num-subtitle
     */
    class var NumSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 21, weight: .light)
        case .defaultDevice:
            return systemFont(ofSize: 23, weight: .light)
        }
    }

    /**
     20pt / Num / Body
     - parameters:
        - property: $num-body
     */
    class var NumBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 18, weight: .light)
        case .defaultDevice:
            return systemFont(ofSize: 20, weight: .light)
        }
    }

    /**
     18pt / Num / Caption 1
     - parameters:
        - property: $num-caption1
     */
    class var NumCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 16, weight: .light)
        case .defaultDevice:
            return systemFont(ofSize: 18, weight: .light)
        }
    }

    /**
     14pt / Num / Caption 2
     - parameters:
        - property: $num-caption2
     */
    class var NumCaption2: UIFont {
        return systemFont(ofSize: 14, weight: .ultraLight)
    }
    
    
    // MARK: Number Rounded Typeface
    
    func rounded() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else {
            return self
        }

        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    /**
     32pt / NumRounded / Title 1
     - parameters:
        - property: $num-rounded-title1
     */
    class var NumRoundedTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 30, weight: .light).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 32, weight: .light).rounded()
        }
    }

    /**
     29pt / NumRounded / Title 2
     - parameters:
        - property: $num-rounded-title2
     */
    class var NumRoundedTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 27, weight: .light).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 29, weight: .light).rounded()
        }
    }

    /**
     26pt / NumRounded / Title 3
     - parameters:
        - property: $num-rounded-title3
     */
    class var NumRoundedTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 24, weight: .light).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 26, weight: .light).rounded()
        }
    }

    /**
     23pt / NumRounded / Subtitle
     - parameters:
        - property: $num-rounded-subtitle
     */
    class var NumRoundedSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 21, weight: .light).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 23, weight: .light).rounded()
        }
    }

    /**
     20pt / NumRounded / Body
     - parameters:
        - property: $num-rounded-body
     */
    class var NumRoundedBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 18, weight: .light).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 20, weight: .light).rounded()
        }
    }

    /**
     18pt / NumRounded / Caption 1
     - parameters:
        - property: $num-rounded-caption1
     */
    class var NumRoundedCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 16, weight: .light).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 18, weight: .light).rounded()
        }
    }

    /**
     14pt / NumRounded / Caption 2
     - parameters:
        - property: $num-rounded-caption2
     */
    class var NumRoundedCaption2: UIFont {
        return systemFont(ofSize: 14, weight: .ultraLight).rounded()
    }
    
    
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
    
    /**
     8pt / Receipt / Footer 1
     - parameters:
        - property: $receipt-footer1
     */
    class var ReceiptFooter1: UIFont {
        return UIFont(name: AppFontName.EdcB, size: 8)!
    }
    
    /**
     8pt / Receipt / Footer 2
     - parameters:
        - property: $receipt-footer2
     */
    
    class var ReceiptFooter2: UIFont {
        return UIFont(name: AppFontName.EdcR, size: 8)!
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

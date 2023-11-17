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
     32pt / Num / Light / Title 1
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
     32pt / Num / SemiBold / Title 1
     - parameters:
     - property: $num-bold-title1
     */
    class var NumBoldTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 30, weight: .semibold)
        case .defaultDevice:
            return systemFont(ofSize: 32, weight: .semibold)
        }
    }
    
    /**
     32pt / Num / UltraLight / Title 1
     - parameters:
     - property: $num-light-title1
     */
    class var NumLightTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 30, weight: .ultraLight)
        case .defaultDevice:
            return systemFont(ofSize: 32, weight: .ultraLight)
        }
    }
    
    /**
     29pt / Num / Light / Title 2
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
     29pt / Num / SemiBold / Title 2
     - parameters:
     - property: $num-bold-title2
     */
    class var NumBoldTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 27, weight: .semibold)
        case .defaultDevice:
            return systemFont(ofSize: 29, weight: .semibold)
        }
    }
    
    /**
     29pt / Num / UltraLight / Title 2
     - parameters:
     - property: $num-light-title2
     */
    class var NumLightTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 27, weight: .ultraLight)
        case .defaultDevice:
            return systemFont(ofSize: 29, weight: .ultraLight)
        }
    }
    
    /**
     26pt / Num / Light / Title 3
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
     26pt / Num / SemiBold / Title 3
     - parameters:
     - property: $num-bold-title3
     */
    class var NumBoldTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 24, weight: .semibold)
        case .defaultDevice:
            return systemFont(ofSize: 26, weight: .semibold)
        }
    }
    
    /**
     26pt / Num / UltraLight / Title 3
     - parameters:
     - property: $num-light-title3
     */
    class var NumLightTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 24, weight: .ultraLight)
        case .defaultDevice:
            return systemFont(ofSize: 26, weight: .ultraLight)
        }
    }
    
    /**
     23pt / Num / Light / Subtitle
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
     23pt / Num / SemiBold / Subtitle
     - parameters:
     - property: $num-bold-subtitle
     */
    class var NumBoldSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 21, weight: .semibold)
        case .defaultDevice:
            return systemFont(ofSize: 23, weight: .semibold)
        }
    }
    
    /**
     23pt / Num / UltraLight / Subtitle
     - parameters:
     - property: $num-light-subtitle
     */
    class var NumLightSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 21, weight: .ultraLight)
        case .defaultDevice:
            return systemFont(ofSize: 23, weight: .ultraLight)
        }
    }
    
    /**
     20pt / Num / Light / Body
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
     20pt / Num / SemiBold / Body
     - parameters:
     - property: $num-bold-body
     */
    class var NumBoldBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 18, weight: .semibold)
        case .defaultDevice:
            return systemFont(ofSize: 20, weight: .semibold)
        }
    }
    
    /**
     20pt / Num / UltraLight / Body
     - parameters:
     - property: $num-light-body
     */
    class var NumLightBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 18, weight: .ultraLight)
        case .defaultDevice:
            return systemFont(ofSize: 20, weight: .ultraLight)
        }
    }
    
    /**
     18pt / Num / Light / Caption 1
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
     18pt / Num / SemiBold / Caption 1
     - parameters:
     - property: $num-bold-caption1
     */
    class var NumBoldCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 16, weight: .semibold)
        case .defaultDevice:
            return systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    /**
     18pt / Num / UltraLight / Caption 1
     - parameters:
     - property: $num-light-caption1
     */
    class var NumLightCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 16, weight: .ultraLight)
        case .defaultDevice:
            return systemFont(ofSize: 18, weight: .ultraLight)
        }
    }
    
    /**
     14pt / Num / UltraLight / Caption 2
     - parameters:
     - property: $num-caption2
     */
    class var NumCaption2: UIFont {
        return systemFont(ofSize: 14, weight: .ultraLight)
    }
    
    /**
     14pt / Num / SemiBold / Caption 2
     - parameters:
     - property: $num-bold-caption2
     */
    class var NumBoldCaption2: UIFont {
        return systemFont(ofSize: 14, weight: .semibold)
    }
    
    
    // MARK: Number Rounded Typeface
    
    func rounded() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    /**
     32pt / NumRounded / Light / Title 1
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
     32pt / NumRounded / SemiBold / Title 1
     - parameters:
     - property: $num-rounded-bold-title1
     */
    class var NumRoundedBoldTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 30, weight: .semibold).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 32, weight: .semibold).rounded()
        }
    }
    
    /**
     32pt / NumRounded / UltraLight / Title 1
     - parameters:
     - property: $num-rounded-light-title1
     */
    class var NumRoundedLightTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 30, weight: .ultraLight).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 32, weight: .ultraLight).rounded()
        }
    }
    
    /**
     29pt / NumRounded / Light / Title 2
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
     29pt / NumRounded / SemiBold / Title 2
     - parameters:
     - property: $num-rounded-bold-title2
     */
    class var NumRoundedBoldTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 27, weight: .semibold).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 29, weight: .semibold).rounded()
        }
    }
    
    /**
     29pt / NumRounded / UltraLight / Title 2
     - parameters:
     - property: $num-rounded-light-title2
     */
    class var NumRoundedLightTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 27, weight: .ultraLight).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 29, weight: .ultraLight).rounded()
        }
    }
    
    /**
     26pt / NumRounded / Light / Title 3
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
     26pt / NumRounded / SemiBold / Title 3
     - parameters:
     - property: $num-rounded-bold-title3
     */
    class var NumRoundedBoldTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 24, weight: .semibold).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 26, weight: .semibold).rounded()
        }
    }
    
    /**
     26pt / NumRounded / UltraLight / Title 3
     - parameters:
     - property: $num-rounded-light-title3
     */
    class var NumRoundedLightTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 24, weight: .ultraLight).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 26, weight: .ultraLight).rounded()
        }
    }
    
    /**
     23pt / NumRounded / Light / Subtitle
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
     23pt / NumRounded / SemiBold / Subtitle
     - parameters:
     - property: $num-rounded-bold-subtitle
     */
    class var NumRoundedBoldSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 21, weight: .semibold).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 23, weight: .semibold).rounded()
        }
    }
    
    /**
     23pt / NumRounded / UltraLight / Subtitle
     - parameters:
     - property: $num-rounded-light-subtitle
     */
    class var NumRoundedLightSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 21, weight: .ultraLight).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 23, weight: .ultraLight).rounded()
        }
    }
    
    /**
     20pt / NumRounded / Light / Body
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
     20pt / NumRounded / SemiBold / Body
     - parameters:
     - property: $num-rounded-bold-body
     */
    class var NumRoundedBoldBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 18, weight: .semibold).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 20, weight: .semibold).rounded()
        }
    }
    
    /**
     20pt / NumRounded / UltraLight / Body
     - parameters:
     - property: $num-rounded-light-body
     */
    class var NumRoundedLightBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 18, weight: .ultraLight).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 20, weight: .ultraLight).rounded()
        }
    }
    
    /**
     18pt / NumRounded / Light / Caption 1
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
     18pt / NumRounded / SemiBold / Caption 1
     - parameters:
     - property: $num-rounded-bold-caption1
     */
    class var NumRoundedBoldCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 16, weight: .semibold).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 18, weight: .semibold).rounded()
        }
    }
    
    /**
     18pt / NumRounded / UltraLight / Caption 1
     - parameters:
     - property: $num-rounded-light-caption1
     */
    class var NumRoundedLightCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return systemFont(ofSize: 16, weight: .ultraLight).rounded()
        case .defaultDevice:
            return systemFont(ofSize: 18, weight: .ultraLight).rounded()
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
    
    /**
     14pt / NumRounded / SemiBold / Caption 2
     - parameters:
     - property: $num-rounded-bold-caption2
     */
    class var NumRoundedBoldCaption2: UIFont {
        return systemFont(ofSize: 14, weight: .semibold).rounded()
    }
    
    
    // MARK: Receipt Typeface
    
    /**
     30pt / Receipt / Regular / Title 1
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
     27pt / Receipt / Regular / Title 2
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
     24pt / Receipt / Regular / Title 3
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
     21pt / Receipt / Regular / Subtitle
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
     18pt / Receipt / Regular / Body
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
     15pt / Receipt / Regular / Caption 1
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
     12pt / Receipt / Regular / Caption 2
     - parameters:
     - property: $receipt-caption2
     */
    class var ReceiptCaption2: UIFont {
        return UIFont(name: AppFontName.EdcR, size: 12)!
    }
    
    /**
     8pt / Receipt / Bold / Footer 1
     - parameters:
     - property: $receipt-footer1
     */
    class var ReceiptFooter1: UIFont {
        return UIFont(name: AppFontName.EdcB, size: 8)!
    }
    
    /**
     8pt / Receipt / Regular / Footer 2
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
     30pt / Korean / Bold / Title 1
     - parameters:
     - property: $korean-bold-title1
     */
    class var KoreanBoldTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneB, size: 28)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneB, size: 30)!
        }
    }
    
    /**
     30pt / Korean / Light / Title 1
     - parameters:
     - property: $korean-light-title1
     */
    class var KoreanLightTitle1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneL, size: 28)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneL, size: 30)!
        }
    }
    
    /**
     27pt / Korean / Regular / Title 2
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
     27pt / Korean / Bold / Title 2
     - parameters:
     - property: $korean-bold-title2
     */
    class var KoreanBoldTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneB, size: 25)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneB, size: 27)!
        }
    }
    
    /**
     27pt / Korean / Light / Title 2
     - parameters:
     - property: $korean-light-title2
     */
    class var KoreanLightTitle2: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneL, size: 25)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneL, size: 27)!
        }
    }
    
    /**
     24pt / Korean / Regular / Title 3
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
     24pt / Korean / Bold / Title 3
     - parameters:
     - property: $korean-bold-title3
     */
    class var KoreanBoldTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneB, size: 22)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneB, size: 24)!
        }
    }
    
    /**
     24pt / Korean / Light / Title 3
     - parameters:
     - property: $korean-light-title3
     */
    class var KoreanLightTitle3: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneL, size: 22)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneL, size: 24)!
        }
    }
    
    /**
     21pt / Korean / Regular / Subtitle
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
     21pt / Korean / Bold / Subtitle
     - parameters:
     - property: $korean-bold-subtitle
     */
    class var KoreanBoldSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneB, size: 19)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneB, size: 21)!
        }
    }
    
    /**
     21pt / Korean / Light / Subtitle
     - parameters:
     - property: $korean-light-subtitle
     */
    class var KoreanLightSubtitle: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneL, size: 19)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneL, size: 21)!
        }
    }
    
    /**
     18pt / Korean / Regular / Body
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
     18pt / Korean / Bold / Body
     - parameters:
     - property: $korean-bold-body
     */
    class var KoreanBoldBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneB, size: 16)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneB, size: 18)!
        }
    }
    
    /**
     18pt / Korean / Light / Body
     - parameters:
     - property: $korean-light-body
     */
    class var KoreanLightBody: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneL, size: 16)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneL, size: 18)!
        }
    }
    
    /**
     16pt / Korean / Bold / ButtonText
     - parameters:
     - property: $korean-button-text
     */
    class var KoreanButtonText: UIFont {
        return UIFont(name: AppFontName.OneB, size: 16)!
    }
    
    /**
     12pt / Korean / Bold / SmallButtonText
     - parameters:
     - property: $korean-small-button-text
     */
    class var KoreanSmallButtonText: UIFont {
        return UIFont(name: AppFontName.OneB, size: 12)!
    }
    
    /**
     15pt / Korean / Regular / Caption 1
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
     15pt / Korean / Bold / Caption 1
     - parameters:
     - property: $korean-bold-caption1
     */
    class var KoreanBoldCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneB, size: 14)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneB, size: 15)!
        }
    }
    
    /**
     15pt / Korean / Light / Caption 1
     - parameters:
     - property: $korean-Light-caption1
     */
    class var KoreanLightCaption1: UIFont {
        switch UIDevice().screenType {
        case .iPhoneSE:
            return UIFont(name: AppFontName.OneL, size: 14)!
        case .defaultDevice:
            return UIFont(name: AppFontName.OneL, size: 15)!
        }
    }
    
    /**
     12pt / Korean / Light / Caption 2
     - parameters:
     - property: $korean-caption2
     */
    class var KoreanCaption2: UIFont {
        return UIFont(name: AppFontName.OneL, size: 12)!
    }
    
    /**
     12pt / Korean / Bold / Caption 2
     - parameters:
     - property: $korean-bold-caption2
     */
    class var KoreanBoldCaption2: UIFont {
        return UIFont(name: AppFontName.OneB, size: 12)!
    }
}

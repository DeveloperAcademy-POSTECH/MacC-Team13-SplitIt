//
//  UIFont+.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/10/18.
//

import UIKit

extension UIFont {
    
    // MARK: Korean Typeface

    /**
     30pt / Korean / Title 1
     - parameters:
        - property: $korean-title1
     */
    class var KoreanTitle1: UIFont {
        return UIFont(name: "ONEMobileRegular", size: 30)!
    }
    
    /**
     27pt / Korean / Title 2
     - parameters:
        - property: $korean-title2
     */
    class var KoreanTitle2: UIFont {
        return UIFont(name: "ONEMobileRegular", size: 27)!
    }
    
    /**
     24pt / Korean / Title 3
     - parameters:
        - property: $korean-title3
     */
    class var KoreanTitle3: UIFont {
        return UIFont(name: "ONEMobileRegular", size: 24)!
    }
    
    /**
     21pt / Korean / Subtitle
     - parameters:
        - property: $korean-subtitle
     */
    class var KoreanSubtitle: UIFont {
        return UIFont(name: "ONEMobileRegular", size: 21)!
    }
    
    /**
     18pt / Korean / Body
     - parameters:
        - property: $korean-body
     */
    class var KoreanBody: UIFont {
        return UIFont(name: "ONEMobileRegular", size: 18)!
    }
    
    /**
     16pt / Korean / ButtonText
     - parameters:
        - property: $korean-button-text
     */
    class var KoreanButtonText: UIFont {
        return UIFont(name: "ONEMobileBold", size: 16)!
    }
    
    /**
     15pt / Korean / Caption 1
     - parameters:
        - property: $korean-caption1
     */
    class var KoreanCaption1: UIFont {
        return UIFont(name: "ONEMobileRegular", size: 15)!
    }
    
    /**
     12pt / Korean / Caption 2
     - parameters:
        - property: $korean-caption2
     */
    class var KoreanCaption2: UIFont {
        return UIFont(name: "ONEMobileLight", size: 12)!
    }
}

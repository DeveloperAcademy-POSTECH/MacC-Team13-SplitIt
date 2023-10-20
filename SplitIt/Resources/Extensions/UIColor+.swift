//
//  UIColor+.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import UIKit

//MARK: 토마토 Task

extension UIColor {

    // MARK: Text Colors

    /**
     기본 글씨의 색상입니다.
     - parameters:
        - property: $text-primary
     */
    class var TextPrimary: UIColor { return UIColor.AppColorGrayscale900 }

    /**
     보조 글씨의 색상입니다.
     - parameters:
        - property: $text-secondary
     */
    class var TextSecondary: UIColor { return UIColor.AppColorGrayscale600 }

    /**
     비활성화 된 글씨의 색상입니다.
     - parameters:
        - property: $text-deactivate
     */
    class var TextDeactivate: UIColor { return UIColor.AppColorGrayscale200 }

    /**
     반전 된 글씨의 색상입니다.
     - parameters:
        - property: $text-invert
     */
    class var TextInvert: UIColor { return UIColor.AppColorGrayscale50 }


    // MARK: Surface Colors

    /**
     기본 면의 색상입니다.
     - parameters:
        - property: $surface-primary
     */
    class var SurfacePrimary: UIColor { return UIColor.AppColorBrandCalmshell }

    /**
     주 보조 면의 색상입니다.
     - parameters:
        - property: $surface-secondary
     */
    class var SurfaceSecondary: UIColor { return UIColor.AppColorGrayscale800 }

    /**
     부 보조 면의 색상입니다.
     - parameters:
        - property: $surface-tertiary
     */
    class var SurfaceTertiary: UIColor { return UIColor.AppColorGrayscale600 }

    /**
     비활성화 된 면의 색상입니다.
     - parameters:
        - property: $surface-deactivate
     */
    class var SurfaceDeactivate: UIColor { return UIColor.AppColorGrayscale50K }

    /**
     선택 된 면의 색상입니다.
     - parameters:
        - property: $surface-selected
     */
    class var SurfaceSelected: UIColor { return UIColor.AppColorGrayscale25K }

    /**
     반전 된 면의 색상입니다.
     - parameters:
        - property: $surface-invert
     */
    class var SurfaceInvert: UIColor { return UIColor.AppColorGrayscale900 }
    
    /**
     브랜드 색상 'Calmshell'이 적용되는 면의 색상입니다.
     - parameters:
        - property: $surface-brand-calmshell
     */
    class var SurfaceBrandCalmshell: UIColor { return UIColor.AppColorBrandCalmshell }
    
    
     /** 브랜드 색상 'Calmshell'이 적용되는 Button의 Pressed 상태를 위한 색상입니다.
     - parameters:
        - property: $surface-brand-calmshell
     */
    class var SurfaceBrandCalmshellPressed: UIColor { return UIColor.AppColorBrandCalmshellPressed }
    
    /**
     브랜드 색상 'Watermelon'이 적용되는 면의 색상입니다.
     - parameters:
        - property: $surface-brand-watermelon
     */
    class var SurfaceBrandWatermelon: UIColor { return UIColor.AppColorBrandWatermelon }
    
    /**
     브랜드 색상 'Watermelon'이 적용되는 Button의 Pressed 상태를 위한 색상입니다.
     - parameters:
        - property: $surface-brand-watermelon
     */
    class var SurfaceBrandWatermelonPressed: UIColor { return UIColor.AppColorBrandWatermelonPressed }
    
    /**
     브랜드 색상 'Cherry'가 적용되는 면의 색상입니다.
     - parameters:
        - property: $surface-brand-cherry
     */
    class var SurfaceBrandCherry: UIColor { return UIColor.AppColorBrandCherry }
    
    /**
     브랜드 색상 'Cherry'가 적용되는 Button의 Pressed 상태를 위한 색상입니다.
     - parameters:
        - property: $surface-brand-cherry
     */
    class var SurfaceBrandCherryPressed: UIColor { return UIColor.AppColorBrandCherryPressed }
    
    /**
     브랜드 색상 'Pear'가 적용되는 면의 색상입니다.
     - parameters:
        - property: $surface-brand-pear
     */
    class var SurfaceBrandPear: UIColor { return UIColor.AppColorBrandPear }
    
    /**
     브랜드 색상 'Pear'가 적용되는 Button의 Pressed 상태를 위한 색상입니다.
     - parameters:
        - property: $surface-brand-pear
     */
    class var SurfaceBrandPearPressed: UIColor { return UIColor.AppColorBrandPearPressed }
    
    /**
     브랜드 색상 'Mushroom'이 적용되는 면의 색상입니다.
     - parameters:
        - property: $surface-brand-mushroom
     */
    class var SurfaceBrandMushroom: UIColor { return UIColor.AppColorBrandMushroom }
    
    /**
     브랜드 색상 'Mushroom'이 적용되는 Button의 Pressed 상태를 위한 색상입니다.
     - parameters:
        - property: $surface-brand-mushroom
     */
    class var SurfaceBrandMushroomPressed: UIColor { return UIColor.AppColorBrandMushroomPressed }
    
    /**
     브랜드 색상 'Radish'가 적용되는 면의 색상입니다.
     - parameters:
        - property: $surface-brand-radish
     */
    class var SurfaceBrandRadish: UIColor { return UIColor.AppColorBrandRadish }
    
    /**
     브랜드 색상 'Radish'가 적용되는 Button의 Pressed 상태를 위한 색상입니다.
     - parameters:
        - property: $surface-brand-radish
     */
    class var SurfaceBrandRadishPressed: UIColor { return UIColor.AppColorBrandRadishPressed }

    /**
     흰색의 면의 색상입니다.
     - parameters:
        - property: $surface-white
     */
    class var SurfaceWhite: UIColor { return UIColor.AppColorGrayscaleBase }

    /**
     주의 및 경고의 면의 색상입니다.
     - parameters:
        - property: $surface-warn
     */
    class var SurfaceWarn: UIColor { return UIColor.AppColorStatusWarnRed }


    // MARK: Border Colors

    /**
     기본적인 선의 색상입니다.
     - parameters:
      - property:$border-primary
     */
    class var BorderPrimary: UIColor { return UIColor.AppColorGrayscale900 }

    /**
     보조적인 선의 색상입니다.
     - parameters:
      - property:$border-secondary
     */
    class var BorderSecondary: UIColor { return UIColor.AppColorGrayscale600 }

    /**
     부보조적인 선의 색상입니다.
     - parameters:
      - property:$border-tertiary
     */
    class var BorderTertiary: UIColor { return UIColor.AppColorGrayscale400 }

    /**
     비활성화 된 선의 색상입니다.
     - parameters:
      - property:$border-deactivate
     */
    class var BorderDeactivate: UIColor { return UIColor.AppColorGrayscale200 }

    /**
     반전 된 선의 색상입니다.
     - parameters:
      - property:$border-invert
     */
    class var BorderInvert: UIColor { return UIColor.AppColorGrayscale50 }


    // MARK: Brand Colors
    class var AppColorBrandCalmshell: UIColor { return UIColor(hex: 0xF8F7F4) }
    class var AppColorBrandWatermelon: UIColor { return UIColor(hex: 0x4DB8A9) }
    class var AppColorBrandCherry: UIColor { return UIColor(hex: 0xFF9EAB) }
    class var AppColorBrandPear: UIColor { return UIColor(hex: 0xDEF358) }
    class var AppColorBrandMushroom: UIColor { return UIColor(hex: 0xF1D367) }
    class var AppColorBrandRadish: UIColor { return UIColor(hex: 0xFFCBB7) }
    
    // MARK: Pressed Colors
    class var AppColorBrandCalmshellPressed: UIColor { return UIColor(hex: 0xEEEDE8) }
    class var AppColorBrandWatermelonPressed: UIColor { return UIColor(hex: 0x3C9293) }
    class var AppColorBrandCherryPressed: UIColor { return UIColor(hex: 0xEE778D) }
    class var AppColorBrandPearPressed: UIColor { return UIColor(hex: 0xAFD73D) }
    class var AppColorBrandMushroomPressed: UIColor { return UIColor(hex: 0xF3C245) }
    class var AppColorBrandRadishPressed: UIColor { return UIColor(hex: 0xFFB598) }
    class var AppColorWarnRedPressed: UIColor { return UIColor(hex: 0xD84961) }

    // MARK: Grayscale Colors
    class var AppColorGrayscaleBase: UIColor { return UIColor(hex: 0xFFFFFF) }
    class var AppColorGrayscale25K: UIColor { return UIColor(hex: 0xE5E4E0) }
    class var AppColorGrayscale50: UIColor { return UIColor(hex: 0xF1F1F1) }
    class var AppColorGrayscale50K: UIColor { return UIColor(hex: 0xEEEDE8) }
    class var AppColorGrayscale200: UIColor { return UIColor(hex: 0xD3D3D3) }
    class var AppColorGrayscale400: UIColor { return UIColor(hex: 0xAFAFAF) }
    class var AppColorGrayscale600: UIColor { return UIColor(hex: 0x7C7C7C) }
    class var AppColorGrayscale700: UIColor { return UIColor(hex: 0x4D4D4D) }
    class var AppColorGrayscale800: UIColor { return UIColor(hex: 0x343434) }
    class var AppColorGrayscale900: UIColor { return UIColor(hex: 0x202020) }
    class var AppColorGrayscale1000: UIColor { return UIColor(hex: 0x000000) }

    // MARK: Status Colors
    class var AppColorStatusGreen: UIColor { return UIColor(hex: 0x3ACE48) }
    class var AppColorStatusError: UIColor { return UIColor(hex: 0xFF3030) }
    class var AppColorStatusYellow: UIColor { return UIColor(hex: 0xFFBA09) }
    class var AppColorStatusWarnRed: UIColor { return UIColor(hex: 0xFF6363) }
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

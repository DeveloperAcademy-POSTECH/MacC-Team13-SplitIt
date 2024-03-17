//
//  SPButtonAttributes.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit

enum SPButtonStyle {
    case primaryCalmshell
    case primaryWatermelon
    case primaryCherry
    case primaryPear
    case primaryMushroom
    case primaryRadish
    case surfaceWhite
    case surfaceSecondary
    case warningRed
    
    var pressedColor: UIColor {
        switch self {
        case .primaryCalmshell: return .SurfaceBrandCalmshellPressed
        case .primaryWatermelon: return .SurfaceBrandWatermelonPressed
        case .primaryCherry: return .SurfaceBrandCherryPressed
        case .primaryPear: return .SurfaceBrandPearPressed
        case .primaryMushroom: return .SurfaceBrandMushroomPressed
        case .primaryRadish: return .SurfaceBrandRadishPressed
        case .surfaceWhite: return .SurfaceSelected
        case .surfaceSecondary: return .SurfaceSecondaryPressed
        case .warningRed: return .SurfaceWarnRedPressed
        }
    }
    
    var unpressedColor: UIColor {
        switch self {
        case .primaryCalmshell: return .SurfaceBrandCalmshell
        case .primaryWatermelon: return .SurfaceBrandWatermelon
        case .primaryCherry: return .SurfaceBrandCherry
        case .primaryPear: return .SurfaceBrandPear
        case .primaryMushroom: return .SurfaceBrandMushroom
        case .primaryRadish: return .SurfaceBrandRadish
        case .surfaceWhite: return .SurfaceWhite
        case .surfaceSecondary: return .SurfaceSecondary
        case .warningRed: return .SurfaceWarnRed
        }
    }
}

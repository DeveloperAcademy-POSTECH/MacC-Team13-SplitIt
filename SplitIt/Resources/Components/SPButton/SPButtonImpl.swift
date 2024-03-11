//
//  SPButtonImpl.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit
import RxCocoa
import RxSwift

class SPButtonImpl: UIButton {
    private var style: SPButtonStyle?
    
    lazy var pressedColor: UIColor = {
        switch self.style {
        case .primaryCalmshell: return .SurfaceBrandCalmshellPressed
        case .primaryWatermelon: return .SurfaceBrandWatermelonPressed
        case .primaryCherry: return .SurfaceBrandCherryPressed
        case .primaryPear: return .SurfaceBrandPearPressed
        case .primaryMushroom: return .SurfaceBrandMushroomPressed
        case .primaryRadish: return .SurfaceBrandRadishPressed
        case .surfaceWhite: return .SurfaceSelected
        case .surfaceSecondary: return .SurfaceSecondaryPressed
        case .warningRed: return .SurfaceWarnRedPressed
        case .none: return .systemBackground
        }
    }()
    
    lazy var unpressedColor: UIColor = {
        switch self.style {
        case .primaryCalmshell: return .SurfaceBrandCalmshell
        case .primaryWatermelon: return .SurfaceBrandWatermelon
        case .primaryCherry: return .SurfaceBrandCherry
        case .primaryPear: return .SurfaceBrandPear
        case .primaryMushroom: return .SurfaceBrandMushroom
        case .primaryRadish: return .SurfaceBrandRadish
        case .surfaceWhite: return .SurfaceWhite
        case .surfaceSecondary: return .SurfaceSecondary
        case .warningRed: return .SurfaceWarnRed
        case .none: return .systemBackground
        }
    }()
    
    func applyStyle(style: SPButtonStyle) {
        self.style = style
        configureCommonProperties()
    }
}

extension SPButtonImpl {
    func updateVerticalPosition(by y: CGFloat) {
        self.frame = CGRect(origin: CGPoint(x: self.frame.minX,
                                            y: self.frame.minY + y),
                            size: self.frame.size)
    }
}

extension SPButtonImpl {
    // 공통 프로퍼티
    private func configureCommonProperties() {
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
    }
   
    // 활성 상태 프로퍼티
    func configureActiveProperties() {
        self.setTitleColor(.TextPrimary, for: .normal)
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
        self.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    // 활성 상태 프로퍼티 텍스트 색 반전
    func configureActivePropertiesInvert() {
        self.setTitleColor(.TextInvert, for: .normal)
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
        self.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    // 비활성 상태 프로퍼티
    func configureDeactiveProperties() {
        self.setTitleColor(.TextDeactivate, for: .normal)
        self.layer.borderColor = UIColor.BorderDeactivate.cgColor
        self.layer.shadowColor = UIColor.BorderDeactivate.cgColor
    }
}

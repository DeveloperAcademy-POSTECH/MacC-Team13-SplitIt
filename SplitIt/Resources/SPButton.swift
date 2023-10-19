//
//  SPButton.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/10/18.
//

import UIKit
import SnapKit

//MARK: 토마토 Task

extension SPButton {
    enum Style {

        // MARK: Active Button Styles
        case primaryCalmshell
        case primaryWatermelon
        case primaryCherry
        case primaryPear
        case primaryMushroom
        case primaryRadish
        case secondary
        case warningRed
        
        // MARK: Pressed Button Styles
        case primaryCalmshellPressed
        case primaryWatermelonPressed
        case primaryCherryPressed
        case primaryPearPressed
        case primaryMushroomPressed
        case primaryRadishPressed
        case secondaryPressed
        case warningRedPressed
        
        // MARK: Square Button
        case squarePrimaryCalmshell
        case squareWarningRed
        
        // MARK: Deactive Button Style
        case deactivate
        case squareDeactivate
    }
}

final class SPButton: UIButton {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Style Configuration
    func applyStyle(_ style: Style) {
        configureCommonProperties()
        
        switch style {
        // 활성 버튼, Unpressed 상태
        case .primaryCalmshell:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .primaryWatermelon:
            self.backgroundColor = .SurfaceBrandWatermelon
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .primaryCherry:
            self.backgroundColor = .SurfaceBrandCherry
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .primaryPear:
            self.backgroundColor = .SurfaceBrandPear
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .primaryMushroom:
            self.backgroundColor = .SurfaceBrandMushroom
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .primaryRadish:
            self.backgroundColor = .SurfaceBrandRadish
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .secondary:
            self.backgroundColor = .SurfaceDeactivate
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .warningRed:
            self.backgroundColor = .SurfaceWarn
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        // 비활성 버튼, Pressed 상태
        case .primaryCalmshellPressed:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .primaryWatermelonPressed:
            self.backgroundColor = .SurfaceBrandWatermelon
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryCherryPressed:
            self.backgroundColor = .SurfaceBrandCherry
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryPearPressed:
            self.backgroundColor = .SurfaceBrandPear
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryMushroomPressed:
            self.backgroundColor = .SurfaceBrandMushroom
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .primaryRadishPressed:
            self.backgroundColor = .SurfaceBrandRadish
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .secondaryPressed:
            self.backgroundColor = .SurfaceDeactivate
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .warningRedPressed:
            self.backgroundColor = .SurfaceWarn
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()
            
        // 사각 버튼
        case .squarePrimaryCalmshell:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .squareWarningRed:
            self.backgroundColor = .SurfaceWarn
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        // 비활성 버튼
        case .deactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureDeactiveProperties()
            self.configurePressedProperties()
            
        case . squareDeactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureDeactiveProperties()
            self.configurePressedProperties()
        }
    }
    
    // 공통 프로퍼티
    private func configureCommonProperties() {
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
    }
    
    // 둥근 버튼 프로퍼티
    private func configureCommonPropertiesForNormal() {
        self.layer.cornerRadius = 24
    }
    
    // 사각 버튼 프로퍼티
    private func configureCommonPropertiesForSquare() {
        self.layer.cornerRadius = 8
    }
    
    // 활성 상태 프로퍼티
    private func configureActiveProperties() {
        self.setTitleColor(.TextPrimary, for: .normal)
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
        self.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    // 비활성 상태 프로퍼티
    private func configureDeactiveProperties() {
        self.isEnabled = false
        self.setTitleColor(.TextDeactivate, for: .normal)
        self.layer.borderColor = UIColor.BorderDeactivate.cgColor
        self.layer.shadowColor = UIColor.BorderDeactivate.cgColor
    }
    
    // 사용자가 탭하기 전 프로퍼티
    private func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    
    // 사용자가 탭한 뒤 프로퍼티
    private func configurePressedProperties() {
        self.isEnabled = false
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

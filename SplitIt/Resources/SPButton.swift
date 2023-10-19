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
        
        // MARK: Pressed Button Styles
        case primaryCalmshellPressed
        case primaryWatermelonPressed
        case primaryCherryPressed
        case primaryPearPressed
        case primaryMushroomPressed
        case primaryRadishPressed
        case secondaryPressed
        
        // MARK: Deactive Button Style
        case deactivate
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
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .primaryWatermelon:
            self.backgroundColor = .SurfaceBrandWatermelon
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .primaryCherry:
            self.backgroundColor = .SurfaceBrandCherry
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .primaryPear:
            self.backgroundColor = .SurfaceBrandPear
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .primaryMushroom:
            self.backgroundColor = .SurfaceBrandMushroom
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .primaryRadish:
            self.backgroundColor = .SurfaceBrandRadish
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .secondary:
            self.backgroundColor = .SurfaceDeactivate
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        // 비활성 버튼, Pressed 상태
        case .primaryCalmshellPressed:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .primaryWatermelonPressed:
            self.backgroundColor = .SurfaceBrandWatermelon
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryCherryPressed:
            self.backgroundColor = .SurfaceBrandCherry
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryPearPressed:
            self.backgroundColor = .SurfaceBrandPear
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryMushroomPressed:
            self.backgroundColor = .SurfaceBrandMushroom
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .primaryRadishPressed:
            self.backgroundColor = .SurfaceBrandRadish
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .secondaryPressed:
            self.backgroundColor = .SurfaceDeactivate
            self.configureActiveProperties()
            self.configurePressedProperties()
            
        // 비활성 버튼
        case .deactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureDeactiveProperties()
            self.configurePressedProperties()
        }
    }
    
    private func configureCommonProperties() {
        self.setTitle("버튼", for: .normal)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
    }
    
    private func configureActiveProperties() {
        self.setTitleColor(.TextPrimary, for: .normal)
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
        self.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    private func configureDeactiveProperties() {
        self.isEnabled = false
        self.setTitleColor(.TextDeactivate, for: .normal)
        self.layer.borderColor = UIColor.BorderDeactivate.cgColor
        self.layer.shadowColor = UIColor.BorderDeactivate.cgColor
    }
    
    private func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    
    private func configurePressedProperties() {
        self.isEnabled = false
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

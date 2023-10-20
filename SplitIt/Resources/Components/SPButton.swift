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

        // MARK: Active Normal Button Styles
        case primaryCalmshell
        case primaryWatermelon
        case primaryCherry
        case primaryPear
        case primaryMushroom
        case primaryRadish
        case warningRed
        
        // MARK: Pressed Normal Button Styles
        case primaryCalmshellPressed
        case primaryWatermelonPressed
        case primaryCherryPressed
        case primaryPearPressed
        case primaryMushroomPressed
        case primaryRadishPressed
        case warningRedPressed
        
        // MARK: Active Square Button Styles
        case squarePrimaryCalmshell
        case squarePrimaryWatermelon
        case squareWarningRed
        
        // MARK: Pressed Square Button Styles
        case squarePrimaryCalmshellPressed
        case squarePrimaryWatermelonPressed
        case squareWarningRedPressed
        
        // MARK: Active Half Button Styles
        case halfSmartSplit
        case halfEqualSplit
        case halfShare
        case halfExit
        
        // MARK: Pressed Half Button Styles
        case halfSmartSplitPressed
        case halfEqualSplitPressed
        case halfSharePressed
        case halfExitPressed
        
        // MARK: Deactive Button Style
        case deactivate
        case squareDeactivate
        case halfSmartSplitDeactivate
        case halfEqualSplitDeactivate
        case halfShareDeactivate
        case halfExitDeactivate
    }
}

final class SPButton: UIButton {
    let currencyIcon = UIImageView()
    let currencyLabel = UILabel()

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
        setCurrencyIcon(style: style)
        setCurrencyLabel(style: style)
        
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
            
        case .warningRed:
            self.backgroundColor = .SurfaceWarnRed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        // 비활성 버튼, Pressed 상태
        case .primaryCalmshellPressed:
            self.backgroundColor = .SurfaceBrandCalmshellPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .primaryWatermelonPressed:
            self.backgroundColor = .SurfaceBrandWatermelonPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryCherryPressed:
            self.backgroundColor = .SurfaceBrandCherryPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryPearPressed:
            self.backgroundColor = .SurfaceBrandPearPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .primaryMushroomPressed:
            self.backgroundColor = .SurfaceBrandMushroomPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .primaryRadishPressed:
            self.backgroundColor = .SurfaceBrandRadishPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()

        case .warningRedPressed:
            self.backgroundColor = .SurfaceWarnRedPressed
            self.configureCommonPropertiesForNormal()
            self.configureActiveProperties()
            self.configurePressedProperties()
            
        // 활성 사각 버튼
        case .squarePrimaryCalmshell:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configureUnpressedPropertiesForSquare()
            
        case .squarePrimaryWatermelon:
            self.backgroundColor = .SurfaceBrandWatermelon
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configureUnpressedPropertiesForSquare()
            
        case .squareWarningRed:
            self.backgroundColor = .SurfaceWarnRed
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configureUnpressedPropertiesForSquare()
            
        // 비활성, 사각 버튼 Pressed 상태
        case .squarePrimaryCalmshellPressed:
            self.backgroundColor = .SurfaceBrandCalmshellPressed
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configurePressedPropertiesForSquare()
            
        case .squarePrimaryWatermelonPressed:
            self.backgroundColor = .SurfaceBrandWatermelonPressed
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configurePressedPropertiesForSquare()
            
        case .squareWarningRedPressed:
            self.backgroundColor = .SurfaceWarnRedPressed
            self.configureCommonPropertiesForSquare()
            self.configureActiveProperties()
            self.configurePressedPropertiesForSquare()
            
        // 활성 하프 버튼
        case .halfSmartSplit:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .halfEqualSplit:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
        
        case .halfShare:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        case .halfExit:
            self.backgroundColor = .SurfaceSecondary
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configureUnpressedProperties()
            
        // 비활성, 하프 버튼 Pressed 상태
        case .halfSmartSplitPressed:
            self.backgroundColor = .SurfaceBrandCalmshellPressed
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configurePressedProperties()
            
        case .halfEqualSplitPressed:
            self.backgroundColor = .SurfaceBrandCalmshellPressed
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configurePressedProperties()
        
        case .halfSharePressed:
            self.backgroundColor = .SurfaceBrandCalmshellPressed
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configurePressedProperties()
            
        case .halfExitPressed:
            self.backgroundColor = .SurfaceSecondary
            self.configureCommonPropertiesForHalf()
            self.configureActiveProperties()
            self.configurePressedProperties()
            
        // 비활성 버튼
        case .deactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForNormal()
            self.configureDeactiveProperties()
            self.configurePressedProperties()
            
        case .squareDeactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForSquare()
            self.configureDeactiveProperties()
            self.configurePressedPropertiesForSquare()
            
        case .halfSmartSplitDeactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForHalf()
            self.configureDeactiveProperties()
            self.configurePressedProperties()
            
        case .halfEqualSplitDeactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForHalf()
            self.configureDeactiveProperties()
            self.configurePressedProperties()
        
        case .halfShareDeactivate:
            self.backgroundColor = .SurfaceBrandCalmshell
            self.configureCommonPropertiesForHalf()
            self.configureDeactiveProperties()
            self.configurePressedProperties()
            
        case .halfExitDeactivate:
            self.backgroundColor = .SurfaceSecondary
            self.configureCommonPropertiesForHalf()
            self.configureDeactiveProperties()
            self.configurePressedProperties()
        }
    }
    
    // 공통 프로퍼티
    private func configureCommonProperties() {
        self.titleLabel?.font = UIFont.KoreanButtonText
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
    
    // 하프 버튼 프로퍼티
    private func configureCommonPropertiesForHalf() {
        self.layer.cornerRadius = 42
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
    
    // 일반 버튼, 사용자가 탭하기 전 프로퍼티
    private func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    
    // 일반 버튼, 사용자가 탭한 뒤 프로퍼티
    private func configurePressedProperties() {
        self.isEnabled = false
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // 사각 버튼, 사용자가 탭하기 전 프로퍼티
    private func configureUnpressedPropertiesForSquare() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // 사각 버튼, 사용자가 탭한 뒤 프로퍼티
    private func configurePressedPropertiesForSquare() {
        self.isEnabled = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func setCurrencyIcon(style: SPButton.Style) {
        self.addSubview(currencyIcon)
        
        currencyIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(14)
        }
        
        switch style {
        case .primaryCalmshell:
            break
        case .primaryWatermelon:
            break
        case .primaryCherry:
            break
        case .primaryPear:
            break
        case .primaryMushroom:
            break
        case .primaryRadish:
            break
        case .warningRed:
            break
        case .primaryCalmshellPressed:
            break
        case .primaryWatermelonPressed:
            break
        case .primaryCherryPressed:
            break
        case .primaryPearPressed:
            break
        case .primaryMushroomPressed:
            break
        case .primaryRadishPressed:
            break
        case .warningRedPressed:
            break
        case .squarePrimaryCalmshell:
            break
        case .squarePrimaryWatermelon:
            break
        case .squareWarningRed:
            break
        case .deactivate:
            break
        case .squareDeactivate:
            break
        case .squarePrimaryCalmshellPressed:
            break
        case .squarePrimaryWatermelonPressed:
            break
        case .squareWarningRedPressed:
            break
        case .halfSmartSplit:
            currencyIcon.image = UIImage(named:"SplitIconDefault")
        case .halfEqualSplit:
            currencyIcon.image = UIImage(named:"EqualIconDefault")
        case .halfShare:
            currencyIcon.image = UIImage(named:"ShareIconDefault")
        case .halfExit:
            currencyIcon.image = UIImage(named:"ExitIconDefault")
        case .halfSmartSplitPressed:
            currencyIcon.image = UIImage(named:"SplitIconDefault")
        case .halfEqualSplitPressed:
            currencyIcon.image = UIImage(named:"EqualIconDefault")
        case .halfSharePressed:
            currencyIcon.image = UIImage(named:"ShareIconDefault")
        case .halfExitPressed:
            currencyIcon.image = UIImage(named:"ExitIconDefault")
        case .halfSmartSplitDeactivate:
            currencyIcon.image = UIImage(named:"SplitIconDeactivate")
        case .halfEqualSplitDeactivate:
            currencyIcon.image = UIImage(named:"EqualIconDeactivate")
        case .halfShareDeactivate:
            currencyIcon.image = UIImage(named:"ShareIconDeactivate")
        case .halfExitDeactivate:
            currencyIcon.image = UIImage(named:"ExitIconDeactivate")
        }
    }
    
    private func setCurrencyLabel(style: SPButton.Style) {
        self.addSubview(currencyLabel)
        
        currencyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
        }
        
        switch style {
        case .primaryCalmshell:
            break
        case .primaryWatermelon:
            break
        case .primaryCherry:
            break
        case .primaryPear:
            break
        case .primaryMushroom:
            break
        case .primaryRadish:
            break
        case .warningRed:
            break
        case .primaryCalmshellPressed:
            break
        case .primaryWatermelonPressed:
            break
        case .primaryCherryPressed:
            break
        case .primaryPearPressed:
            break
        case .primaryMushroomPressed:
            break
        case .primaryRadishPressed:
            break
        case .warningRedPressed:
            break
        case .squarePrimaryCalmshell:
            break
        case .squarePrimaryWatermelon:
            break
        case .squareWarningRed:
            break
        case .squarePrimaryCalmshellPressed:
            break
        case .squarePrimaryWatermelonPressed:
            break
        case .squareWarningRedPressed:
            break
        case .deactivate:
            break
        case .squareDeactivate:
            break
        case .halfSmartSplit:
            self.configureHalfButtonStringSmartSplitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfEqualSplit:
            self.configureHalfButtonStringEqualSplitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfShare:
            self.configureHalfButtonStringShareProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfExit:
            self.configureHalfButtonStringExitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfSmartSplitPressed:
            self.configureHalfButtonStringSmartSplitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfEqualSplitPressed:
            self.configureHalfButtonStringEqualSplitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfSharePressed:
            self.configureHalfButtonStringShareProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfExitPressed:
            self.configureHalfButtonStringExitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfSmartSplitDeactivate:
            self.configureHalfButtonStringSmartSplitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfEqualSplitDeactivate:
            self.configureHalfButtonStringEqualSplitProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfShareDeactivate:
            self.configureHalfButtonStringShareProperties()
            self.configureHalfButtonFontProperties()
            
        case .halfExitDeactivate:
            self.configureHalfButtonStringExitProperties()
            self.configureHalfButtonFontProperties()
        }
    }
    
    // 하프 버튼 폰트 및 타입페이스 설정
    private func configureHalfButtonFontProperties() {
        currencyLabel.font = UIFont.KoreanButtonText
    }
    
    private func configureHalfButtonStringSmartSplitProperties() {
        currencyLabel.text = "쓴 만큼 정산하기"
    }
    
    private func configureHalfButtonStringEqualSplitProperties() {
        currencyLabel.text = "1/n 정산하기"
    }
    
    private func configureHalfButtonStringShareProperties() {
        currencyLabel.text = "친구와 공유하기"
    }
    
    private func configureHalfButtonStringExitProperties() {
        currencyLabel.text = "스플리릿 끝내기"
    }
}

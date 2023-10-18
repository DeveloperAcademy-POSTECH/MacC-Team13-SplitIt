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
        
        // MARK: Button 330 Styles
        case primaryCalmshell
        case primaryWatermelon
        case primaryCherry
        case primaryPear
        case primaryMushroom
        case primaryRadish
        case secondary
        
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
        switch style {
        case .primaryCalmshell:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceBrandCalmshell
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .primaryWatermelon:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceBrandWatermelon
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .primaryCherry:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceBrandCherry
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .primaryPear:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceBrandPear
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .primaryMushroom:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceBrandMushroom
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .primaryRadish:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceBrandRadish
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .secondary:
            self.setTitle("버튼", for: .normal)
            self.setTitleColor(.TextPrimary, for: .normal)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceDeactivate
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
            
        case .deactivate:
            self.setTitle("버튼", for: .disabled)
            self.setTitleColor(.TextDeactivate, for: .disabled)
            self.layer.cornerRadius = 24
            self.backgroundColor = .SurfaceDeactivate
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.layer.borderWidth = 1
        }
    }
}

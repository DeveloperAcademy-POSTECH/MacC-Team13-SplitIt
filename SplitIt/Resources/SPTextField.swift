//
//  SPTextField.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/10/19.
//

import UIKit

extension SPTextField {
    enum Style {
        case normal
        case elseValue
        case number
        case deactivate
    }
}

final class SPTextField: UITextField {
    var monetaryUnitsCountry = UITextView()
    
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
        case .normal:
            self.keyboardType = .default
            self.configureCommonProperties()
            self.configureActiveProperties()

        case .elseValue:
            self.keyboardType = .default
            self.configureCommonProperties()
            self.configureActiveProperties()

        case .number:
            self.keyboardType = .numberPad
            self.configureCommonProperties()
            self.configureActiveProperties()
            
        case .deactivate:
            self.configureDeactiveProperties()
        }
    }

    private func configureCommonProperties() {
        self.backgroundColor = UIColor.SurfacePrimary
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.textAlignment = .center
    }

    private func configureActiveProperties() {
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
    }

    private func configureDeactiveProperties() {
        self.isEnabled = false
        self.layer.borderColor = UIColor.BorderDeactivate.cgColor
    }
}

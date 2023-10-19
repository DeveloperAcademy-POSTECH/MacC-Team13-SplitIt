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
        setCurrencyLabel(style: style)
        
        switch style {
            
            // 일반 키보드
        case .normal:
            self.keyboardType = .default
            self.configureCommonProperties()
            self.configureActiveProperties()

            // 따로 계산용 키보드
        case .elseValue:
            self.keyboardType = .default
            self.configureCommonProperties()
            self.configureActiveProperties()

            // 숫자 키보드
        case .number:
            self.keyboardType = .numberPad
            self.configureCommonProperties()
            self.configureActiveProperties()
            
            // 비활성 키보드
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
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
    }

    private func configureDeactiveProperties() {
        self.isEnabled = false
        self.layer.borderColor = UIColor.BorderDeactivate.cgColor
    }
    
    private func setCurrencyLabel(style: SPTextField.Style) {
        self.addSubview(currencyLabel)
        
        currencyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        switch style {
        case .normal:
            break
        case .elseValue:
            currencyLabel.text = "값"
        case .number:
            currencyLabel.text = "KRW"
        case .deactivate:
            break
        }
    }
    
}

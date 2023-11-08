//
//  SPTextField.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa

extension SPTextField {
    enum Style {
        case normal
        case elseValue
        case number
        case deactivate
        case editingDidEndNormal
        case editingDidBeginNormal
        case editingDidEndNumber
        case editingDidBeginNumber
    }
}

final class SPTextField: UITextField {
    let currencyLabel = UILabel()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setBinding() {
        // MARK: editingDidEnd일 때를 구독하여 공백을 제거합니다.
        rx.controlEvent(.editingDidEnd)
            .map{ self.text?.trimmingCharacters(in: .whitespaces) ?? "" }
            .asDriver(onErrorJustReturn: "")
            .drive(rx.text)
            .disposed(by: disposeBag)
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
            
            // 편집중이지 않은 키보드
        case .editingDidEndNormal:
            self.keyboardType = .default
            self.configureCommonProperties()
            self.configureDidEndProperties()
            
            // 편집중인 키보드
        case .editingDidBeginNormal:
            self.keyboardType = .default
            self.configureCommonProperties()
            self.configureDidBeginProperties()
            
            // 편집중이지 않은 키보드 (숫자)
        case .editingDidEndNumber:
            self.keyboardType = .numberPad
            self.configureCommonProperties()
            self.configureDidEndProperties()
            self.addPaddingLeft(40)
            
            // 편집중인 키보드 (숫자)
        case .editingDidBeginNumber:
            self.keyboardType = .numberPad
            self.configureCommonProperties()
            self.configureDidBeginProperties()
            self.addPaddingLeft(40)
        }
    }

    private func configureCommonProperties() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.TextSecondary,
        ]

        let attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)

        self.attributedPlaceholder = attributedPlaceholder

        self.backgroundColor = UIColor.SurfacePrimary
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.addPaddingLeft(16)
    }
    
    private func configureDidEndProperties() {
        self.layer.borderColor = UIColor.BorderDeactivate.cgColor
    }
    
    private func configureDidBeginProperties() {
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
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
            $0.leading.equalToSuperview().inset(15)
        }
        
        switch style {
        case .normal:
            break
        case .elseValue:
//            currencyLabel.text = "값"
            self.configureCurrencyLabelFontProperties()
            
        case .number:
//            currencyLabel.text = "KRW"
            self.configureCurrencyLabelFontProperties()
            
        case .deactivate:
            break
            
        case .editingDidEndNormal:
            self.configureCurrencyLabelFontProperties()
            
        case .editingDidBeginNormal:
            self.configureCurrencyLabelFontProperties()
            
        case .editingDidEndNumber:
            currencyLabel.text = "₩"
            self.configureCurrencyLabelFontProperties()
            
        case .editingDidBeginNumber:
            currencyLabel.text = "₩"
            self.configureCurrencyLabelFontProperties()
        }
    }
    
    private func configureCurrencyLabelFontProperties() {
        currencyLabel.font = UIFont.KoreanCaption1
    }
    
}

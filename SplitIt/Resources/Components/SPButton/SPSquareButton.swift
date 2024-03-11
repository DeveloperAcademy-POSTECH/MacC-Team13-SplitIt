//
//  SPSquareButton.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit
import RxSwift
import RxCocoa

final class SPSquareButton: SPButtonImpl {
    
    private var disposeBag = DisposeBag()
    
    override var isEnabled: Bool {
        didSet {
            guard oldValue != isEnabled else {
                return
            }
            
            if isEnabled {
                animateButtonActive()
            } else {
                animateButtonDeactive()
            }
        }
    }
    
    override func applyStyle(style: SPButtonStyle) {
        super.applyStyle(style: style)
        
        configureCommonProperties()
        bindInput()
    }
    
    private func bindInput() {
        let touchUpInsideDriver = self.rx.controlEvent(.touchUpInside).asDriver()
        let touchUpOutsideDriver = self.rx.controlEvent(.touchUpOutside).asDriver()
        let touchUpDriver = Driver.merge(touchUpInsideDriver, touchUpOutsideDriver)
        let touchDownDriver = self.rx.controlEvent(.touchDown).asDriver()

        touchUpDriver
            .drive(with: self,
                   onNext: { owner, _ in
                owner.didTouchUp()
            })
            .disposed(by: disposeBag)
        
        touchDownDriver
            .drive(with: self,
                   onNext: { owner, _ in
                owner.didTouchDown()
            })
            .disposed(by: disposeBag)
    }
    
    private func didTouchUp() {
        configureButtonUpUI()
        updateVerticalPosition(by: -2.0)
    }
    
    private func didTouchDown() {
        configureButtonDownUI()
        updateVerticalPosition(by: 2.0)
    }
}

extension SPSquareButton {
    private func configureButtonUpUI() {
        if unpressedColor == .SurfaceSecondary {
            configureActivePropertiesInvert()
        } else {
            configureActiveProperties()
        }
        
        configureUnpressedProperties()
        self.backgroundColor = unpressedColor
    }
    
    private func configureButtonDownUI() {
        configurePressedProperties()
        self.backgroundColor = pressedColor
    }
}
    
// MARK: Animate
extension SPSquareButton {
    // 버튼 활성 애니메이션
    private func animateButtonActive() {
        self.backgroundColor = unpressedColor
        
        if unpressedColor == .SurfaceSecondary {
            configureActivePropertiesInvert()
        } else {
            configureActiveProperties()
        }

        configureUnpressedProperties()
    }
    
    // 버튼 비활성 애니메이션 (즉시 적용)
    private func animateButtonDeactive() {
        self.backgroundColor = .AppColorBrandCalmshell
        configureDeactiveProperties()
        configurePressedProperties()
    }
}

extension SPSquareButton: SPButtonProtocol {
    func configureCommonProperties() {
        self.titleLabel?.font = UIFont.KoreanButtonText
        self.layer.cornerRadius = 8
        
        configureButtonUpUI()
    }
    
    func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    func configurePressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}

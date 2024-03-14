//
//  SPRoundedButton.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit
import RxSwift
import RxCocoa

final class SPRoundedButton: SPButtonImpl {
    
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
        updateVerticalPosition(by: -4.0)
    }
    
    private func didTouchDown() {
        configureButtonDownUI()
        updateVerticalPosition(by: 4.0)
    }
}

extension SPRoundedButton {
    private func configureButtonUpUI() {
        self.backgroundColor = unpressedColor
        self.configureActiveProperties()
        self.configureUnpressedProperties()
    }
    
    private func configureButtonDownUI() {
        configurePressedProperties()
        self.backgroundColor = pressedColor
    }
}

// MARK: Animate
extension SPRoundedButton {
    // 버튼 활성 애니메이션
    private func animateButtonActive() {
        UIView.animate(withDuration: 0.22) {
            self.configureUnpressedProperties()
            self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY - 4.0), size: self.frame.size)
        }
        
        UIView.transition(with: self, duration: 0.22, options: .transitionCrossDissolve) {
            self.backgroundColor = self.unpressedColor
            self.configureActiveProperties()
        }
    }
    
    // 버튼 비활성 애니메이션 (즉시 적용)
    private func animateButtonDeactive() {
        self.backgroundColor = .AppColorBrandCalmshell
        self.configureDeactiveProperties()
        self.configurePressedProperties()
        self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY + 4.0), size: self.frame.size)
    }
}

extension SPRoundedButton: SPButtonProtocol {
    func configureCommonProperties() {
        self.titleLabel?.font = UIFont.KoreanButtonText
        self.layer.cornerRadius = 24
        
        configureButtonUpUI()
    }
    
    func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    
    func configurePressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

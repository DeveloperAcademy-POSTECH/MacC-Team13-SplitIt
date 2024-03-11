//
//  SPHomeButton.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit
import RxSwift
import RxCocoa

final class SPHomeButton: SPButtonImpl {
    
    private var disposeBag = DisposeBag()

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
        updateVerticalPosition(by: -6.0)
    }
    
    private func didTouchDown() {
        configureButtonDownUI()
        updateVerticalPosition(by: 6.0)
    }
}

extension SPHomeButton {
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

extension SPHomeButton: SPButtonProtocol {
    func configureCommonProperties() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        
        configureButtonUpUI()
    }
    
    func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func configurePressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

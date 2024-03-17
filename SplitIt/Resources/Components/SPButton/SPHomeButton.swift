//
//  SPHomeButton.swift
//  SplitIt
//
//  Created by 홍승완 on 2024/03/11.
//

import UIKit
import RxSwift
import RxCocoa

final class SPHomeButton: UIButton, SPButton {
    private var style: SPButtonStyle
    
    private var disposeBag = DisposeBag()
    
    init(style: SPButtonStyle) {
        self.style = style
        
        super.init(frame: .zero)
        configureUniqueProperties()
        bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyStyle(style: SPButtonStyle) {
        self.style = style
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
        updateVerticalPosition(self, by: -6.0)
    }
    
    private func didTouchDown() {
        configureButtonDownUI()
        updateVerticalPosition(self, by: 6.0)
    }
}

extension SPHomeButton {
    private func configureButtonUpUI() {
        self.backgroundColor = style.unpressedColor
        self.configureActiveProperties(self)
        self.configureUnpressedProperties()
    }
    
    private func configureButtonDownUI() {
        configurePressedProperties()
        self.backgroundColor = style.pressedColor
    }
}

// HomeButton 기본 특성
extension SPHomeButton {
    func configureUniqueProperties() {
        configureCommonProperties(self)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        
        configureButtonUpUI()
    }
    
    func configureUnpressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, 
                                         height: 10)
    }
    
    func configurePressedProperties() {
        self.layer.shadowOffset = CGSize(width: 0, 
                                         height: 2)
    }
}

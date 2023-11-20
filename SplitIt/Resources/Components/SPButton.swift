//
//  NewSPButton.swift
//  SplitIt
//
//  Created by SUNGIL-POS on 2023/10/26.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

//MARK: 토마토 Task
final class SPButton: UIButton {
    var disposeBag = DisposeBag()
    
    let buttonState = BehaviorRelay<Bool>(value: false)
    
    let colorArray: [Style: UIColor] = [
        .primaryCalmshell: .SurfaceBrandCalmshell,
        .primaryWatermelon: .SurfaceBrandWatermelon,
        .primaryCherry: .SurfaceBrandCherry,
        .primaryPear: .SurfaceBrandPear,
        .primaryMushroom: .SurfaceBrandMushroom,
        .primaryRadish: .SurfaceBrandRadish,
        .surfaceWhite: .SurfaceWhite,
        .surfaceSecondary: .SurfaceSecondary,
        .warningRed: .SurfaceWarnRed
    ]
    
    let colorPressedArray: [Style: UIColor] = [
        .primaryCalmshell: .SurfaceBrandCalmshellPressed,
        .primaryWatermelon: .SurfaceBrandWatermelonPressed,
        .primaryCherry: .SurfaceBrandCherryPressed,
        .primaryPear: .SurfaceBrandPearPressed,
        .primaryMushroom: .SurfaceBrandMushroomPressed,
        .primaryRadish: .SurfaceBrandRadishPressed,
        .surfaceWhite: .SurfaceSelected,
        .surfaceSecondary: .SurfaceSecondaryPressed,
        .warningRed: .SurfaceWarnRedPressed
    ]

    func applyStyle(style: Style, shape: Shape) {
        configureCommonProperties()
        
        switch shape {
        case .rounded:
            self.configureCommonPropertiesForRounded()
            
            buttonState
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { [weak self] isEnable in
                    guard let self = self else { return }
                    self.isEnabled = isEnable
                    if isEnable {
                        UIView.animate(withDuration: 0.22) {
                            self.configureUnpressedProperties()
                            self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY - 4.0), size: self.frame.size)
                        }
                        UIView.transition(with: self, duration: 0.22, options: .transitionCrossDissolve) {
                            self.backgroundColor = self.colorArray[style]
                            self.configureActiveProperties()
                        }
                    } else {
                        self.backgroundColor = .AppColorBrandCalmshell
                        self.configureDeactiveProperties()
                        self.configurePressedProperties()
                        self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY + 4.0), size: self.frame.size)
                    }
                })
                .disposed(by: disposeBag)
            
            Observable.merge(self.rx.controlEvent(.touchUpInside).asObservable(),
                             self.rx.controlEvent(.touchUpOutside).asObservable())
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.backgroundColor = colorArray[style]
                self.isEnabled = true
                self.configureActiveProperties()
                self.configureUnpressedProperties()
                self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY - 4.0), size: self.frame.size)
            })
            .disposed(by: disposeBag)
            
            self.rx.controlEvent(.touchDown)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.configurePressedProperties()
                    self.backgroundColor = colorPressedArray[style]
                    self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY + 4.0), size: self.frame.size)
                })
                .disposed(by: disposeBag)
            
        case .square:
            self.configureCommonPropertiesForSquare()
            
            buttonState
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { [weak self] isEnable in
                    guard let self = self else { return }
                    self.isEnabled = isEnable
                    if isEnable {
                        self.backgroundColor = colorArray[style]
                        self.configureActiveProperties()
                        self.configureUnpressedPropertiesForSquare()
                    } else {
                        self.backgroundColor = .AppColorBrandCalmshell
                        self.configureDeactiveProperties()
                        self.configurePressedPropertiesForSquare()
                    }
                })
                .disposed(by: disposeBag)
            
            Observable.merge(self.rx.controlEvent(.touchUpInside).asObservable(),
                             self.rx.controlEvent(.touchUpOutside).asObservable())
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isEnabled = true
                self.configureActiveProperties()
                self.configureUnpressedPropertiesForSquare()
                self.backgroundColor = colorArray[style]
                self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY - 2.0), size: self.frame.size)
            })
            .disposed(by: disposeBag)
            
            
            self.rx.controlEvent(.touchDown)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.configurePressedPropertiesForSquare()
                    self.backgroundColor = colorPressedArray[style]
                    self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY + 2.0), size: self.frame.size)
                })
                .disposed(by: disposeBag)
            
        case .home:
            self.configureCommonPropertiesForHome()
            
            buttonState
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { [weak self] isEnable in
                    guard let self = self else { return }
                    self.isEnabled = isEnable
                    if isEnable {
                        self.backgroundColor = colorArray[style]
                        self.configureActiveProperties()
                        self.configureUnpressedPropertiesForHome()
                    } else {
                        self.backgroundColor = .AppColorBrandCalmshell
                        self.configureDeactiveProperties()
                        self.configurePressedPropertiesForHome()
                    }
                })
                .disposed(by: disposeBag)
            
            Observable.merge(self.rx.controlEvent(.touchUpInside).asObservable(),
                             self.rx.controlEvent(.touchUpOutside).asObservable())
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isEnabled = true
                self.configureActiveProperties()
                self.configureUnpressedPropertiesForHome()
                self.backgroundColor = colorArray[style]
                self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY - 6.0), size: self.frame.size)
            })
            .disposed(by: disposeBag)
            
            self.rx.controlEvent(.touchDown)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.configurePressedPropertiesForHome()
                    self.backgroundColor = colorPressedArray[style]
                    self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY + 6.0), size: self.frame.size)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension SPButton {
    enum Style {
        case primaryCalmshell
        case primaryWatermelon
        case primaryCherry
        case primaryPear
        case primaryMushroom
        case primaryRadish
        case warningRed
        case surfaceWhite
        case surfaceSecondary
    }
    
    enum Shape {
        case rounded
        case square
        case home
    }
}

// MARK: - Style Configuration
extension SPButton {
    // 공통 프로퍼티
    private func configureCommonProperties() {
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
    }
    
    // 둥근 버튼 프로퍼티
    private func configureCommonPropertiesForRounded() {
        self.titleLabel?.font = UIFont.KoreanButtonText
        self.layer.cornerRadius = 24
    }
    
    // 사각 버튼 프로퍼티
    private func configureCommonPropertiesForSquare() {
        self.titleLabel?.font = UIFont.KoreanButtonText
        self.layer.cornerRadius = 8
    }
    
    // Home 관련 버튼 프로퍼티
    private func configureCommonPropertiesForHome() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
    }
    
    // 활성 상태 프로퍼티
    private func configureActiveProperties() {
        self.setTitleColor(.TextPrimary, for: .normal)
        self.layer.borderColor = UIColor.BorderPrimary.cgColor
        self.layer.shadowColor = UIColor.BorderPrimary.cgColor
    }
    
    // 비활성 상태 프로퍼티
    private func configureDeactiveProperties() {
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
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // 사각 버튼, 사용자가 탭하기 전 프로퍼티
    private func configureUnpressedPropertiesForSquare() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // 사각 버튼, 사용자가 탭한 뒤 프로퍼티
    private func configurePressedPropertiesForSquare() {
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    // Home 관련 버튼, 사용자가 탭하기 전 프로퍼티
    private func configureUnpressedPropertiesForHome() {
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
    }

    // Home 관련 버튼, 사용자가 탭한 뒤 프로퍼티
    private func configurePressedPropertiesForHome() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

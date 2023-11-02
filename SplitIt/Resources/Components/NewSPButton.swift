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
final class NewSPButton: UIButton {
    let buttonState = BehaviorRelay<Bool>(value: false)
    let currencyIcon = UIImageView()
    let currencyLabel = UILabel()
    
    let colorArray: [Style: UIColor] = [
        .primaryCalmshell: .SurfaceBrandCalmshell,
        .primaryWatermelon: .SurfaceBrandWatermelon,
        .primaryCherry: .SurfaceBrandCherry,
        .primaryPear: .SurfaceBrandPear,
        .primaryMushroom: .SurfaceBrandMushroom,
        .primaryRadish: .SurfaceBrandRadish,
        .warningRed: .SurfaceWarnRed,
        .halfSmartSplit: .SurfaceBrandCalmshell,
        .halfEqualSplit: .SurfaceBrandCalmshell,
    ]
    
    let colorPressedArray: [Style: UIColor] = [
        .primaryCalmshell: .SurfaceBrandCalmshellPressed,
        .primaryWatermelon: .SurfaceBrandWatermelonPressed,
        .primaryCherry: .SurfaceBrandCherryPressed,
        .primaryPear: .SurfaceBrandPearPressed,
        .primaryMushroom: .SurfaceBrandMushroomPressed,
        .primaryRadish: .SurfaceBrandRadishPressed,
        .warningRed: .SurfaceWarnRedPressed,
        .halfSmartSplit: .SurfaceBrandCalmshellPressed,
        .halfEqualSplit: .SurfaceBrandCalmshellPressed,
    ]
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Style Configuration
    
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
    
    // 하프 버튼 프로퍼티
    private func configureCommonPropertiesForHalf() {
        self.titleLabel?.font = UIFont.KoreanButtonText
        self.layer.cornerRadius = 42
    }
    
    // 작은 버튼 프로퍼티
    private func configureCommonPropertiesForSmall() {
        self.titleLabel?.font = UIFont.KoreanSmallButtonText
        self.layer.cornerRadius = 16
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
    
    // 하프 버튼 폰트 및 타입페이스 일괄 설정 프로퍼티
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
    
    func applyStyle(style: Style, shape: Shape) {
        setCurrencyIcon(style: style)
        setCurrencyLabel(style: style)
        
        disposeBag = DisposeBag()
        
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
                    configureCommonProperties()
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
                self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY - 4.0), size: self.frame.size)
            })
            .disposed(by: disposeBag)
            
            
            self.rx.controlEvent(.touchDown)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.configurePressedPropertiesForSquare()
                    self.backgroundColor = colorPressedArray[style]
                    self.frame = CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY + 4.0), size: self.frame.size)
                })
                .disposed(by: disposeBag)
            
        case .half:
            self.configureCommonPropertiesForHalf()
            
            buttonState
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { [weak self] isEnable in
                    guard let self = self else { return }
                    self.isEnabled = isEnable
                    if isEnable {
                        self.backgroundColor = colorArray[style]
                        self.configureActiveProperties()
                        self.configureUnpressedProperties()
                    } else {
                        self.backgroundColor = .AppColorBrandCalmshell
                        self.configureDeactiveProperties()
                        self.configurePressedProperties()
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
                self.configureUnpressedProperties()
                self.backgroundColor = colorArray[style]
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
        }
        
        switch style {
            
            // 활성 버튼, Unpressed 상태
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
            
            // 활성 하프 버튼
        case .halfSmartSplit:
            break
        case .halfEqualSplit:
            break
            
            // 작은 버튼
        case .smallButton:
            self.backgroundColor = .SurfaceSelected
            self.configureCommonPropertiesForSmall()
            self.configureActiveProperties()
        }
    }
    
    // 하프 버튼에 아이콘 추가
    private func setCurrencyIcon(style: NewSPButton.Style) {
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
        case .smallButton:
            break
            
        case .halfSmartSplit:
            currencyIcon.image = UIImage(named: "SmartSplitIconDefault")
        case .halfEqualSplit:
            currencyIcon.image = UIImage(named: "EqualSplitIconDefault")
        }
    }
    
    // 하프 버튼에 라벨 추가
    private func setCurrencyLabel(style: NewSPButton.Style) {
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
        case .smallButton:
            break
            
        case .halfSmartSplit:
            self.configureHalfButtonStringSmartSplitProperties()
            self.configureHalfButtonFontProperties()
        case .halfEqualSplit:
            self.configureHalfButtonStringEqualSplitProperties()
            self.configureHalfButtonFontProperties()
        }
    }
}


extension NewSPButton {
    enum Style {
        
        // MARK: Active Normal Button Styles
        case primaryCalmshell
        case primaryWatermelon
        case primaryCherry
        case primaryPear
        case primaryMushroom
        case primaryRadish
        case warningRed
        
        // MARK: Active Half Button Styles
        case halfSmartSplit
        case halfEqualSplit
        
        // MARK: Active Small Button Style
        case smallButton
    }
    
    enum Shape {
        case rounded
        case square
        case half
    }
}

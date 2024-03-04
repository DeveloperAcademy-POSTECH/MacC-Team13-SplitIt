//
//  SPNaviBar.swift
//  SplitIt
//
//  Created by Zerom on 1/10/24.
//

import UIKit
import Then
import SnapKit

extension SPNaviBar {
    enum ProgressImageType {
        case smartFirst
        case smartSecond
        case smartThird
        case equalFirst
        case equalSecond
    }
}

final class SPNaviBar: UIView {
    let naviTitleLabel = UILabel()
    let titleImage = UIImageView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    func setTitle(title: String) {
        
        naviTitleLabel.do {
            $0.text = title
            $0.font = .KoreanSubtitle
            $0.textColor = .TextPrimary
        }
        
        self.addSubview(naviTitleLabel)
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func setTitleImage(type: ProgressImageType) {
        
        switch type {
        case .smartFirst:
            titleImage.image = UIImage(named: "smartPorgressFirst")!
        case .smartSecond:
            titleImage.image = UIImage(named: "smartPorgressSecond")!
        case .smartThird:
            titleImage.image = UIImage(named: "smartPorgressThird")!
        case .equalFirst:
            titleImage.image = UIImage(named: "equalPorgressFirst")!
        case .equalSecond:
            titleImage.image = UIImage(named: "equalPorgressSecond")!
        }
        
        self.addSubview(titleImage)
        
        titleImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setLeftImageButton(imageName: String) {
        leftButton.do {
            $0.setImage(UIImage(named: imageName), for: .normal)
            $0.imageView?.tintColor = UIColor.TextPrimary
            $0.sizeToFit()
        }
        
        self.addSubview(leftButton)
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.width.height.equalTo(30)
        }
    }
    
    func setLeftTextButton(title: String, titleColor: UIColor, selectedColor: UIColor) {
        leftButton.do {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            $0.setTitleColor(selectedColor, for: .highlighted)
            $0.titleLabel?.font = .KoreanSubtitle
        }
        
        self.addSubview(leftButton)
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
    }
    
    func setRightTextButton(title: String, titleColor: UIColor, selectedColor: UIColor) {
        rightButton.do {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .KoreanSubtitle
            $0.setTitleColor(titleColor, for: .normal)
            $0.setTitleColor(selectedColor, for: .highlighted)
            $0.setTitleColor(.TextDeactivate, for: .disabled)
        }
        
        self.addSubview(rightButton)
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    func setRightExitButton() {
        rightButton.do {
            $0.setImage(UIImage(named: "XMark"), for: .normal)
            $0.imageView?.tintColor = UIColor.TextPrimary
            $0.sizeToFit()
        }
        
        self.addSubview(rightButton)
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(26)
        }
    }
    
    func setRightReceiptsButton() {
        rightButton.do {
            if let symbolImage = UIImage(systemName: "newspaper") {
                let resizedImage = symbolImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
                
                // resizedImage를 사용하여 원하는 작업 수행
                $0.setImage(resizedImage, for: .normal)
                $0.imageView?.tintColor = UIColor.TextPrimary
            }
        }
        
        self.addSubview(rightButton)
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(26)
        }
    }
}

//
//  NavigationHeader.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/20.
//

import UIKit
import Then
import SnapKit

extension NaviHeader {
    enum Style {
        /// 차수 타이틀 입력 View
        case csTitle
        /// 차수 가격 입력 View
        case csPrice
        /// 차수 멤버 입력 View
        case csMember
        /// 차수 안먹은 음식 제외 Flow
        case csExcl
        /// 스플릿 타이틀 입력 View
        case splitTitle
        /// 수정 Flow
        case edit
        /// 영수증 공유 View
        case print
        /// 스플릿 내역 View
        case history
        /// 설정 View
        case setting
        /// 나의 정보 View
        case myInfo
        /// 친구 검색 기록 View
        case friendSearch
        /// 스플릿 결과 View
        case result
        /// ExclInfo 추가(Modal)
        case exclInfoAdd
        /// ExclInfo 수정(Modal)
        case exclInfoEdit
    }
}

final class NaviHeader: UIView {
    let backButton = UIButton()
    let addButton = UIButton()
    let cancelButton = UIButton()
    let naviTitleLabel = UILabel()
    let naviImage = UIView()
    let titleImageView = UIImageView()
    let priceImageView = UIImageView()
    let memberImageView = UIImageView()
    let exclImageView = UIImageView()
    let exitButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyStyle(_ style: Style) {
        
        switch style {
        case .csTitle:
            setNaviImage(imageCase: 0)
        case .csPrice:
            setNaviImage(imageCase: 1)
        case .csMember:
            setNaviImage(imageCase: 2)
        case .csExcl:
            setNaviImage(imageCase: 3)
        case .splitTitle:
            naviTitleLabel.text = "모임이름"
        case .edit:
            naviTitleLabel.text = "모임 수정하기"
        case .print:
            naviTitleLabel.text = "스플릿 영수증 발급"
        case .history:
            naviTitleLabel.text = "스플릿 내역"
        case .setting:
            naviTitleLabel.text = "설정"
        case .myInfo:
            naviTitleLabel.text = "나의 정보"
        case .friendSearch:
            naviTitleLabel.text = "친구 검색 내역"
        case .result:
            setExitButton()
            naviTitleLabel.text = "스플릿 결과"
            backButton.removeFromSuperview()
        case .exclInfoAdd:
            naviTitleLabel.text = "따로 정산 항목"
            setCancelButton()
            backButton.removeFromSuperview()
        case .exclInfoEdit:
            naviTitleLabel.text = "따로 정산 항목 수정"
            setCancelButton()
            backButton.removeFromSuperview()
        }
    }
    
    func setAttribute() {
        self.backgroundColor = .SurfacePrimary
        naviImage.isHidden = true
        
        naviTitleLabel.do {
            $0.font = .KoreanSubtitle
            $0.textColor = .TextPrimary
        }
        
        backButton.do {
            $0.setImage(UIImage(named: "BackIcon"), for: .normal)
            $0.sizeToFit()
        }
    }
    
    func setExitButton() {
        exitButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.imageView?.tintColor = UIColor.TextPrimary
            $0.sizeToFit()
        }
        
        addSubview(exitButton)
        
        exitButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalToSuperview()
            $0.width.equalTo(30)
        }
    }
    
    func setAddButton() {
        addButton.do {
            $0.setTitle("추가", for: .normal)
            $0.setTitleColor(.SurfaceBrandWatermelon, for: .normal)
            $0.setTitleColor(.SurfaceBrandWatermelonPressed, for: .highlighted)
            $0.setTitleColor(.TextDeactivate, for: .disabled)
            $0.titleLabel?.font = .KoreanSubtitle
        }
        
        addSubview(addButton)
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(22)
            $0.width.equalTo(39)
        }
    }
    
    func setCancelButton() {
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.SurfaceBrandWatermelon, for: .normal)
            $0.setTitleColor(.SurfaceBrandWatermelonPressed, for: .highlighted)
            $0.titleLabel?.font = .KoreanSubtitle
        }
        
        addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(22)
            $0.width.equalTo(39)
        }
    }
    
    func setNaviImage(imageCase: Int) {
        naviImage.isHidden = false
        naviTitleLabel.isHidden = true
        
        titleImageView.do {
            $0.image = UIImage(named: imageCase == 0 ? "TagActive" : "TagDeactive")
            $0.sizeToFit()
        }
        
        priceImageView.do {
            $0.image = UIImage(named: imageCase == 1 ? "CurrencyActive" : "CurrencyDeactive")
            $0.sizeToFit()
        }
        
        memberImageView.do {
            $0.image = UIImage(named: imageCase == 2 ? "MemberActive" : "MemberDeactive")
            $0.sizeToFit()
        }
        
        exclImageView.do {
            $0.image = UIImage(named: imageCase == 3 ? "ElseValueActive" : "ElseValueDeactive")
            $0.sizeToFit()
        }
    }
    
    func setLayout() {
        
        [backButton, naviTitleLabel, naviImage].forEach {
            self.addSubview($0)
        }
        
        [titleImageView, priceImageView, memberImageView, exclImageView].forEach {
            naviImage.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        naviImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalToSuperview()
        }
        
        exclImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        memberImageView.snp.makeConstraints {
            $0.trailing.equalTo(exclImageView.snp.leading).offset(-8)
            $0.height.equalToSuperview()
            $0.width.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        priceImageView.snp.makeConstraints {
            $0.trailing.equalTo(memberImageView.snp.leading).offset(-8)
            $0.height.equalToSuperview()
            $0.width.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        titleImageView.snp.makeConstraints {
            $0.trailing.equalTo(priceImageView.snp.leading).offset(-8)
            $0.height.equalToSuperview()
            $0.width.equalTo(60)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setBackButtonToRootView(viewController: UIViewController) {
        backButton.removeAllActions()
        
        let backAction = UIAction { action in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
        backButton.addAction(backAction, for: .touchUpInside)
    }
    
    func setBackButton(viewController: UIViewController) {
        backButton.removeAllActions()
        
        let backAction = UIAction { action in
            viewController.navigationController?.popViewController(animated: true)
        }
        backButton.addAction(backAction, for: .touchUpInside)
    }
    
    func setBackButton(action: UIAction) {
        backButton.removeAllActions()
        
        backButton.addAction(action, for: .touchUpInside)
    }
    
    func setExitButton(viewController: UIViewController) {
        exitButton.removeAllActions()
        
        let exitAction = UIAction { action in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
        exitButton.addAction(exitAction, for: .touchUpInside)
    }
}

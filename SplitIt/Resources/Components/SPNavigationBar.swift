//
//  NavigationBar.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/31.
//


import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

extension SPNavigationBar {
    enum Style {
        /// 정산 방식 선택 View
        case selectSplitMethod
        /// 차수 이름, 금액 입력 View
        case csInfoCreate
        /// 차수 멤버 입력 View
        case csMemberCreate
        /// 멤버 검색 View
        case memberSearch
        /// 차수 안먹은 음식 제외 Flow
        case exclItemCreate
        /// 안먹은 음식 제외 추가 모달
        case exclItemCreateModal
        /// 안먹은 음식 제외 수정 모달
        case exclItemEditModal
        /// 정산 수정하기 View
        case splitEdit
        /// 차수 수정하기 Flow
        case csEdit
        /// Create Flow 영수증 공유 View
        case createToShare
        /// History Flow 영수증 공유 View
        case historyToShare
        /// 스플릿 내역 View
        case history
        /// 설정 View
        case setting
        /// 셋팅에서 들어가는 나의 정보 View
        case settingToMyInfo
        /// popup에서 들어가는 나의 정보 View
        case popUpToMyInfo
        /// 멤버 추가 내역 View
        case memberSearchHistory
        /// csInfo 타이틀, 총금액 수정 View
        case editCSInfo
        /// csMember 수정 View
        case editCSMember
        /// exclItemList 수정 View
        case editExclItemList
    }
    
    enum ActionType {
        case toBack
        case toRoot
        case none
    }
}

final class SPNavigationBar: UIView {
    let disposeBag = DisposeBag()
    let buttonState = BehaviorRelay<Bool>(value: false)
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .SurfacePrimary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyStyle(style: Style, vc: UIViewController) {
        switch style {
        case .selectSplitMethod:
            setLeftBackButton(action: .toBack, vc: vc)
        case .csInfoCreate:
            setNaviImage(imageCase: 0)
            setLeftBackButton(action: .toBack, vc: vc)
            setExitButton(vc: vc, action: false)
        case .csMemberCreate:
            setNaviImage(imageCase: 1)
            setLeftBackButton(action: .toBack, vc: vc)
            setExitButton(vc: vc, action: false)
        case .memberSearch:
            setNaviTitle(title: "멤버 추가")
            setRightDismissButton(title: "확인", titleColor: .AppColorStatusDarkPear, selectedColor: .SurfaceBrandPearPressed, vc: vc)
        case .exclItemCreate:
            setNaviImage(imageCase: 2)
            setLeftBackButton(action: .none, vc: vc)
            setExitButton(vc: vc, action: false)
        case .exclItemCreateModal:
            setNaviTitle(title: "따로 정산 항목")
            setLeftDismissButton(title: "취소", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
            setRightDismissButton(title: "추가", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
        case .exclItemEditModal:
            setNaviTitle(title: "따로 정산 항목")
            setLeftDismissButton(title: "취소", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
            setRightDismissButton(title: "저장", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
        case .splitEdit:
            setNaviTitle(title: "차수 선택")
            setLeftBackButton(action: .toBack, vc: vc)
        case .csEdit:
            setNaviTitle(title: "차수 수정")
            setLeftBackButton(action: .none, vc: vc)
            setReceiptsButton(vc: vc, action: false)
        case .createToShare:
            setNaviTitle(title: "정산 결과")
            setExitButton(vc: vc, action: true)
        case .historyToShare:
            setNaviTitle(title: "정산 결과")
            setLeftBackButton(action: .toBack, vc: vc)
        case .history:
            setNaviTitle(title: "정산 기록")
            setLeftBackButton(action: .toBack, vc: vc)
        case .setting:
            setNaviTitle(title: "나의 설정")
            setLeftBackButton(action: .toBack, vc: vc)
        case .settingToMyInfo:
            setNaviTitle(title: "계좌 설정")
            setLeftBackButton(action: .toBack, vc: vc)
            setRightBackButton(title: "저장", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
        case .popUpToMyInfo:
            setNaviTitle(title: "계좌 설정")
            setRightDismissButton(title: "저장", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
        case .memberSearchHistory:
            setNaviTitle(title: "멤버 내역")
            setLeftBackButton(action: .toBack, vc: vc)
        case .editCSInfo:
            setNaviTitle(title: "이름 및 총액")
            setLeftBackButton(action: .none, vc: vc)
            setRightBackButton(title: "저장", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
        case .editCSMember:
            setNaviTitle(title: "함께한 멤버")
            setLeftBackButton(action: .none, vc: vc)
            setRightBackButton(title: "저장", titleColor: .SurfaceBrandWatermelon, selectedColor: .SurfaceBrandWatermelonPressed, vc: vc)
        case .editExclItemList:
            setNaviTitle(title: "따로 정산")
            setLeftBackButton(action: .toBack, vc: vc)
            setReceiptsButton(vc: vc, action: false)
        }
    }
    
    func setNaviTitle(title: String) {
        let naviTitleLabel = UILabel()
        
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
    
    func setNaviImage(imageCase: Int) {
        let csInfoCreateView = UIImageView()
        let csMemberCreateView = UIImageView()
        
        csInfoCreateView.do {
            $0.image = UIImage(named: imageCase == 0 ? "CSInfoCreateActive" : "CSInfoCreateDeactive")
            $0.sizeToFit()
        }
        
        csMemberCreateView.do {
            $0.image = UIImage(named: imageCase == 1 ? "MemberCreateActive" : "MemberCreateDeactive")
            $0.sizeToFit()
        }
        
        [csInfoCreateView, csMemberCreateView].forEach {
            self.addSubview($0)
        }
        
        if UserDefaults.standard.string(forKey: "CreateFlow") == "Smart" {
            csInfoCreateView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(30)
                $0.width.equalTo(60)
                $0.trailing.equalTo(csMemberCreateView.snp.leading).offset(-8)
            }
            
            csMemberCreateView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.height.equalTo(30)
                $0.width.equalTo(60)
            }
            
            let exclItemCreateView = UIImageView()
            
            exclItemCreateView.do {
                $0.image = UIImage(named: imageCase == 2 ? "ExclItemCreateActive" : "ExclItemCreateDeactive")
                $0.sizeToFit()
            }
            
            self.addSubview(exclItemCreateView)
            
            exclItemCreateView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(csMemberCreateView.snp.trailing).offset(8)
                $0.height.equalTo(30)
                $0.width.equalTo(60)
            }
        } else {
            csInfoCreateView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(self.snp.centerX).offset(-4)
                $0.height.equalTo(30)
                $0.width.equalTo(60)
            }
            
            csMemberCreateView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.snp.centerX).offset(4)
                $0.height.equalTo(30)
                $0.width.equalTo(60)
            }
        }
    }
    
    func setLeftBackButton(action: ActionType, vc: UIViewController) {
        leftButton.do {
            $0.setImage(UIImage(named: "BackIcon"), for: .normal)
            $0.imageView?.tintColor = UIColor.TextPrimary
            $0.sizeToFit()
        }
        
        self.addSubview(leftButton)
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.width.height.equalTo(30)
        }
        
        switch action {
        case .toBack:
            let backAction = UIAction { action in
                vc.navigationController?.popViewController(animated: true)
            }
            leftButton.addAction(backAction, for: .touchUpInside)
        case .toRoot:
            let backAction = UIAction { action in
                vc.navigationController?.popToRootViewController(animated: true)
            }
            leftButton.addAction(backAction, for: .touchUpInside)
        case .none:
            break
        }
    }
    
    func setRightBackButton(title: String, titleColor: UIColor, selectedColor: UIColor, vc: UIViewController) {
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
        
        let backAction = UIAction { action in
            vc.navigationController?.popViewController(animated: true)
        }
        rightButton.addAction(backAction, for: .touchUpInside)
        
        buttonState
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnable in
                guard let self = self else { return }
                rightButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)
    }
    
    func setLeftDismissButton(title: String, titleColor: UIColor, selectedColor: UIColor, vc: UIViewController) {
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
        
        let dismissAction = UIAction { action in
            vc.dismiss(animated: true)
        }
        leftButton.addAction(dismissAction, for: .touchUpInside)
    }
    
    func setRightDismissButton(title: String, titleColor: UIColor, selectedColor: UIColor, vc: UIViewController) {
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
        
        let dismissAction = UIAction { action in
            vc.dismiss(animated: true)
        }
        rightButton.addAction(dismissAction, for: .touchUpInside)
        
        buttonState
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnable in
                guard let self = self else { return }
                rightButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)
    }
    
    func setExitButton(vc: UIViewController, action: Bool) {
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
        
        if action {
            let exitAction = UIAction { action in
                vc.navigationController?.popToRootViewController(animated: true)
            }
            rightButton.addAction(exitAction, for: .touchUpInside)
        }
    }
    
    func setReceiptsButton(vc: UIViewController, action: Bool) {
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

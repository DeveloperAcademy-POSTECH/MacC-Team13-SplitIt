//
//  SPAlertController.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/05.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

enum AlertType {
    case warnNormal
    case warnWithItem(item: String)
    case confirmNormal
    case confirmWithItem(item: String)
}

protocol SPAlertDelegate { }

final class SPAlertController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    ///  subscribe하여 leftButton의 tap event를 감지할 수 있습니다. SPAlertController의 leftButton 프로퍼티의 PublishSubject 입니다.
    let leftButtonTapSubject = PublishSubject<Void>()
    ///  subscribe하여 rightButton의 tap event를 감지할 수 있습니다. SPAlertController의 rightButton 프로퍼티의 PublishSubject 입니다.
    let rightButtonTapSubject = PublishSubject<Void>()
    
    private let alertView = UIView()
    private let itemLabel = UILabel()
    private let alertTitleLabel = UILabel()
    private let alertDescriptionLabel = UILabel()
    private let leftButton = SPSquareButton(style: .primaryCalmshell)
    private let rightButton = SPSquareButton(style: .warningRed)
    
    fileprivate var item: String?
    fileprivate var alertTitle: String!
    fileprivate var alertDescription: String!
    fileprivate var leftButtonTitle: String!
    fileprivate var rightButtonTitle: String!
    fileprivate var alertType: AlertType = .confirmNormal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAttribute()
        setLayout()
    }
    
    private func setAttribute() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        alertView.do {
            $0.backgroundColor = .SurfaceDeactivate
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 2
        }
        
        itemLabel.do {
            $0.font = .KoreanSubtitle
            $0.textColor = .TextPrimary
        }
        
        alertTitleLabel.do {
            $0.text = alertTitle
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        alertDescriptionLabel.do {
            $0.text = alertDescription
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        // MARK: AlertType에 따라 itemLabel과 rightButton을 config
        switch alertType {
        case .warnNormal:
            rightButton.applyStyle(style: .warningRed)
        case .warnWithItem(let item):
            rightButton.applyStyle(style: .warningRed)
            itemLabel.text = "'\(item)'"
        case .confirmNormal:
            rightButton.applyStyle(style: .primaryWatermelon)
        case .confirmWithItem(let item):
            rightButton.applyStyle(style: .primaryWatermelon)
            itemLabel.text = "'\(item)'"
        }
        
        // MARK: 현재 leftButton은 AlertType에 관계없이 항상 (.primaryCalmshell) (23.11.05.)
        leftButton.do {
            $0.setTitle(leftButtonTitle, for: .normal)
        }
        
        rightButton.do {
            $0.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    // MARK: AlertType의 item 존재 여부에 따라 Layout을 달리 설정합니다.
    private func setLayout() {
        let alertHeight: CGFloat = getAlertHeight(type: alertType)
        let alertWidht = CGFloat(view.bounds.width - 70)
        let leadingTrailingInset = CGFloat(alertWidht * 24/320)
        let topBottomInset: CGFloat
        let itemBottomInset: CGFloat
        let alertTitleHeight: CGFloat
        let descriptionHeight: CGFloat
        let descriptionTopInset: CGFloat
        let buttonHeight = CGFloat(view.bounds.height * 48 / 844)
        let buttonWidth = CGFloat((view.bounds.width - 12 - 70 - leadingTrailingInset * 2) / 2)
        
        [alertView].forEach {
            view.addSubview($0)
        }
        
        [alertTitleLabel, alertDescriptionLabel, leftButton, rightButton].forEach {
            alertView.addSubview($0)
        }
        
        alertView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(alertHeight)
            $0.centerY.equalToSuperview().offset(-15)
        }
        
        switch alertType {
        case .warnNormal, .confirmNormal:
            topBottomInset = (alertHeight * 30/176)
            descriptionTopInset = CGFloat(alertHeight * 12/176)
            alertTitleHeight = alertHeight * 22/176
            descriptionHeight = alertHeight * 19/176
            alertTitleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(topBottomInset)
                $0.height.equalTo(alertTitleHeight)
                $0.centerX.equalToSuperview()
            }
            
            alertDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(alertTitleLabel.snp.bottom).offset(descriptionTopInset)
                $0.height.equalTo(descriptionHeight)
                $0.centerX.equalToSuperview()
            }
        case .warnWithItem, .confirmWithItem:
            let itemHeight: CGFloat = alertHeight * 22/202
            alertTitleHeight = alertHeight * 22/202
            descriptionHeight = alertHeight * 19/202
            itemBottomInset = (alertHeight * 4 / 202)
            topBottomInset = (alertHeight * 30/202)
            descriptionTopInset = CGFloat(alertHeight * 10/202)
            alertView.addSubview(itemLabel)
            
            itemLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(topBottomInset)
                $0.height.equalTo(itemHeight)
                $0.centerX.equalToSuperview()
            }
            
            alertTitleLabel.snp.makeConstraints {
                $0.top.equalTo(itemLabel.snp.bottom).offset(itemBottomInset)
                $0.height.equalTo(alertTitleHeight)
                $0.centerX.equalToSuperview()
            }
            
            alertDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(alertTitleLabel.snp.bottom).offset(descriptionTopInset)
                $0.height.equalTo(descriptionHeight)
                $0.centerX.equalToSuperview()
            }
        }

        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(leadingTrailingInset)
            $0.bottom.equalToSuperview().offset(-topBottomInset)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(buttonWidth)
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-leadingTrailingInset)
            $0.bottom.equalToSuperview().offset(-topBottomInset)
            $0.width.height.equalTo(leftButton)
        }
    }
    
    private func setBinding() {
        // MARK: 취소, 뒤로가기 등 ...
        leftButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
                self.leftButtonTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        // MARK: 삭제, 종료 등 ...
        rightButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
                self.rightButtonTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: AlertType의 item 존재 여부에 따른 alertView의 비율에 맞게 Height을 설정합니다.
    private func getAlertHeight(type: AlertType) -> CGFloat {
        switch type {
        case .warnNormal, .confirmNormal:
            return CGFloat(view.bounds.height * 176/844)
        case .warnWithItem, .confirmWithItem:
            return CGFloat(view.bounds.height * 202/844)
        }
    }
}

extension SPAlertDelegate where Self: UIViewController {
    ///아래 parameter가 적용된 SPAlertController를 present할 수 있습니다.
    func showAlert(
        view: SPAlertController,
        type: AlertType,
        title: String,
        descriptions: String,
        leftButtonTitle: String,
        rightButtonTitle: String
    ) {
        view.alertType = type
        view.alertTitle = title
        view.alertDescription = descriptions
        view.leftButtonTitle = leftButtonTitle
        view.rightButtonTitle = rightButtonTitle
        
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve
        
        self.present(view, animated: false, completion: nil)
    }
    
    func showExitAlert(
        view: SPAlertController
    ) {
        view.alertType = .warnNormal
        view.alertTitle = "정산을 종료하시겠어요?"
        view.alertDescription = "지금까지 정산하신 내역이 사라져요"
        view.leftButtonTitle = "취 소"
        view.rightButtonTitle = "종료하기"
        
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve
        
        self.present(view, animated: false, completion: nil)
    }
}

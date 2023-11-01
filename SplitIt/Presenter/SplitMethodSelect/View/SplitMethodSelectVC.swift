//
//  SplitMethodSelectVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/31.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class SplitMethodSelectVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = SplitMethodSelectVM()
    
    let header = SPNavigationBar()
    let smartSplitBorderView = UIView()
    let smartSplitImageView = UIImageView()
    let smartSplitTextLabel = UILabel()
    let smartSplitButton = NewSPButton()
    
    let equalSplitBorderView = UIView()
    let equalSplitImageView = UIImageView()
    let equalSplitTextLabel = UILabel()
    let equalSplitButton = NewSPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .selectSplitMethod, vc: self)
        }
        
        smartSplitBorderView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        smartSplitImageView.do {
            $0.image = UIImage(named: "Pictogram")
            $0.contentMode = .scaleAspectFit
        }
        
        smartSplitTextLabel.do {
            let labelText = "특정 항목에 대해서\n누군가를 제외하고 정산합니다"
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let attributedText = NSMutableAttributedString(string: labelText)
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))

            $0.attributedText = attributedText
            $0.textAlignment = .center
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
            $0.numberOfLines = 0
        }
        
        smartSplitButton.do {
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.setTitle("쓴 만큼 정산하기", for: .normal)
            $0.buttonState.accept(true)
        }
        
        equalSplitBorderView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        equalSplitImageView.do {
            $0.image = UIImage(named: "EqualSplitIconDefault")
            $0.contentMode = .scaleAspectFill
        }
        
        equalSplitTextLabel.do {
            let labelText = "인원 수 만큼,\n정확히 1/n로 정산합니다"
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let attributedText = NSMutableAttributedString(string: labelText)
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))

            $0.attributedText = attributedText
            $0.textAlignment = .center
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
            $0.numberOfLines = 0
        }
        
        equalSplitButton.do {
            $0.applyStyle(style: .primaryCalmshell, shape: .rounded)
            $0.setTitle("균등하게 나누기", for: .normal)
            $0.buttonState.accept(true)
        }
    }
    
    private func setLayout() {
        [header,smartSplitBorderView,smartSplitImageView,smartSplitTextLabel,smartSplitButton,equalSplitBorderView,equalSplitImageView,equalSplitTextLabel,equalSplitButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        smartSplitBorderView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(41)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalToSuperview().multipliedBy(0.38)
        }
        
        smartSplitImageView.snp.makeConstraints {
            $0.top.equalTo(smartSplitBorderView.snp.top).offset(21)
            $0.leading.equalTo(smartSplitBorderView).offset(90)
            $0.trailing.equalTo(smartSplitBorderView).offset(-31)
            $0.bottom.lessThanOrEqualTo(smartSplitTextLabel).offset(-16)
        }
        
        smartSplitTextLabel.snp.makeConstraints {
            $0.bottom.equalTo(smartSplitButton.snp.top).offset(-24)
            $0.centerX.equalTo(smartSplitBorderView)
        }
        
        smartSplitButton.snp.makeConstraints {
            $0.bottom.equalTo(smartSplitBorderView.snp.bottom).offset(-48)
            $0.centerX.equalTo(smartSplitBorderView)
            $0.height.equalTo(48)
            $0.width.equalTo(220)
        }
        
        equalSplitBorderView.snp.makeConstraints {
            $0.top.equalTo(smartSplitBorderView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalToSuperview().multipliedBy(0.38)
        }
        
        equalSplitImageView.snp.makeConstraints {
            $0.top.equalTo(equalSplitBorderView.snp.top).offset(51)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(equalSplitTextLabel.snp.top).offset(-16)
        }
        
        equalSplitTextLabel.snp.makeConstraints {
            $0.bottom.equalTo(equalSplitButton.snp.top).offset(-24)
            $0.centerX.equalTo(smartSplitBorderView)
        }
        
        equalSplitButton.snp.makeConstraints {
            $0.bottom.equalTo(equalSplitBorderView.snp.bottom).offset(-48)
            $0.centerX.equalTo(equalSplitBorderView)
            $0.height.equalTo(48)
            $0.width.equalTo(220)
        }
    }
    
    private func setBinding() {
        let input = SplitMethodSelectVM.Input(smartSplitButtonTapped: smartSplitButton.rx.tap,
                                              equalSplitButtonTapped: equalSplitButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.showSmartSplitCSInfoView
            .asDriver()
            .drive(onNext: {
                let vc = CSInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
                SplitRepository.share.isSmartSplit = true
            })
            .disposed(by: disposeBag)
        
        output.showEqualSplitCSInfoView
            .asDriver()
            .drive(onNext: {
                let vc = CSInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
                SplitRepository.share.isSmartSplit = false
            })
            .disposed(by: disposeBag)
    }
}

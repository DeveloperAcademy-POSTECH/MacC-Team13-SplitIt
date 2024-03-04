//
//  HomeVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/14.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

protocol HomeVCRouter {
    func showCreateFlowFromHome()
    func showSettingFlowFromHome()
}

class HomeVC: UIViewController {
    var disposeBag = DisposeBag()
    let viewModel = HomeVM()
    
    let contentView = UIView()
    let splitTitleLogo = UIImageView()
    let titleDescriptionLabel = UILabel()
    let splitImageLogo = UIImageView()
    let myInfoButton = SPButton()
    let splitItButton = SPButton()

    var router: HomeVCRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
   
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        splitTitleLogo.do {
            $0.image = UIImage(named: "SplitTitleLogo")
            $0.contentMode = .scaleAspectFit
        }
        
        titleDescriptionLabel.do {
            $0.text = "더 쉽고 편한 정산"
            $0.textColor = .TextPrimary
            $0.font = .KoreanBoldSubtitle
        }
        
        splitImageLogo.do {
            $0.image = UIImage(named: "SplitImageLogo")
            $0.contentMode = .scaleAspectFit
        }
        
        myInfoButton.do {
            $0.setImage(UIImage(named: "SplitInfoIcon"), for: .normal)
            $0.setImage(UIImage(named: "SplitInfoIcon"), for: .highlighted)
            $0.applyStyle(style: .surfaceWhite, shape: .home)
            $0.buttonState.accept(true)
        }

        splitItButton.do {
            $0.setImage(UIImage(named: "SplitBeginArrow"), for: .normal)
            $0.setImage(UIImage(named: "SplitBeginArrow"), for: .highlighted)
            $0.applyStyle(style: .primaryWatermelon, shape: .home)
            $0.buttonState.accept(true)
        }
    }

    func setLayout() {
        view.addSubview(contentView)
        [splitTitleLogo, titleDescriptionLabel, splitImageLogo, myInfoButton, splitItButton].forEach {
            contentView.addSubview($0)
        }
      
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(340)
            $0.height.equalTo(520)
        }
        
        splitTitleLogo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(splitTitleLogo.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        splitImageLogo.snp.makeConstraints {
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
        
        myInfoButton.snp.makeConstraints {
            $0.top.equalTo(splitImageLogo.snp.bottom).offset(80)
            $0.leading.equalToSuperview().inset(36)
            $0.height.equalTo(72)
            $0.width.equalTo(100)
            $0.trailing.equalTo(splitItButton.snp.leading).offset(-24)
        }

        splitItButton.snp.makeConstraints {
            $0.top.equalTo(myInfoButton)
            $0.height.equalTo(72)
            $0.width.equalTo(144)
            $0.trailing.equalToSuperview().inset(36)
        }
    }
    
    func setBinding() {
        let input = HomeVM.Input(splitItButtonTapped: splitItButton.rx.tap,
                                 myInfoButtonTapped: myInfoButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.showCreateSplit
            .drive(onNext: {
                self.router?.showCreateFlowFromHome()
            })
            .disposed(by: disposeBag)

        output.showInfoView
            .drive(onNext: {
                self.router?.showSettingFlowFromHome()
            })
            .disposed(by: disposeBag)
    }
}


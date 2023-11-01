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

class HomeVC: UIViewController {
    var disposeBag = DisposeBag()
    let viewModel = HomeVM()
    
    let myInfoButton: UIButton = UIButton()
    let historyButton: UIButton = UIButton()
    
    let mainView: UIView = UIView()
    let mainImage: UIImageView = UIImageView()
    
    let mainTextView: UIView = UIView()
    let logoImage: UIImageView = UIImageView()
    let mainTextLabel: UILabel = UILabel()
    
    let splitItButton: NewSPButton = NewSPButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setBinding() {
        let input = HomeVM.Input(splitItButtonTapped: splitItButton.rx.tap,
                                 myInfoButtonTapped: myInfoButton.rx.tap,
                                 recentSplitButtonTapped: historyButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.showCreateSplit
            .drive(onNext: {
                let vc = SplitMethodSelectVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        output.showInfoView
            .drive(onNext: {
                let vc = MyInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

       
        output.showHistoryView
            .drive(onNext: {
                let vc = HistoryVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)


    }

    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell

        myInfoButton.do {

            $0.setImage(
                UIImage(systemName: "person.fill")?
                    .applyingSymbolConfiguration(.init(pointSize: 26)), for: .normal)
            $0.tintColor = .black
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        historyButton.do {
            $0.setImage(
                UIImage(systemName: "book.fill")?
                    .applyingSymbolConfiguration(.init(pointSize: 26)), for: .normal)
            $0.tintColor = .black
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        mainView.do {
            $0.backgroundColor = .AppColorBrandWatermelon
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 50
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        mainImage.do {
            $0.image = UIImage(named: "SmartSplitIconWhite")
        }
        
        mainTextView.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 50
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            
        }
        
        logoImage.do {
            $0.image = UIImage(named: "SplitItLogo")
        }
        
        mainTextLabel.do {
            $0.text = "각자 먹고 쓴 만큼,\n똑똑하게 나누어 낼 수 있어요!"
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
            $0.numberOfLines = 0
            $0.textAlignment = .right
        }

        splitItButton.do {
            $0.setTitle("정산 시작하기", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.buttonState.accept(true)
        }
    }

    func setLayout() {
        [mainView, mainTextView, splitItButton, myInfoButton, historyButton].forEach {
            view.addSubview($0)
        }
        
        [mainTextLabel, logoImage].forEach {
            mainTextView.addSubview($0)
        }
        
        mainView.addSubview(mainImage)
        
        myInfoButton.snp.makeConstraints {
            $0.bottom.equalTo(mainView.snp.top).offset(-8)
            $0.width.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-63)
        }
        
        historyButton.snp.makeConstraints {
            $0.trailing.equalTo(myInfoButton.snp.leading).offset(-8)
            $0.centerY.equalTo(myInfoButton.snp.centerY)
            $0.width.height.equalTo(40)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(104)
            $0.horizontalEdges.equalToSuperview().inset(55)
            $0.bottom.equalToSuperview().offset(-406)
        }
        
        mainImage.snp.makeConstraints { 
            $0.center.equalToSuperview()
            $0.size.equalTo(90)
        }
        
        mainTextView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom).offset(-1)
            $0.horizontalEdges.equalToSuperview().inset(55)
            $0.bottom.equalToSuperview().offset(-206)
        }
        
        logoImage.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(92)
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mainTextLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        splitItButton.snp.makeConstraints {
            $0.top.equalTo(mainTextView.snp.bottom).offset(24)
            $0.height.equalTo(48)
            $0.width.equalTo(220)
            $0.centerX.equalToSuperview()
        }
    }
}


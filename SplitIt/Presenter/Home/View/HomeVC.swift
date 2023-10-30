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

// MARK: HomeVC는 모두 수정 예정
// HomeVC의 각 Button의 observer 부분에 작업할 VC를 연결하여 사용해주세요

class HomeVC: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = HomeVM()
    
    let buttonView: UIView = UIView()
    let myInfoButton: NewSPButton = NewSPButton()
    let myInfoButtonImage: UIImageView = UIImageView()
    
    let mainView: UIView = UIView()
    let mainImage: UIImageView = UIImageView()
    
    let mainTextView: UIView = UIView()
    let logoImage: UIImageView = UIImageView()
    let mainTextLabel: UILabel = UILabel()
    
    let splitItButton: NewSPButton = NewSPButton()
    let historyButton: NewSPButton = NewSPButton()
    let historyButtonImage: UIImageView = UIImageView()

    
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
//                let vc = CSTitleInputVC()
                let vc = CSInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        output.showInfoView
            .drive(onNext: {
                // MARK: 모아나가 연결할 뷰로 수정
                //let vc = TestVC()
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
        buttonView.backgroundColor = .SurfaceBrandCalmshell

        myInfoButton.do {
    
            $0.applyStyle(style: .primaryCalmshell, shape: .square)
            $0.buttonState.accept(true)
        }
        
        myInfoButtonImage.do {
            $0.image = UIImage(systemName:"person.fill")
            $0.tintColor = UIColor.black
        }
        
        historyButton.do {
            $0.applyStyle(style: .primaryCalmshell, shape: .square)
            $0.buttonState.accept(true)

        }
    
        historyButtonImage.do {
            $0.image = UIImage(systemName: "book.fill")
            $0.tintColor = UIColor.black
        }
        

        mainView.do {
            $0.backgroundColor = .AppColorBrandWatermelon
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 50
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.black.cgColor
            
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
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
            
        }
        
        logoImage.do {
            $0.image = UIImage(named: "SplitItLogo")
            $0.tintColor = UIColor.black
        }
        
        mainTextLabel.do {
            $0.text = "각자 먹고 쓴 만큼,\n똑똑하게 나누어 낼 수 있어요!"
            $0.font = .KoreanCaption1
            $0.textColor = UIColor.black
            $0.numberOfLines = 0
            $0.textAlignment = .right
        }

        splitItButton.do {
            $0.setTitle("정산 시작하기", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.buttonState.accept(true)
        }
        
       
    }
    
//    func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: size)
//        let image = renderer.image { context in
//            color.setFill()
//            context.fill(CGRect(origin: .zero, size: size))
//        }
//        return image
//    }


    func setLayout() {
        [mainView, mainTextView, splitItButton, buttonView].forEach {
            view.addSubview($0)
        }
        [mainTextLabel, logoImage].forEach {
            mainTextView.addSubview($0)
        }
        
        [myInfoButton, historyButton].forEach {
            buttonView.addSubview($0)
        }
        
        myInfoButton.addSubview(myInfoButtonImage)
        historyButton.addSubview(historyButtonImage)
        mainView.addSubview(mainImage)
        
        
        
        buttonView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(280)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
        }
        
        myInfoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview().offset(8)
        }
        
        myInfoButtonImage.snp.makeConstraints {
            $0.width.equalTo(26)
            $0.height.equalTo(28)
            $0.center.equalToSuperview()
   
        }
        
        historyButton.snp.makeConstraints {
            $0.leading.equalTo(myInfoButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        historyButtonImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(29)
            $0.height.equalTo(24)
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(158)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(280)
        }
        
        mainImage.snp.makeConstraints { 
            $0.center.equalToSuperview()
            
        }
        
        logoImage.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(92)
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mainTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(437)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(200)
        }
        
        
        mainTextLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        splitItButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-134)
            $0.height.equalTo(48)
            $0.width.equalTo(220)
            $0.centerX.equalToSuperview()
        }
        
    }
}


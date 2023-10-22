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
///
/// HomeVC의 각 Button의 observer 부분에 작업할 VC를 연결하여 사용해주세요
///
class HomeVC: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = HomeVM()
    
    let myInfoButton: UIButton = UIButton()
    let myInfoButtonImage: UIImageView = UIImageView()
    
    let mainImage: UIView = UIView()
    let mainTextView: UIView = UIView()
    
    let logoImage: UIImageView = UIImageView()
    let mainTextLabel: UILabel = UILabel()
   // let subTextLabel: UILabel = UILabel()
    
    let splitItButton: UIButton = UIButton()
   // let devider: UIView = UIView()
   // let recentSplitTextLabel: UILabel = UILabel()
       // let historyButtonLabel: UILabel = UILabel()
    let historyButton: UIButton = UIButton()
    let historyButtonImage: UIImageView = UIImageView()
    //let recentSplitCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
                let vc = CSTitleInputVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showMoanaView
            .drive(onNext: {
                // MARK: 모아나가 연결할 뷰로 수정
                let vc = MyInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        output.showJerryView
            .drive(onNext: {
                // MARK: 제리가 연결할 뷰로 수정
                print("제리뷰 이동 & 히스토리뷰 이동") // 수정 후 삭제
//                let vc = HomeVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setAttribute() {
        view.backgroundColor = .systemBackground
        
        myInfoButton.do {
//            $0.setImage(UIImage(systemName: "person.fill",
//                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 26, weight: .regular)), for: .normal)
//            $0.tintColor = UIColor.black
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        myInfoButtonImage.do {
            $0.image = UIImage(systemName:"person.fill")
            $0.tintColor = UIColor.black
        }
        
        historyButton.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        historyButtonImage.do {
            $0.image = UIImage(systemName: "book.fill")
            $0.tintColor = UIColor.black
        }
        

        mainImage.do {
            $0.backgroundColor = UIColor.systemGreen
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 50
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.black.cgColor
            
            $0.layer.borderWidth = 1
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
            $0.image = UIImage(systemName: "snowflake")
            $0.tintColor = UIColor.black
        }
//        mainTextView.do {
//            $0.frame = CGRect(x: 0, y: 0, width: 280, height: 200)
//            $0.backgroundColor = UIColor.systemBlue
//            let bottomRoundedPath = UIBezierPath(roundedRect: $0.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
//                let maskLayer = CAShapeLayer()
//                maskLayer.path = bottomRoundedPath.cgPath
//                $0.layer.mask = maskLayer
//
//
//
//        }
        
        mainTextLabel.do {
            $0.text = "각자 먹고 쓴 만큼,\n똑똑하게 나누어 낼 수 있어요!"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor.black
            $0.numberOfLines = 0
            $0.textAlignment = .right
        }
        
//        subTextLabel.do {
//            $0.text = "스플리릿 시간입니다!"
//            $0.font = UIFont.systemFont(ofSize: 21)
//            $0.textColor = UIColor.black
//        }
        
        splitItButton.do {
            $0.setTitle("나의 영수증 만들기", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.backgroundColor = UIColor.systemGreen
            $0.layer.cornerRadius = 24
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
//        devider.do {
//            $0.backgroundColor = UIColor.gray
//            $0.layer.opacity = 0.3
//        }
        
//        recentSplitTextLabel.do {
//            $0.text = "최근 스플리릿 내역"
//            $0.font = UIFont.systemFont(ofSize: 21)
//            $0.textColor = UIColor.black
//        }
        
//        historyButtonLabel.do {
//            $0.text = "더보기"
//            $0.font = UIFont.systemFont(ofSize: 12)
//            $0.textColor = UIColor.black
//        }
        
        
       
    }

    func setLayout() {
        [myInfoButton, mainImage, mainTextView, splitItButton,  historyButton].forEach {
            view.addSubview($0)
        }
        //recentSplitTextLabel,devider, recentSplitCollectionView, subTextLabel,
        
        myInfoButton.addSubview(myInfoButtonImage)
       //historyButton.addSubview(historyButtonLabel)
        historyButton.addSubview(historyButtonImage)
        [mainTextLabel, logoImage].forEach {
            mainTextView.addSubview($0)
        }
        
        
        myInfoButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview().inset(63)
        }
        
        myInfoButtonImage.snp.makeConstraints {
            $0.width.equalTo(26)
            $0.height.equalTo(28)
            $0.center.equalToSuperview()
            
            
        }
        
        historyButton.snp.makeConstraints {
            $0.left.equalTo(111)
            $0.top.equalToSuperview().offset(110)
            $0.width.height.equalTo(40)
        }
        
        historyButtonImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(29)
            $0.height.equalTo(24)
        }
        
        mainImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(158)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(280)
        }
        logoImage.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(92)
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        mainTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(437)
            $0.center.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(200)
        }
        
        
        mainTextLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
//        subTextLabel.snp.makeConstraints {
//            $0.top.equalTo(mainTextLabel.snp.bottom).offset(4)
//            $0.centerX.equalToSuperview()
//        }
        
        splitItButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-134)
            $0.height.equalTo(48)
            $0.width.equalTo(220)
            $0.centerX.equalToSuperview()
        }
        
//        devider.snp.makeConstraints {
//            $0.bottom.equalTo(recentSplitTextLabel.snp.top).offset(-16.5)
//            $0.horizontalEdges.equalToSuperview().inset(25)
//            $0.height.equalTo(1)
//        }
        
//        recentSplitTextLabel.snp.makeConstraints {
//            $0.bottom.equalTo(recentSplitCollectionView.snp.top).offset(-8.5)
//            $0.leading.equalToSuperview().inset(30)
//        }
//
       
//        historyButtonLabel.snp.makeConstraints {
//            $0.trailing.equalTo(historyButtonImage.snp.leading).offset(-8)
//            $0.centerY.equalToSuperview()
//        }
        
//        recentSplitCollectionView.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
//            $0.horizontalEdges.equalToSuperview().inset(30)
//            $0.height.equalTo(94)
//        }
    }
}


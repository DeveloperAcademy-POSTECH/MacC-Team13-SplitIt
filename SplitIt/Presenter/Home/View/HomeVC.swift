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
    let mainImage: UIView = UIView()
    let mainTextLabel: UILabel = UILabel()
    let subTextLabel: UILabel = UILabel()
    let splitItButton: UIButton = UIButton()
    let devider: UIView = UIView()
    let recentSplitTextLabel: UILabel = UILabel()
    let historyButton: UIButton = UIButton()
    let historyButtonLabel: UILabel = UILabel()
    let historyButtonImage: UIImageView = UIImageView()
    let recentSplitCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
                print("제리뷰 이동") // 수정 후 삭제
//                let vc = HomeVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setAttribute() {
        view.backgroundColor = .systemBackground
        
        myInfoButton.do {
            $0.setImage(UIImage(systemName: "person.circle.fill",
                                withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 40))), for: .normal)
            $0.tintColor = UIColor.gray
        }
        
        mainImage.do {
            $0.backgroundColor = UIColor.blue
        }
        
        mainTextLabel.do {
            $0.text = "혹시... 카드 긁으셨나요?"
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textColor = UIColor.black
        }
        
        subTextLabel.do {
            $0.text = "스플리릿 시간입니다!"
            $0.font = UIFont.systemFont(ofSize: 21)
            $0.textColor = UIColor.black
        }
        
        splitItButton.do {
            $0.setTitle("♦ Split it!", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.backgroundColor = UIColor.green
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        devider.do {
            $0.backgroundColor = UIColor.gray
            $0.layer.opacity = 0.3
        }
        
        recentSplitTextLabel.do {
            $0.text = "최근 스플리릿 내역"
            $0.font = UIFont.systemFont(ofSize: 21)
            $0.textColor = UIColor.black
        }
        
        historyButtonLabel.do {
            $0.text = "더보기"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.black
        }
        
        historyButtonImage.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.black
        }
    }

    func setLayout() {
        [myInfoButton, mainImage, mainTextLabel, subTextLabel, splitItButton, devider, recentSplitTextLabel, historyButton, recentSplitCollectionView].forEach {
            view.addSubview($0)
        }
        
        historyButton.addSubview(historyButtonLabel)
        historyButton.addSubview(historyButtonImage)
        
        myInfoButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(62)
            $0.width.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        mainImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(165)
        }
        
        mainTextLabel.snp.makeConstraints {
            $0.top.equalTo(mainImage.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        subTextLabel.snp.makeConstraints {
            $0.top.equalTo(mainTextLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        splitItButton.snp.makeConstraints {
            $0.top.equalTo(subTextLabel.snp.bottom).offset(24)
            $0.height.equalTo(48)
            $0.width.equalTo(130)
            $0.centerX.equalToSuperview()
        }
        
        devider.snp.makeConstraints {
            $0.bottom.equalTo(recentSplitTextLabel.snp.top).offset(-16.5)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(1)
        }
        
        recentSplitTextLabel.snp.makeConstraints {
            $0.bottom.equalTo(recentSplitCollectionView.snp.top).offset(-8.5)
            $0.leading.equalToSuperview().inset(30)
        }
        
        historyButton.snp.makeConstraints {
            $0.centerY.equalTo(recentSplitTextLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        historyButtonImage.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(13.8)
        }
        
        historyButtonLabel.snp.makeConstraints {
            $0.trailing.equalTo(historyButtonImage.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        recentSplitCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(94)
        }
    }
}


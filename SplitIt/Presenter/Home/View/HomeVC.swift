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
    
    let button1: UIButton = UIButton()
    let button2: UIButton = UIButton()
    let button3: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setBinding() {
        let input = HomeVM.Input(wanButtonTapped: button1.rx.tap,
                                 moanaButtonTapped: button2.rx.tap,
                                 jerryButtonTapped: button3.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.showWanView
            .drive(onNext: {
                let vc = CSTitleInputVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showMoanaView
            .drive(onNext: {
                // MARK: 모아나가 연결할 뷰로 수정
                print("모아나뷰 이동") // 수정 후 삭제
//                let vc = HomeVC()
//                self.navigationController?.pushViewController(vc, animated: true)
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
        
        button1.do {
            $0.setTitle("완 작업하는 뷰로 이동", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
        
        button2.do {
            $0.setTitle("모아나 작업하는 뷰로 이동", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
        
        button3.do {
            $0.setTitle("제리 작업하는 뷰로 이동", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
    }

    func setLayout() {
        [button1, button2, button3].forEach {
            view.addSubview($0)
        }
        
        button1.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(48)
        }
        
        button2.snp.makeConstraints {
            $0.top.equalTo(button1.snp.bottom).offset(20)
            $0.centerX.equalTo(button1.snp.centerX)
            $0.width.equalTo(300)
            $0.height.equalTo(48)
        }
        
        button3.snp.makeConstraints {
            $0.top.equalTo(button2.snp.bottom).offset(20)
            $0.centerX.equalTo(button1.snp.centerX)
            $0.width.equalTo(300)
            $0.height.equalTo(48)
        }
    }
}


//
//  AccountAlertVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.
//


import UIKit
import RxSwift
import SnapKit
import Then


class AccountAlertVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let alertView = UIView()
    
    let textView = UIView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    let nextButton = SPButton()
    let inputButton = SPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        setLayout()
        setAttribute()
        buttonAction()
        
    }
    
    func setAttribute() {
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        alertView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.layer.cornerRadius = 8
        }
        
        textView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
        }
        
        
        titleLabel.do {
            $0.text = "계좌 정보를 입력하시겠어요?"
            $0.textAlignment = .center
            $0.font = .KoreanBody
            
        }
        
        subLabel.do {
            $0.text = "친구들에게 입금받을 계좌를 알려주세요"
            $0.textAlignment = .center
            $0.font = .KoreanCaption2
            
        }
        
        nextButton.do {
            $0.setTitle("다음에", for: .normal)
            $0.applyStyle(.squarePrimaryCalmshell)
            
        }
        
        inputButton.do {
            $0.setTitle("입력하기", for: .normal)
            $0.applyStyle(.squarePrimaryWatermelon)
        }
    }
    
    
    func setLayout() {
        
        alertView.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(168)
            $0.top.equalToSuperview().offset(300)
            $0.centerX.equalToSuperview()
        }
        textView.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(43)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
        }
        
        inputButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
        }
        
    }
    
    func addView() {
        [alertView].forEach {
            view.addSubview($0)
        }
        
        [textView, nextButton, inputButton].forEach{
            alertView.addSubview($0)
        }
        
        [titleLabel, subLabel].forEach{
            textView.addSubview($0)
        }
    }
    
    func buttonAction() {
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
                print("취소버튼")
            }
            .disposed(by: disposeBag)
        
        
        inputButton.rx.tap
            .bind { [weak self] in
               // self?.dismiss(animated: true, completion: {
                    print("dddd")
                    let myBankAccountVC = MyBankAccountVC()
                    self?.navigationController?.pushViewController(myBankAccountVC, animated: true)
                    
               // }
        
            }
            .disposed(by: disposeBag)
            
    }
    
}

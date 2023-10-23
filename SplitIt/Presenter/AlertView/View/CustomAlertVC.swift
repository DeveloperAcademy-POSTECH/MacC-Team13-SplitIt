//
//  CustomAlertVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.
//


import UIKit
import RxSwift
import SnapKit
import Then


class CustomAlertVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let alertView = UIView()
    
    let textView = UIView()
    let itemLabel = UILabel()
    let titleLabel = UILabel()
    let warningLabel = UILabel()
    
    let cancelButton = SPButton()
    let deleteButton = SPButton()
    
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
        
        itemLabel.do {
            $0.text = "'술 값'" //data에서 받아 온 값으로 처리
            $0.textAlignment = .center
            $0.font = .KoreanSubtitle
            
        }
        
        titleLabel.do {
            $0.text = "항목을 삭제할까요?"
            $0.textAlignment = .center
            $0.font = .KoreanBody
            
        }
        
        warningLabel.do {
            $0.text = "* 이 작업은 돌이킬 수 없습니다."
            $0.textAlignment = .center
            $0.font = .KoreanCaption2
            
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.applyStyle(.squarePrimaryCalmshell)
            
        }
        
        deleteButton.do {
            $0.setTitle("삭제", for: .normal)
            $0.applyStyle(.squareWarningRed)
        }
    }
    
    
    func setLayout() {
        
        alertView.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(200)
            $0.top.equalToSuperview().offset(300)
            $0.centerX.equalToSuperview()
        }
        textView.snp.makeConstraints {
            $0.width.equalTo(282)
            $0.height.equalTo(73)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        }
        
        itemLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(itemLabel.snp.bottom).offset(4)
        }
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        cancelButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
        }
        
        deleteButton.snp.makeConstraints {
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
        
        [textView, deleteButton, cancelButton].forEach{
            alertView.addSubview($0)
        }
        
        [itemLabel, titleLabel, warningLabel].forEach{
            textView.addSubview($0)
        }
    }
    
    func buttonAction() {
        
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
                print("취소버튼")
            }
            .disposed(by: disposeBag)
        
        
        deleteButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
                print("삭제버튼")
            }
            .disposed(by: disposeBag)
            
    }
    
}

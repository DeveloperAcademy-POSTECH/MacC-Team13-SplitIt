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


class MyInfoDeleteAlertVC: UIViewController {
    
    weak var delegate: MyInfoDeleteAlertVCDelegate?
    weak var deleteBtnDelegate: MyInfoPressedBtnDelegate?
    let disposeBag = DisposeBag()
    
    let alertView = UIView()
    let textView = UIView()
    let itemLabel = UILabel()
    let titleLabel = UILabel()
    let warningLabel = UILabel()
    
    let cancelButton = SPButton()
    let deleteBtn = SPButton()


    override func viewDidLoad() {
        super.viewDidLoad()

        addView()
        setLayout()
        setAttribute()
        buttonAction()
        
    }
    
    
    func buttonAction() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: false)
                print("취소버튼")
            }
            .disposed(by: disposeBag)

        
        deleteBtn.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.delegate?.deleteAllInfo()
                self?.deleteBtnDelegate?.newLayout()
                //self?.dismiss(animated: false)
                self?.dismiss(animated: false, completion: {
                    if let myInfoVC = self?.presentingViewController as? MyInfoVC {
                        myInfoVC.viewWillAppear(false) // 수동으로 viewWillAppear 호출
                    }
                })
            })
            .disposed(by: disposeBag)
    }

    
    func setAttribute() {
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        alertView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
        }
        
        textView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
        }
        
        
        titleLabel.do {
            $0.text = "나의 정보를 초기화 하시겠어요?"
            $0.textAlignment = .center
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
            
        }
        
        warningLabel.do {
            $0.text = "이 작업은 돌이킬 수 없어요"
            $0.textAlignment = .center
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
            
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.applyStyle(.squarePrimaryCalmshell)
            
        }
        
        deleteBtn.do {
            $0.setTitle("초기화", for: .normal)
            $0.applyStyle(.squareWarningRed)
        }
    }
    
    
    func setLayout() {
        
        alertView.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(176)
            $0.top.equalToSuperview().offset(300)
            $0.centerX.equalToSuperview()
        }
        textView.snp.makeConstraints {
            $0.width.equalTo(240)
            $0.height.equalTo(51)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
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
        
        deleteBtn.snp.makeConstraints {
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
        
        [textView, deleteBtn, cancelButton].forEach{
            alertView.addSubview($0)
        }
        
        [itemLabel, titleLabel, warningLabel].forEach{
            textView.addSubview($0)
        }
    }


}



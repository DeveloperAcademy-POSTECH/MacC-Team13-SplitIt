//
//  ExcltemInfoModalAlertVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/01.
//

import UIKit
import RxSwift
import SnapKit
import Then


protocol ExcltemInfoModalAlertDelegate: AnyObject {
    func didDeleteItem(exclItemIdx: String)
}

class ExcltemInfoModalAlertVC: UIViewController {
    
    weak var delegate: ExcltemInfoModalAlertDelegate?
    var idx: String?
    var titleValue: String?
    
    var deleteAction: (() -> Void)?

    let disposeBag = DisposeBag()
    let alertView = UIView()
    let textView = UIView()
    let itemLabel = UILabel()
    let titleLabel = UILabel()
    let warningLabel = UILabel()
    
    let cancelButton = SPSquareButton()
    let deleteBtn = SPSquareButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAttribute()
        setLayout()
        buttonAction()
    }
    
    func buttonAction() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        deleteBtn.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: {
                    if let idx = self?.idx {
                        self?.delegate?.didDeleteItem(exclItemIdx: idx)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        alertView.do {
            $0.backgroundColor = .SurfaceDeactivate
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 8
        }
        
        textView.do {
            $0.backgroundColor = .SurfaceDeactivate
        }
        
        itemLabel.do {
            $0.text = "\(titleValue ?? "제목 없음")"
            $0.textColor = .TextPrimary
            $0.textAlignment = .center
            $0.font = .KoreanSubtitle
        }
        
        titleLabel.do {
            $0.text = "항목을 삭제할까요?"
            $0.textColor = .TextPrimary
            $0.textAlignment = .center
            $0.font = .KoreanBody
        }
        
        warningLabel.do {
            $0.text = "이 작업은 돌이킬 수 없습니다"
            $0.textColor = .TextSecondary
            $0.textAlignment = .center
            $0.font = .KoreanCaption2
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.applyStyle(style: .primaryCalmshell)
        }
        
        deleteBtn.do {
            $0.setTitle("삭제하기", for: .normal)
            $0.applyStyle(style: .warningRed)
        }
    }
    
    func setLayout() {
        [alertView].forEach {
            view.addSubview($0)
        }
        
        [textView, deleteBtn, cancelButton].forEach{
            alertView.addSubview($0)
        }
        
        [itemLabel, titleLabel, warningLabel].forEach{
            textView.addSubview($0)
        }
        
        alertView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(200)
            $0.centerY.equalToSuperview().offset(-30)
            $0.centerX.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(77)
            $0.centerX.equalToSuperview()
        }
        
        itemLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.top.equalTo(itemLabel.snp.bottom).offset(4)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
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
}

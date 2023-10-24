//
//  ExclItemPriceInputVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol ExclItemPricePageChangeDelegate: AnyObject {
    func changePageToThirdView()
}

class ExclItemPriceInputVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclItemPriceInputVM()
    
    weak var pageChangeDelegate: ExclItemPricePageChangeDelegate?
    
    let titleMessage = UILabel()
    let priceTextField = SPTextField()
    let textFiledNotice = UILabel()
    let nextButton = SPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        titleMessage.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        priceTextField.do {
            $0.applyStyle(.number)
            $0.font = .KoreanTitle3
        }
        
        textFiledNotice.do {
            $0.text = "이 값은 전체 총액을 넘을 수는 없어요"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
        }
    }
    
    func setLayout() {
        [titleMessage,priceTextField,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclItemPriceInputVM.Input(nextButtonTapped: nextButton.rx.tap.asDriver(),
                                               price: priceTextField.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.title
            .map(viewModel.mapTitleMessage)
            .drive(titleMessage.rx.text)
            .disposed(by: disposeBag)
        
        output.totalAmount
            .drive(priceTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.totalAmount
            .distinctUntilChanged()
            .drive(onNext: { [weak self] str in
                guard let self = self else { return }
                self.nextButton.applyStyle(str == "0" ? .deactivate : .primaryPear)
            })
            .disposed(by: disposeBag)
        
        output.showExclItemTargetView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPearPressed)
                pageChangeDelegate?.changePageToThirdView()
            })
            .disposed(by: disposeBag)
        
        output.showExclItemTargetView
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPear)
            })
            .disposed(by: disposeBag)
    }
}

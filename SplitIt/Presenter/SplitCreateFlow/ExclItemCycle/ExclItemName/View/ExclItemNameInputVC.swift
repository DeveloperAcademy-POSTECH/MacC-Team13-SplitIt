//
//  ExclItemNameInputVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol ExclItemNamePageChangeDelegate: AnyObject {
    func changePageToSecondView()
}

class ExclItemNameInputVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclItemNameInputVM()
    
    weak var pageChangeDelegate: ExclItemNamePageChangeDelegate?
    
    let titleMessage = UILabel()
    let nameTextFiled = SPTextField()
    let textFiledCounter = UILabel()
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
            $0.text = "따로 계산할 것은 무엇인가요?"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        nameTextFiled.do {
            $0.applyStyle(.elseValue)
            $0.font = .KoreanTitle3
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        textFiledNotice.do {
            $0.text = "ex) 술, 삼겹살, 마라샹궈, 오이냉국"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        textFiledCounter.do {
            $0.font = .KoreanCaption2
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
        }
    }
    
    func setLayout() {
        [titleMessage,nameTextFiled,textFiledCounter,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        nameTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(nameTextFiled.snp.bottom).offset(6)
            $0.trailing.equalTo(nameTextFiled.snp.trailing).inset(6)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(nameTextFiled.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclItemNameInputVM.Input(nextButtonTapped: nextButton.rx.tap,
                                              name: nameTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.showExclItemPriceView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPearPressed)
                pageChangeDelegate?.changePageToSecondView()
            })
            .disposed(by: disposeBag)
        
        output.showExclItemPriceView
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPear)
            })
            .disposed(by: disposeBag)
        
        output.nameCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.nameCount
            .distinctUntilChanged()
            .drive(onNext: { str in
                guard let count = str.first else { return }
                self.nextButton.applyStyle(count == "0" ? .deactivate : .primaryPear)
            })
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? .TextSecondary
                : .AppColorStatusError
            })
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .map { [weak self] isValid -> String in
                guard let self = self else { return "" }
                if !isValid {
                    return String(self.nameTextFiled.text?.prefix(self.viewModel.maxTextCount) ?? "")
                } else {
                    return self.nameTextFiled.text ?? ""
                }
            }
            .drive(nameTextFiled.rx.text)
            .disposed(by: disposeBag)
    }
}

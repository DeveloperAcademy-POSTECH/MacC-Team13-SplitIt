//
//  ExclItemNameEditVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class ExclItemNameEditVC: UIViewController {
    
    var disposeBag = DisposeBag()
    let viewModel: ExclItemNameEditVM
    
    let header = NavigationHeader()
    let titleMessage = UILabel()
    let nameTextFiled = UITextField()
    let nameTextSuffix = UILabel()
    let textFiledCounter = UILabel()
    let textFiledNotice = UILabel()
    let nextButton = SPButton()
    
    init(viewModel: ExclItemNameEditVM) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardNotification()
        self.nameTextFiled.becomeFirstResponder()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.configureTitle(title: "모임 수정하기")
            $0.configureBackButton(viewController: self)
        }
        
        titleMessage.do {
            $0.text = "어떤 이름으로 바꿔볼까요?"
            $0.tintColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        nameTextFiled.do {
            $0.font = .KoreanTitle3
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 24)
        }
        
        nameTextSuffix.do {
            $0.text = "값"
            $0.font = .systemFont(ofSize: 15)
        }
        
        textFiledNotice.do {
            $0.text = "여기에 사용을 돕는 문구가 들어가요"
            $0.font = .systemFont(ofSize: 12)
        }
        
        nextButton.do {
            $0.setTitle("저장하기", for: .normal)
            $0.applyStyle(.primaryPear)
        }
    }
    
    func setLayout() {
        [header,titleMessage,nameTextFiled,textFiledCounter,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        nameTextFiled.addSubview(nameTextSuffix)
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        nameTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        nameTextSuffix.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclItemNameEditVM.Input(nextButtonTapped: nextButton.rx.tap,
                                              name: nameTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.showExclItemPriceView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPearPressed)
                let vc = ExclItemPriceEditVC(viewModel: ExclItemPriceEditVM(indexPath: viewModel.indexPath))
                self.navigationController?.pushViewController(vc, animated: false)
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
        
        output.textFieldIsValid
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? UIColor(hex: 0xCCCCCC)
                : UIColor(hex: 0xFF3030)
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
        
        output.exclTitle
            .bind(to: nameTextFiled.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ExclItemNameEditVC: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.nextButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 26)
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
}


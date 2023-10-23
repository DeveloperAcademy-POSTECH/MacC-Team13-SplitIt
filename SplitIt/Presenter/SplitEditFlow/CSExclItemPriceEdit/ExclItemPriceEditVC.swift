//
//  CSExclItemPriceVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class ExclItemPriceEditVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel: ExclItemPriceEditVM
    weak var pageChangeDelegate: ExclItemPricePageChangeDelegate?
    
    let header = NaviHeader()
    let titleMessage = UILabel()
    let priceTextField = UITextField()
    let currencyLabel = UILabel()
    let textFiledNotice = UILabel()
    let nextButton = SPButton()
    
    init(viewModel: ExclItemPriceEditVM) {
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
        self.priceTextField.becomeFirstResponder()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.applyStyle(.edit)
        }
        
        titleMessage.do {
            $0.font = .KoreanBody
        }
        
        priceTextField.do {
            $0.font = .KoreanTitle3
            $0.keyboardType = .numberPad
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 24)
        }
        
        currencyLabel.do {
            $0.text = "KRW"
            $0.font = .KoreanCaption1
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
        [header,titleMessage,priceTextField,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        priceTextField.addSubview(currencyLabel)
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclItemPriceEditVM.Input(nextButtonTapped: nextButton.rx.tap.asDriver(),
                                               price: priceTextField.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.title
            .map(viewModel.mapTitleMessage)
            .drive(titleMessage.rx.text)
            .disposed(by: disposeBag)
        
        output.totalAmount
            .drive(priceTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.showExclItemTargetView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let index = viewModel.indexPath else { return }
                self.nextButton.applyStyle(.primaryPearPressed)
                let vc = ExclMemberEditVC(viewModel: ExclMemberEditVM(index: index))
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showExclItemTargetView
            .delay(.milliseconds(500))
           .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
               self.nextButton.applyStyle(.primaryPear)
            })
            .disposed(by: disposeBag)
        
        output.exclPrice
            .bind(to: priceTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ExclItemPriceEditVC: UITextFieldDelegate {
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


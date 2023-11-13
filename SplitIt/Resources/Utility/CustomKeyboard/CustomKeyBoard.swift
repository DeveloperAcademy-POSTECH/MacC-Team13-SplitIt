//
//  CustomKeyBoard.swift
//  SplitIt
//
//  Created by cho on 2023/10/26.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then


protocol CustomKeyboardDelegate: AnyObject {
    
}

enum KeyboardOption: String {
    case price = "00"
    case account = "-"
}

class CustomKeyboard: UIInputViewController {
    
    weak var delegate: CustomKeyboardDelegate?
    var currentTextField: UITextField?
    
    let inputRelay = BehaviorRelay<Int?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private let customKeySubject = PublishSubject<String>()
    var keyboardHeight = KeyboardButton.getKeyboardHeightForCurrentDevice()

    
    var customKeyObservable: Observable<String> {
        return customKeySubject.asObservable()
    }
    
    var keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 291))
    
    let btn1 = KeyboardButton(title: "1")
    let btn2 = KeyboardButton(title: "2")
    let btn3 = KeyboardButton(title: "3")
    let btn4 = KeyboardButton(title: "4")
    let btn5 = KeyboardButton(title: "5")
    let btn6 = KeyboardButton(title: "6")
    let btn7 = KeyboardButton(title: "7")
    let btn8 = KeyboardButton(title: "8")
    let btn9 = KeyboardButton(title: "9")
    let btn0 = KeyboardButton(title: "0")
    var optionBtn = KeyboardButton(title: "")
    let deleteButton = KeyboardButton(title: " ")
    let deleteImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: keyboardHeight))
        view.backgroundColor = UIColor(hex: 0xCED0D5)
        
        setAttribute()
        setAddView()
        setKeyLayout()
        setBinding()
        bindDeleteButtonLongPress()
        
    }
    
    func applyOption(_ option: KeyboardOption) {
        //let font = UIFont(name: "YourFontName", size: 16.0) // 원하는 폰트 이름과 크기로 설정
        optionBtn.titleLabel?.font = UIFont.KoreanTitle2
        optionBtn.setTitle(option.rawValue, for: .normal)
        bindButtonAction(optionBtn, value: option.rawValue)

       }
    
    func setAttribute() {
        
        let inputView = UIInputView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: keyboardHeight), inputViewStyle: .keyboard)
        inputView.backgroundColor = UIColor(hex: 0xFCFCFE)
        self.inputView = inputView
        
        keyboardView.backgroundColor = UIColor(hex: 0xCED0D5)
        inputView.addSubview(keyboardView)
        
        deleteButton.do {
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
        }
        
        deleteImage.do {
            $0.image = UIImage(systemName: "delete.left")
            $0.tintColor = UIColor.black
            $0.contentMode = .scaleAspectFit
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        [btn0,btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,optionBtn].forEach {
            $0.layer.masksToBounds = false
            $0.layer.shadowRadius = 0
            $0.layer.shadowOpacity = 1
            $0.layer.shadowColor = UIColor(hex: 0x898A8D).cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        }

    }
    
    func setCurrentTextField(_ textField: UITextField) {
        currentTextField = textField
    }
  
    
    func handleInputValue(_ value: String) {
        guard let textField = currentTextField else { return }
        if value == "del" {
            if var text = textField.text, !text.isEmpty {
                text.removeLast()
                textField.text = text
                textField.sendActions(for: .editingChanged)
            }
        } else {
            if var text = textField.text {
                text += value
                textField.text = text
                textField.sendActions(for: .editingChanged)
            }
        }
    }
    
    
    func setAddView() {
        
        [btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btn0, optionBtn, deleteButton].forEach {
            keyboardView.addSubview($0)
        }
        deleteButton.addSubview(deleteImage)
    }
    
    func setBinding() {
        
        bindButtonAction(btn1, value: "1")
        bindButtonAction(btn2, value: "2")
        bindButtonAction(btn3, value: "3")
        bindButtonAction(btn4, value: "4")
        bindButtonAction(btn5, value: "5")
        bindButtonAction(btn6, value: "6")
        bindButtonAction(btn7, value: "7")
        bindButtonAction(btn8, value: "8")
        bindButtonAction(btn9, value: "9")
        bindButtonAction(btn0, value: "0")
       bindButtonAction(optionBtn, value: "")
        bindButtonAction(deleteButton, value: "del")
        
    }
    
    func setKeyLayout() {
        
        btn1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(6)
        }
        
        btn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        
        btn3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(6)
        }
    
        btn4.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(btn1.snp.bottom).offset(6)
        }
        
        btn5.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.snp.bottom).offset(6)
        }
        
        btn6.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(btn1.snp.bottom).offset(6)
        }
        
        btn7.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(btn4.snp.bottom).offset(6)
        }
        
        btn8.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn4.snp.bottom).offset(6)
        }
        
        btn9.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(btn4.snp.bottom).offset(6)
        }
        
        optionBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(btn7.snp.bottom).offset(6)
        }
        
        btn0.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn7.snp.bottom).offset(6)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(btn7.snp.bottom).offset(6)
        }
        
        deleteImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    //RX로 button의 상태 전달 함수
    func bindButtonAction(_ button: UIButton, value: String) {
        button.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.changeBackgroundColor(button, highlighted: true)
            })
            .disposed(by: disposeBag)
        
        button.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel])
            .subscribe(onNext: { [weak self] in
                self?.changeBackgroundColor(button, highlighted: false)
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .map { value }
            .bind(to: customKeySubject)
            .disposed(by: disposeBag)
    }
    
    //button helighted될 때, 색깔 바뀌게 해주는 함수
    func changeBackgroundColor(_ button: UIButton, highlighted: Bool) {
        if highlighted {
            if button == deleteButton {
                deleteImage.image = UIImage(systemName: "delete.left.fill")
            } else {
                button.backgroundColor = UIColor(hex: 0xB3C2D0)
            }
        } else {
            if button == deleteButton {
                deleteImage.image = UIImage(systemName: "delete.left")
            } else {
                button.backgroundColor = UIColor(hex: 0xFCFCFE)
            }
            
        }
    }
    
    //delete 계속 누르고 있으면 지워지는 함수
    func startDeletingCharacters() {
        guard let textField = currentTextField, let text = textField.text, !text.isEmpty else { return }
        Observable<Int>.interval(.milliseconds(200), scheduler: MainScheduler.instance)
            .take(until: deleteButton.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel]).asObservable())
            .subscribe(onNext: { _ in
                guard let text = textField.text, !text.isEmpty else { return }
                var newText = text
                newText.removeLast()
                textField.text = newText
                textField.sendActions(for: .editingChanged)
            })
            .disposed(by: disposeBag)
    }
    
    func bindDeleteButtonLongPress() {
        deleteButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.startDeletingCharacters()
            })
            .disposed(by: disposeBag)

    }
    
   
}

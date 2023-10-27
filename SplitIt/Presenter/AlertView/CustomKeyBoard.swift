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

class CustomKeyboard: UIInputViewController {

    weak var delegate: CustomKeyboardDelegate?

    private let disposeBag = DisposeBag()
    private let customKeySubject = PublishSubject<String>()

    var customKeyObservable: Observable<String> {
        return customKeySubject.asObservable()
    }
    
    let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 390, height: 291))
    
    let btn1 = KeyboardButton(title: "1번")
    let btn2 = KeyboardButton(title: "2번")
    let btn3 = KeyboardButton(title: "3번")
    let btn4 = KeyboardButton(title: "4번")
    let btn5 = KeyboardButton(title: "5번")
    let btn6 = KeyboardButton(title: "6번")
    let btn7 = KeyboardButton(title: "7번")
    let btn8 = KeyboardButton(title: "8번")
    let btn9 = KeyboardButton(title: "9번")
    let btn0 = KeyboardButton(title: "0번")
    let btn00 = KeyboardButton(title: "00번")
    let deleteButton = KeyboardButton(title: "del")

    private var currentTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setAddView()
        setKeyLayout()
        setBinding()
    

        
    }
    
    func setCurrentTextField(_ textField: UITextField) {
            currentTextField = textField
            textField.inputView = self.inputView

        }

    func handleInputValue(_ value: String) {
        guard let textField = currentTextField else { return }
        if value == "del" {
            if var text = textField.text, !text.isEmpty {
                text.removeLast()
                textField.text = text
            }
        } else {
            if var text = textField.text {
                text += value
                textField.text = text
            }
        }
    }

    
    func setAttribute() {
       
        let inputView = UIInputView(frame: CGRect(x: 0, y: 0, width: 390, height: 288), inputViewStyle: .keyboard)
        inputView.backgroundColor = .lightGray
        self.inputView = inputView

        keyboardView.backgroundColor = UIColor(hex: 0x3C3C43)
        inputView.addSubview(keyboardView)
        
        
    }
    
    func setAddView() {
               
        [btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btn0, btn00, deleteButton].forEach {
            keyboardView.addSubview($0)
        }
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
        bindButtonAction(btn00, value: "00")
        bindButtonAction(btn0, value: "0")
        bindButtonAction(deleteButton, value: "del")
    }
    
    func setKeyLayout() {
        btn1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(6)
        }
        
        btn2.snp.makeConstraints { make in
            make.left.equalTo(btn1.snp.right).offset(4)
            make.top.equalToSuperview().offset(6)
        }
        
        btn3.snp.makeConstraints { make in
            make.left.equalTo(btn2.snp.right).offset(4)
            make.top.equalToSuperview().offset(6)
        }

        
        btn4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.top.equalTo(btn1.snp.bottom).offset(6)
        }
        
        btn5.snp.makeConstraints { make in
            make.left.equalTo(btn4.snp.right).offset(4)
            make.top.equalTo(btn1.snp.bottom).offset(6)
        }
        
        btn6.snp.makeConstraints { make in
            make.left.equalTo(btn5.snp.right).offset(4)
            make.top.equalTo(btn1.snp.bottom).offset(6)
        }

        btn7.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.top.equalTo(btn4.snp.bottom).offset(6)
        }
        
        btn8.snp.makeConstraints { make in
            make.left.equalTo(btn7.snp.right).offset(4)
            make.top.equalTo(btn4.snp.bottom).offset(6)
        }
        
        btn9.snp.makeConstraints { make in
            make.left.equalTo(btn8.snp.right).offset(4)
            make.top.equalTo(btn4.snp.bottom).offset(6)
        }
        
        btn00.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.top.equalTo(btn7.snp.bottom).offset(6)
        }
        
        btn0.snp.makeConstraints { make in
            make.left.equalTo(btn00.snp.right).offset(4)
            make.top.equalTo(btn7.snp.bottom).offset(6)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.left.equalTo(btn0.snp.right).offset(4)
            make.top.equalTo(btn7.snp.bottom).offset(6)
        }

    }
    
    func bindButtonAction(_ button: UIButton, value: String) {
        button.rx.tap
            .map { value }
            .bind(to: customKeySubject)
            .disposed(by: disposeBag)
    }
}

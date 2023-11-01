//
//  TestVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.


import UIKit
import SnapKit
import RxSwift



class TestVC: UIViewController, CustomKeyboardDelegate, UITextFieldDelegate {

    let disposeBag = DisposeBag()
    
    let textField1 = UITextField()
    let textField2 = UITextField()
    
    let customKeyboard1 = CustomKeyboard()
    let customKeyboard2 = CustomKeyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.addSubview(textField1)
        view.addSubview(textField2)
        
        view.backgroundColor = .white
 
        textField1.inputView = customKeyboard1.inputView       
        textField2.inputView = customKeyboard2.inputView
        
        customKeyboard1.delegate = self
        customKeyboard2.delegate = self

        

        customKeyboard1.setCurrentTextField(textField1)
        customKeyboard2.setCurrentTextField(textField2)
        
        customKeyboard1.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.customKeyboard1.handleInputValue(value)
            })
            .disposed(by: disposeBag)
        
        customKeyboard2.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.customKeyboard2.handleInputValue(value)
                print(self?.textField2.text)
            })
            .disposed(by: disposeBag)
        
        setAttribute()


    }
    
    func setAttribute(){
        
        textField1.borderStyle = .roundedRect
        textField1.placeholder = "Enter text here"
        
        textField2.borderStyle = .roundedRect
        textField2.placeholder = "Enter text here"
        
        textField1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
    }
}



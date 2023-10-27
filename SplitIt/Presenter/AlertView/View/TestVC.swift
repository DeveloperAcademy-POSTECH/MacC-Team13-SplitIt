//
//  TestVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.


import UIKit
import SnapKit
import RxSwift



class TestVC: UIViewController, CustomKeyboardDelegate {

    let disposeBag = DisposeBag()
    let customKeyboard = CustomKeyboard()
    
    let textField1 = UITextField()
    let textField2 = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.backgroundColor = .white
 
        customKeyboard.delegate = self

        textField1.borderStyle = .roundedRect
        textField1.placeholder = "Enter text here"
        textField1.inputView = customKeyboard.inputView
        
        textField2.borderStyle = .roundedRect
        textField2.placeholder = "Enter text here"
        textField2.inputView = customKeyboard.inputView


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
        
        
        customKeyboard.setCurrentTextField(textField1)
        customKeyboard.setCurrentTextField(textField2)

//
//        customKeyboard.customKeyObservable
//            .subscribe(onNext: { value in
//                print(value)
//                if value == "del" {
//                    if var text = self.textField1.text, !text.isEmpty {
//                        text.removeLast()
//                        self.textField1.text = text
//                    }
//                } else {
//                    self.textField1.text! += value
//                }
//
//            })
//            .disposed(by: disposeBag)

    }
    
}



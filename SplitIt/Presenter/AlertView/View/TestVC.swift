//
//  TestVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.


import UIKit
import SnapKit
import RxSwift

protocol TestDelegate {
    func check()
}

class TestVC: UIViewController, TestDelegate, CustomKeyboardDelegate {
    
    func tapKey(value: String) {
        customKeyboard.tapKey(value: value)
    }

    func check() {
        print("TestVC의 check 함수")
    }
    
    let disposeBag = DisposeBag()
    let customKeyboard = CustomKeyboard()
    
    let btn = UIButton()
    let textField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btn)
        view.backgroundColor = .white
        
        btn.setTitle("눌러줘!", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        
        customKeyboard.delegate = self

        
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text here"
        textField.inputView = customKeyboard.inputView
        
        btn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
            
        }
        
        view.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        btn.addTarget(self, action: #selector(keyboardtapped), for: .touchUpInside)
        
        customKeyboard.customKeyObservable
            .subscribe(onNext: { value in
                print(value)
                self.textField.text! += value
            })
            .disposed(by: disposeBag)

        customKeyboard.valueObservable
            .subscribe(onNext: { value in
                print(value)


            })
            .disposed(by: disposeBag)
        
        //btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
    }
    
    
    
    @objc func keyboardtapped() {
        let inputViewController = UIInputViewController()
        inputViewController.view = customKeyboard.inputView
        self.present(inputViewController, animated: true, completion: nil)
    }
//
//    @objc func buttonTapped() {
//        let vc = SecondVC()
//        vc.sendDelegate = self
//        self.present(vc, animated: true)
//    }
}



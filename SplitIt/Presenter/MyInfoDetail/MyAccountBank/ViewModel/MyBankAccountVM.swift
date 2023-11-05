//
//  MyAccountVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MyBankAccountVM {
    
    var disposeBag = DisposeBag()
    let userDefault = UserDefaults.standard
    
    var isTossPayToggled: Bool = UserDefaults.standard.bool(forKey: "tossPay")
    var isKakaoPayToggled: Bool = false
    var isNaverPayToggled: Bool = false
    
    var inputName: String = ""
    var inputRealName: String = ""
    var inputAccount: String = ""
    
    var checkInputName: Int = 0
    var checkAccount: Int = 0
    var checkRealName: Int = 0
 
    var inputAccountRelay = BehaviorRelay<String?>(value: nil)
    
    
    struct Input {
        let inputNameText: ControlEvent<String>
        let inputRealNameText: ControlEvent<String>
        let editDoneBtnTapped: Driver<Void>
        let selectBackTapped: Observable<Void>
        let inputAccountText: ControlEvent<String>
        let tossTapped: Observable<Void>
        let kakaoTapeed: Observable<Void>
        let naverTapped: Observable<Void>
        let deleteBtnTapped: Driver<Void>
        
    }
    
    
    struct Output {
        let popToMyInfoView: Driver<Void>
        let showBankModel: Observable<Void>
        let toggleTossPay: Observable<Void>
        let toggleKakaoPay: Observable<Void>
        let togglenaverPay: Observable<Void>
        let showAlertView: Driver<Void>

    }
    
    func transform(input: Input) -> Output {
        
        let inputNameText = input.inputNameText
        let inputRealNameText = input.inputRealNameText
        let editDoneBtnTapped = input.editDoneBtnTapped
        let selectBackTapped = input.selectBackTapped
        let inputAccountText = input.inputAccountText
        let tossTapped = input.tossTapped
        let kakaoTapped = input.kakaoTapeed
        let naverTapped = input.naverTapped
        let deleteBtnTapped = input.deleteBtnTapped

        editDoneBtnTapped
            .drive(onNext: {
               // let accountValue = self.inputAccountRelay.value ?? ""
                
//                if !accountValue.isEmpty || self.checkAccount == 1 {
//                    UserDefaults.standard.set(accountValue, forKey: "userAccount")
//                    self.checkAccount = 0
//                    print(accountValue)
//                }
                
                if !self.inputAccount.isEmpty || self.checkAccount == 1 {
                    UserDefaults.standard.set(self.inputAccount, forKey: "userAccount")
                    self.checkAccount = 0
                    print(self.inputAccount)
                }
               
                
                if !self.inputName.isEmpty || self.checkInputName == 1 {
                    
                    UserDefaults.standard.set(self.inputName, forKey: "userNickName")
                    print(self.inputName)
                    self.checkInputName = 0
                    
                }
                
                if !self.inputRealName.isEmpty || self.checkRealName == 1 {
                    UserDefaults.standard.set(self.inputRealName, forKey: "userName")
                    self.checkRealName = 0
                    print(self.inputRealName)
                }
            })
            .disposed(by: disposeBag)

        
//        tossTapped
//            .subscribe(onNext:
//                isTossPayToggled.toggle()
//            )
//            .disposed(by: disposeBag)
        
        
        
        tossTapped
            .subscribe(onNext: {
                let isToggled = !self.userDefault.bool(forKey: "tossPay")
                self.userDefault.set(isToggled, forKey: "tossPay")
            })
            .disposed(by: disposeBag)
        
        kakaoTapped
            .subscribe(onNext: {
                let iskakaoToggled = !self.userDefault.bool(forKey: "kakaoPay")
                self.userDefault.set(iskakaoToggled, forKey: "kakaoPay")
            })
            .disposed(by: disposeBag)
        
        naverTapped
            .subscribe(onNext: {
                let isnaverToggled = !self.userDefault.bool(forKey: "naverPay")
                self.userDefault.set(isnaverToggled, forKey: "naverPay")
            })
            .disposed(by: disposeBag)
     
        inputNameText
            .bind(onNext: { text in
                if text.isEmpty {
                    self.inputName = ""
                    self.checkInputName = 1
                } else {
                    self.inputName = text
                }

            })
            .disposed(by: disposeBag)

        
        inputRealNameText
            .bind(onNext: { text in
                if text.isEmpty {
                    self.inputRealName = ""
                    self.checkRealName = 1
                } else {
                    self.inputRealName = text
                }
            })
            .disposed(by: disposeBag)

        
        
        inputAccountText
            .bind(onNext: { text in
                if text.isEmpty {
                    self.inputAccount = ""
                    self.checkAccount = 1
                } else {
                    self.inputAccount = text
                }
            })
            .disposed(by: disposeBag)

       
     
    let output = Output(popToMyInfoView: editDoneBtnTapped,
                            showBankModel: selectBackTapped,
                            toggleTossPay: tossTapped,
                            toggleKakaoPay: kakaoTapped,
                            togglenaverPay: naverTapped,
                            showAlertView: deleteBtnTapped
                         
        )
        
        return output
    }
    
    
    func tossTap() {
        isTossPayToggled.toggle()
    }
    
    
    
}


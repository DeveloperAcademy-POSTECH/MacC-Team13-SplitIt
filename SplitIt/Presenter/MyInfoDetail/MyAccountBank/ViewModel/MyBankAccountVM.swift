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
    //let payData = PayData.shared.payData
    let userDefault = UserDefaults.standard
    
    
    struct Input {
        let inputNameText: ControlEvent<String>
        let editDoneBtnTapped: Driver<Void>
        let selectBackTapped: Observable<Void>
        let inputAccountText: Observable<String>
        let tossTapped: Observable<Void>
        let kakaoTapeed: Observable<Void>
        let naverTapped: Observable<Void>
        let nameTextFieldClearTapped: ControlEvent<Void>
       // let accountTextFieldClearTapped: Observable<Void>
        
    }
    
    
    struct Output {
        let popToMyInfoView: Driver<Void>
        let showBankModel: Observable<Void>
        let toggleTossPay: Observable<Void>
        let toggleKakaoPay: Observable<Void>
        let togglenaverPay: Observable<Void>
        let nameTextFieldClear: ControlEvent<Void>
//        let accountTextFieldClear: Driver<Void>
        
    }
    
    func transform(input: Input) -> Output {
        
        let inputNameText = input.inputNameText
        let editDoneBtnTapped = input.editDoneBtnTapped
        let selectBackTapped = input.selectBackTapped
        let inputAccountText = input.inputAccountText
        let tossTapped = input.tossTapped
        let kakaoTapped = input.kakaoTapeed
        let naverTapped = input.naverTapped
        let nameTextFieldClear = input.nameTextFieldClearTapped
//        let accountTextFieldClear = input.accountTextFieldClearTapped
        
        
        var inputAccount: String = ""
        var inputName: String = ""
                
        
  
        
        
        inputNameText
            .bind(onNext: { text in
                if text != "" {
                    inputName = text
                }
            })
            .disposed(by: disposeBag)
        
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
        
        
        inputAccountText
            .subscribe(onNext: { text in
                print("계좌번호 \(text)")
                inputAccount = text
            })
            .disposed(by: disposeBag)
        
        
        editDoneBtnTapped
            .drive(onNext: {
                print("수정버튼 눌림")
                
                if inputAccount != "" {
                    UserDefaults.standard.set(inputAccount, forKey: "userAccount")
                }
                
                if inputName != "" {
                    UserDefaults.standard.set(inputName, forKey: "userName")
                }
                
               
                
            })
            .disposed(by: disposeBag)
        
     
        
        let output = Output(popToMyInfoView: editDoneBtnTapped,
                            showBankModel: selectBackTapped,
                            toggleTossPay: tossTapped,
                            toggleKakaoPay: kakaoTapped,
                            togglenaverPay: naverTapped,
                            nameTextFieldClear: nameTextFieldClear
//                            accountTextFieldClear: accountTextFieldClear
        )
        
        return output
    }
    
    
}


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

        var inputName: String = ""
        var inputRealName: String = ""


        editDoneBtnTapped
            .drive(onNext: {
                let accountValue = self.inputAccountRelay.value ?? ""
                print("수정버튼 눌림")
                
                if !accountValue.isEmpty {
                    UserDefaults.standard.set(accountValue, forKey: "userAccount")
                }
                if inputName != "" {
                    UserDefaults.standard.set(inputName, forKey: "userNickName")
                }

                if inputRealName != "" {
                    UserDefaults.standard.set(inputRealName, forKey: "userName")
                }
                

            })
            .disposed(by: disposeBag)

        
        
        inputNameText
            .bind(onNext: { text in
                if text != "" {
                    inputName = text
                }
            })
            .disposed(by: disposeBag)

        inputRealNameText
            .bind(onNext: { text in
                if text != "" {
                    inputRealName = text
                }
            })
            .disposed(by: disposeBag)
        
        inputAccountText
            .bind(to: inputAccountRelay)
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
        
       
       
     
        
        let output = Output(popToMyInfoView: editDoneBtnTapped,
                            showBankModel: selectBackTapped,
                            toggleTossPay: tossTapped,
                            toggleKakaoPay: kakaoTapped,
                            togglenaverPay: naverTapped,
                            showAlertView: deleteBtnTapped
                         
        )
        
        return output
    }
    
    
}


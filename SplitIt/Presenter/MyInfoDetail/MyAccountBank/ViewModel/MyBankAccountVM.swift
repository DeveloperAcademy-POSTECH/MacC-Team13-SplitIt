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
    var bankModalListVC: BankListModalVC?
    let userDefault = UserDefaults.standard
    
    var isTossPayToggled = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "tossPay"))
    var isKakaoPayToggled = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "kakaoPay"))
    var isNaverPayToggled = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "naverPay"))
    
    var inputRealName: String = ""
    var inputAccount: String = ""
    var inputBankName: String = ""
    
    var checkAccount: Int = 0
    var checkRealName: Int = 0
    var checkBank: Int = 0
 
    var inputAccountRelay = BehaviorRelay<String?>(value: nil)
    
    
    struct Input {
        let inputRealNameText: ControlEvent<String>
        let editDoneBtnTapped: Driver<Void>
        let selectBackTapped: Observable<Void>
        let inputAccountText: ControlEvent<String>
        let tossTapped: Observable<Void>
        let kakaoTapeed: Observable<Void>
        let naverTapped: Observable<Void>
        let deleteBtnTapped: Driver<Void>
        let cancelBtnTapped: Driver<Void>
        
    }
    
    
    struct Output {
        let popToMyInfoView: Driver<Void>
        let showBankModel: Observable<Void>
        let toggleTossPay: Observable<Void>
        let toggleKakaoPay: Observable<Void>
        let togglenaverPay: Observable<Void>
        let showAlertView: Driver<Void>
        let cancelBackToView: Driver<Void>

    }
    
    func transform(input: Input) -> Output {
        
       // let inputNameText = input.inputNameText
        let inputRealNameText = input.inputRealNameText
        let editDoneBtnTapped = input.editDoneBtnTapped
        let selectBackTapped = input.selectBackTapped
        let inputAccountText = input.inputAccountText
        let tossTapped = input.tossTapped
        let kakaoTapped = input.kakaoTapeed
        let naverTapped = input.naverTapped
        let deleteBtnTapped = input.deleteBtnTapped
        let cancelBtnTapped = input.cancelBtnTapped

        editDoneBtnTapped
            .drive(onNext: {
                
                if !self.inputBankName.isEmpty || self.checkBank == 1 {
                    UserDefaults.standard.set(self.inputBankName, forKey: "userBank")
                    self.checkBank = 0
                }

                if !self.inputAccount.isEmpty || self.checkAccount == 1 {
                    UserDefaults.standard.set(self.inputAccount, forKey: "userAccount")
                    self.checkAccount = 0
                }
                

                if !self.inputRealName.isEmpty || self.checkRealName == 1 {
                    UserDefaults.standard.set(self.inputRealName, forKey: "userName")
                    self.checkRealName = 0
                }
                
                self.isTossPayToggled
                    .subscribe(onNext: { toggled in
                        UserDefaults.standard.set(toggled, forKey: "tossPay")
                    })
                    .disposed(by: self.disposeBag)
                
                self.isKakaoPayToggled
                    .subscribe(onNext: { toggled in
                        UserDefaults.standard.set(toggled, forKey: "kakaoPay")
                    })
                    .disposed(by: self.disposeBag)
                
                self.isNaverPayToggled
                    .subscribe(onNext: { toggled in
                        UserDefaults.standard.set(toggled, forKey: "naverPay")
                    })
                    .disposed(by: self.disposeBag)
              

                
            })
            .disposed(by: disposeBag)

        
        
        tossTapped
            .subscribe(onNext: {
                self.isTossPayToggled.accept(!self.isTossPayToggled.value)
            })
            .disposed(by: disposeBag)

        kakaoTapped
            .subscribe(onNext: {
                self.isKakaoPayToggled.accept(!self.isKakaoPayToggled.value)
            })
            .disposed(by: disposeBag)

        naverTapped
            .subscribe(onNext: {
                self.isNaverPayToggled.accept(!self.isNaverPayToggled.value)
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
                            showAlertView: deleteBtnTapped,
                        cancelBackToView: cancelBtnTapped
        )
        
        return output
    }
    
    
  
    
}


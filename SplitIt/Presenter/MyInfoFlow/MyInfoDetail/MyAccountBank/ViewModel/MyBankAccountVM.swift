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
        
    struct Input {
        let inputRealNameText: Driver<String>
        let editDoneBtnTapped: Driver<Void>
        let selectBackTapped: Observable<Void>
        let inputAccountText: Driver<String>
        let tossTapped: Observable<Void>
        let kakaoTapeed: Observable<Void>
        let naverTapped: Observable<Void>
        let deleteBtnTapped: Observable<Void>
        let cancelBtnTapped: Observable<Void>
        let inputUserBankName: BehaviorRelay<String>
        let swipeBack: Observable<UIScreenEdgePanGestureRecognizer>
    }
    
    struct Output {
        let popToMyInfoView: Driver<Void>
        let showBankModel: Observable<Void>
        let toggleTossPay: BehaviorRelay<Bool>
        let toggleKakaoPay: BehaviorRelay<Bool>
        let toggleNaverPay: BehaviorRelay<Bool>
        let cancelBackToView: Observable<Void>
        let isSaveButtonEnable: BehaviorRelay<Bool>
        let isChangedRelay: BehaviorRelay<Bool>
        let inputBankName: BehaviorRelay<String>
        let deleteButtonTapped: Observable<Void>
        let nameTextCount: BehaviorRelay<String>
        let accountTextCount: BehaviorRelay<String>
        let inputRealNameText: BehaviorRelay<String>
        let inputRealNameTextColor: BehaviorRelay<UIColor>
        let inputAccountTextColor: BehaviorRelay<UIColor>
        let inputAccountText: BehaviorRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let toggleTossPay = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "tossPay"))
        let toggleKakaoPay = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "kakaoPay"))
        let toggleNaverPay = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "naverPay"))
        let inputBankName = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "userBank") ?? "")
        let inputRealName = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "userName") ?? "")
        let inputAccount = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "userAccount") ?? "")
        
        let isSaveButtonEnable = BehaviorRelay<Bool>(value: false)
        let isChangedRelay = BehaviorRelay<Bool>(value: false)
        let nameTextCount = BehaviorRelay<String>(value: "")
        let accountTextCount = BehaviorRelay<String>(value: "")
        let inputRealNameTextColor = BehaviorRelay<UIColor>(value: .TextSecondary)
        let inputAccountTextColor = BehaviorRelay<UIColor>(value: .TextSecondary)
        let inputRealNameText = BehaviorRelay<String>(value: "")
        let inputAccountText = BehaviorRelay<String>(value: "")
        
        let editDoneBtnTapped = input.editDoneBtnTapped
        let selectBackTapped = input.selectBackTapped
        let tossTapped = input.tossTapped
        let kakaoTapped = input.kakaoTapeed
        let naverTapped = input.naverTapped
        let deleteBtnTapped = input.deleteBtnTapped
        let cancelBtnTapped = input.cancelBtnTapped
        let inputUserBankName = input.inputUserBankName
        
        let maxTextCount = 8
        
        input.editDoneBtnTapped
            .drive(onNext: {
                if inputBankName.value == "선택 안함" {
                    UserDefaults.standard.set("선택 안함", forKey: "userBank")
                    UserDefaults.standard.set("", forKey: "userAccount")
                    UserDefaults.standard.set("", forKey: "userName")
                } else {
                    if !inputBankName.value.isEmpty {
                        UserDefaults.standard.set(inputBankName.value, forKey: "userBank")
                    }
                    if !inputAccount.value.isEmpty {
                        UserDefaults.standard.set(inputAccount.value, forKey: "userAccount")
                    }
                    if !inputRealName.value.isEmpty {
                        UserDefaults.standard.set(inputRealName.value, forKey: "userName")
                    }
                }
                toggleTossPay
                    .subscribe(onNext: { toggled in
                        UserDefaults.standard.set(toggled, forKey: "tossPay")
                    })
                    .disposed(by: self.disposeBag)
                
                toggleKakaoPay
                    .subscribe(onNext: { toggled in
                        UserDefaults.standard.set(toggled, forKey: "kakaoPay")
                    })
                    .disposed(by: self.disposeBag)
                
                toggleNaverPay
                    .subscribe(onNext: { toggled in
                        UserDefaults.standard.set(toggled, forKey: "naverPay")
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        tossTapped
            .subscribe(onNext: {
                toggleTossPay.accept(!toggleTossPay.value)
            })
            .disposed(by: disposeBag)
        
        kakaoTapped
            .subscribe(onNext: {
                toggleKakaoPay.accept(!toggleKakaoPay.value)
            })
            .disposed(by: disposeBag)
        
        naverTapped
            .subscribe(onNext: {
                toggleNaverPay.accept(!toggleNaverPay.value)
            })
            .disposed(by: disposeBag)
        
        inputUserBankName
            .subscribe(onNext: { newValue in
                inputBankName.accept(newValue)
            })
            .disposed(by: disposeBag)
        
        input.inputRealNameText
            .drive(onNext: { newValue in
                inputRealName.accept(newValue)
            })
            .disposed(by: disposeBag)
        
        input.inputRealNameText
            .map { text in
                if text.count == 0 {
                    isSaveButtonEnable.accept(false)
                } else {
                    isSaveButtonEnable.accept(true)
                }
                let count = min(text.count, 8)
                return "\(count)/8"
            }
            .drive(nameTextCount)
            .disposed(by: disposeBag)
        
        input.inputRealNameText
            .map { text -> UIColor in
                return text.count >= maxTextCount ? .AppColorStatusWarnRed : .TextSecondary
            }
            .drive(inputRealNameTextColor)
            .disposed(by: disposeBag)
        
        input.inputRealNameText
            .map { text in
                if text.count >= 8 {
                    let endIndex = text.index(text.startIndex, offsetBy: 8)
                    return String(text[..<endIndex])
                } else {
                    return text
                }
            }
            .drive(inputRealNameText)
            .disposed(by: disposeBag)

        input.inputAccountText
            .drive(onNext: { newValue in
                inputAccount.accept(newValue)
            })
            .disposed(by: disposeBag)
        
        input.inputAccountText
            .map { text in
                let filtered = text.filter { $0.isNumber || $0 == "-" }
                let count = min(filtered.count, 17)
                return "\(count)/17"
            }
            .drive(accountTextCount)
            .disposed(by: disposeBag)
        
        input.inputAccountText
            .map { text -> UIColor in
                return text.count >= 17 ? .AppColorStatusWarnRed : .TextSecondary
            }
            .drive(inputAccountTextColor)
            .disposed(by: disposeBag)
        
        input.inputAccountText
            .map { text in
                let filtered = text.filter { $0.isNumber || $0 == "-" }
                if filtered.count >= 17 {
                    let endIndex = filtered.index(filtered.startIndex, offsetBy: 17)
                    return String(filtered[..<endIndex])
                } else {
                    return filtered
                }
            }
            .drive(inputAccountText)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(inputRealNameText, inputAccountText, inputBankName)
            .map { nameText, accountText, bank in
                if bank == "선택 안함" {
                    return true
                } else {
                    return nameText.count > 0 && accountText.count > 0
                }
            }
            .bind(to: isSaveButtonEnable)
            .disposed(by: disposeBag)

        
//                print(preName, preAccount, preBank, preToss, preKakao, preNaver)
//                print(name, account, bank, toss, kakao, naver)
        
        Observable.combineLatest(inputBankName, inputRealName, inputAccount, toggleTossPay, toggleKakaoPay, toggleNaverPay)
            .map { bank, name, account, toss, kakao, naver in
                let preName = UserDefaults.standard.string(forKey: "userName")
                let preAccount = UserDefaults.standard.string(forKey: "userAccount")
                let preBank = UserDefaults.standard.string(forKey: "userBank")
                let preToss = UserDefaults.standard.bool(forKey: "tossPay")
                let preKakao = UserDefaults.standard.bool(forKey: "kakaoPay")
                let preNaver = UserDefaults.standard.bool(forKey: "naverPay")
               
                //하나라도 다르면 true, 변화가 없었다면 false return
                return preName != name || preAccount != account || preBank != bank || preToss != toss || preKakao != kakao || preNaver != naver
            }
            .bind(to: isChangedRelay)
            .disposed(by: disposeBag)
        
        let showBackAlert = Observable.merge(input.cancelBtnTapped.asObservable(),
                                             input.swipeBack.map{ _ in }.asObservable())
        
        return Output(popToMyInfoView: editDoneBtnTapped,
                      showBankModel: selectBackTapped,
                      toggleTossPay: toggleTossPay,
                      toggleKakaoPay: toggleKakaoPay,
                      toggleNaverPay: toggleNaverPay,
                      cancelBackToView: showBackAlert,
                      isSaveButtonEnable: isSaveButtonEnable,
                      isChangedRelay: isChangedRelay,
                      inputBankName: inputBankName,
                      deleteButtonTapped: deleteBtnTapped,
                      nameTextCount: nameTextCount,
                      accountTextCount: accountTextCount,
                      inputRealNameText: inputRealNameText,
                      inputRealNameTextColor: inputRealNameTextColor,
                      inputAccountTextColor: inputAccountTextColor,
                      inputAccountText: inputAccountText)
    }
}


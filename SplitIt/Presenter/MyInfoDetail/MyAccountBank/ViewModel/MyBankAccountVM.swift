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
    let payData = PayData.shared.payData
    let userData = UserData.shared.userData
    
    struct Input {
        let inputNameText: ControlEvent<String>
        let editDoneBtnTapped: Driver<Void>
        let selectBackTapped: Observable<Void>
        let inputAccountText: Observable<String>
        let tossTapped: Observable<Void>
        let kakaoTapeed: Observable<Void>
        let naverTapped: Observable<Void>

    }
    
    
    struct Output {
        let popToMyInfoView: Driver<Void>
        let showBankModel: Observable<Void>
        let toggleTossPay: Observable<Void>
        let toggleKakaoPay: Observable<Void>
        let togglenaverPay: Observable<Void>

        
    }
    
    func transform(input: Input) -> Output {
        
        let inputNameText = input.inputNameText
        let editDoneBtnTapped = input.editDoneBtnTapped
        let selectBackTapped = input.selectBackTapped
        let inputAccountText = input.inputAccountText
        let tossTapped = input.tossTapped
        let kakaoTapped = input.kakaoTapeed
        let naverTapped = input.naverTapped
        
        var updatedPayData = self.payData.value
        var inputAccount: String = userData.value.account
        var inputName: String = userData.value.name
        
        
        inputNameText
            .bind(onNext: { text in
                print(text)
                inputName = text
            })
            .disposed(by: disposeBag)

        
        tossTapped
            .subscribe(onNext: {
                if let index = updatedPayData.firstIndex(where: { $0.socialPayIdx == 1 }) {
                    updatedPayData[index].isTrue.toggle()
                }
                self.payData.accept(updatedPayData)
                print(updatedPayData)
            })
            .disposed(by: disposeBag)


        kakaoTapped
            .subscribe(onNext: {
                if let index = updatedPayData.firstIndex(where: { $0.socialPayIdx == 2 }) {
                    updatedPayData[index].isTrue.toggle()
                }
                self.payData.accept(updatedPayData)
                print(updatedPayData)
            })
            .disposed(by: disposeBag)
        
        naverTapped
            .subscribe(onNext: {
                if let index = updatedPayData.firstIndex(where: { $0.socialPayIdx == 3 }) {
                    updatedPayData[index].isTrue.toggle()
                }
                self.payData.accept(updatedPayData)
                print(updatedPayData)
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
                UserData.shared.updateUserName(inputName == "" ? self.userData.value.name : inputName)
                UserData.shared.updateUserAccount(inputAccount == "" ? self.userData.value.account : inputAccount)
    
            })
            .disposed(by: disposeBag)

        
        let output = Output(popToMyInfoView: editDoneBtnTapped,
                            showBankModel: selectBackTapped,
                            toggleTossPay: tossTapped,
                            toggleKakaoPay: kakaoTapped,
                            togglenaverPay: naverTapped
        )
        
        return output
    }
    
   
}


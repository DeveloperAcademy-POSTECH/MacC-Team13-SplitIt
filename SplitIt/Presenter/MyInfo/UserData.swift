//
//  UserData.swift
//  SplitIt
//
//  Created by cho on 2023/10/18.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

struct UserData {
    
    let userData: BehaviorRelay<User>
    static var shared = UserData()
       
    init() {
        userData = BehaviorRelay<User> (
            value: User(userIdx: 1, name: "으아아", account: "302-0546-8340-81", bank: "농혀브냉")
        )}
    

    
    func updateUserName(_ newName: String) {
        var user = userData.value
        user.name = newName
        userData.accept(user)
    }
    
    func updateUserAccount(_ newAccount: String) {
        var user = userData.value
        user.account = newAccount
        userData.accept(user)
    }
    
    func updateUserBankName(_ newBankName: String) {
        var user = userData.value
        user.bank = newBankName
        userData.accept(user)
    }
    
    
}


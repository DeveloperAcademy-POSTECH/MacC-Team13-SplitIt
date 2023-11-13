//
//  BankManager.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa

class BankManager {
    static let shared = BankManager()
    private let data = BankListData()

    func getAllBanks() -> Observable<[Bank]> {
        return data.bankList
    }
    
}

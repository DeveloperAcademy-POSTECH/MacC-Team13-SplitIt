//
//  CreateStore.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import Foundation

// MARK: Dummy Store, 추후삭제
class CreateStore {
    static let shared = CreateStore() // 싱글톤 인스턴스
    
    private init() {} // 생성자를 외부에서 호출하지 못하도록
    
    private var currentCSInfoTitle = ""
    private var currentCSInfoTotalAmount = 0
    private var currentCSMembers: [String] = []
    
    private var currentExclItemName = ""
    private var currentExclItemPrice = 0
    
    func setCurrentExclItemName(name: String) {
        currentExclItemName = name
    }
    
    func setCurrentExclItemPrice(price: Int) {
        currentExclItemPrice = price
    }
    
    func setCurrentCSInfoTitle(title: String) {
        currentCSInfoTitle = title
    }
    
    func setCurrentCSInfoTotalAmount(totalAmount: Int) {
        currentCSInfoTotalAmount = totalAmount
    }
    
    func setCurrentCSInfoCSMember(members: [String]) {
        currentCSMembers = members
    }
    
    func getCurrentCSInfoTitle() -> String {
        return currentCSInfoTitle
    }
    
    func getCurrentCSInfoTotalAmount() -> Int {
        return currentCSInfoTotalAmount
    }
    
    func getCurrentCSInfoCSMember() -> [String] {
        return currentCSMembers
    }
    
    func getCurrentExclItemName() -> String {
        return currentExclItemName
    }
    
    func getCurrentExclItemPrice() -> Int {
        return currentExclItemPrice
    }
    
    func printCurrentExclItem() {
        print("---------------------------------")
        print("name: \(self.currentExclItemName)")
        print("price: \(self.currentExclItemPrice)")
    }

    func printAll() {
        print("---------------------------------")
        print("title: \(self.currentCSInfoTitle)")
        print("totalAmount: \(self.currentCSInfoTotalAmount)")
        print("members: \(self.currentCSMembers)")
        
    }
    
}



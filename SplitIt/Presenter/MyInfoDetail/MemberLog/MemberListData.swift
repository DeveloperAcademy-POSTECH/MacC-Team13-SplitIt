//
//  MemberListData.swift
//  SplitIt
//
//  Created by cho on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa

    
struct MemberListData {
    
    let MemberList: BehaviorRelay<[Member]>
    
    static var shared = MemberListData()
    
    init() {
        MemberList = BehaviorRelay<[Member]> (value: [
            Member(memberIdx: 1, name: "하태민"),
            Member(memberIdx: 2, name: "김선길"),
            Member(memberIdx: 3, name: "조채원"),
            Member(memberIdx: 4, name: "진준호"),
            Member(memberIdx: 5, name: "홍승완"),
            Member(memberIdx: 6, name: "이주환"),
            Member(memberIdx: 7, name: "1234"),
            Member(memberIdx: 8, name: "2222"),
            Member(memberIdx: 9, name: "345"),
            Member(memberIdx: 10, name: "12345"),
            Member(memberIdx: 11, name: "avc"),
            Member(memberIdx: 12, name: "bcdf"),
            Member(memberIdx: 13, name: "dfefsd"),
            Member(memberIdx: 14, name: "eeff"),
            Member(memberIdx: 15, name: "유리"),
            Member(memberIdx: 16, name: "맹구"),
            Member(memberIdx: 17, name: "훈이"),
            Member(memberIdx: 18, name: "오수")
        ])
    }
    
    
}


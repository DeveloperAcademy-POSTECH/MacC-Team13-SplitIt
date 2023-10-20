//
//  MemberManager.swift
//  SplitIt
//
//  Created by cho on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa


//여기에서도 Observable이 필요한지,,?
class MemberManager {
    static let shared = MemberManager()
    private let data = MemberListData()
    private var banks: [Member] = []
    
    private init() { }
    
    func getAllFriends() -> Observable<[Member]> {
        return data.MemberList.asObservable()
    }
}

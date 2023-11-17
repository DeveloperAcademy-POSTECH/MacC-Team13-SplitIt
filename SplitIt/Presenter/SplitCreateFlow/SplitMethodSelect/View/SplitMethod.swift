//
//  SplitMethod.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/17.
//

import Foundation

struct SplitMethod {
    let image: String
    let title: String
    let descriptions: String
    let isRecommended: Bool
    
    static let list: [SplitMethod] = [
        SplitMethod(image: "SmartSplitMethodIcon",
                    title: "쓴 만큼 내기",
                    descriptions: "항목에 따라 제외할 멤버를 선택하고\n각자 먹고 쓴 만큼 나눕니다.",
                    isRecommended: true),
        SplitMethod(image: "EqualSplitMethodIcon",
                    title: "똑같이 나누어 내기",
                    descriptions: "함께한 인원수만큼\n금액을 똑같이 나눕니다.",
                    isRecommended: false),
    ]
}

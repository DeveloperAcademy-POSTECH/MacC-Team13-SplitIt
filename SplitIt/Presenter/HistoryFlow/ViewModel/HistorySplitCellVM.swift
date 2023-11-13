//
//  HistorySplitCellVM.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/18.
//
import Foundation
import RxSwift
import RxCocoa

class HistorySplitCellVM {
    let repo = SplitRepository.share
    var csInfoArr: [CSInfo] = []
    
    func getCSTitles(splitIdx: String) -> String {
        self.csInfoArr = repo.csInfoArr.value.filter { $0.splitIdx == splitIdx }
        let csTitleArr: [String] = self.csInfoArr.map { $0.title }
        let csTitles: String = csTitleArr.joined(separator: ", ")
        
        return csTitles
    }
    
    func getCSMembers() -> String {
        let csInfoIdxArr: [String] = self.csInfoArr.map { $0.csInfoIdx }
        let csMemberArr: [CSMember] = repo.csMemberArr.value.filter { csInfoIdxArr.contains($0.csInfoIdx) }
        let memberArr: [String] = csMemberArr.map { $0.name }
        let csMembers: String = memberArr.joined(separator: ", ")
        
        return csMembers
    }
    
    func getTotalAmount() -> String {
        let calcResult: Int = csInfoArr.map{ $0.totalAmount }.reduce(0, +)
        let numberFormetter = NumberFormatterHelper()
        return numberFormetter.formattedString(from: calcResult)
    }
}

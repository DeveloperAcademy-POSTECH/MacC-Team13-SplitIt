//
//  HistoryModel.swift
//  SplitIt
//
//  Created by Zerom on 2/29/24.
//

import Foundation

struct HistoryModel {
    var title: String
    var csMembers: String
    var totalAmount: String
    
    init(title: String, csMembers: String, totalAmount: String) {
        self.title = title
        self.csMembers = csMembers
        self.totalAmount = totalAmount
    }
}

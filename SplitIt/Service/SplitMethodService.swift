//
//  SelectMethodService.swift
//  SplitIt
//
//  Created by Zerom on 2/26/24.
//

import Foundation

protocol SplitMethodServiceType {
    func getCurrentSplitCSInfoCount() -> Int
}

class SplitMethodService: SplitMethodServiceType {
    private var currentSplitIdx: String
    private var manager: CreateRealmManagerType
    
    init(currentSplitIdx: String) {
        self.manager = CreateRealmManager()
        self.currentSplitIdx = currentSplitIdx
    }
    
    func getCurrentSplitCSInfoCount() -> Int {
        if self.currentSplitIdx != "" {
            return try! manager.getCSInfoCount(currentSplitIdx: self.currentSplitIdx)
        } else {
            return 0
        }
    }
}

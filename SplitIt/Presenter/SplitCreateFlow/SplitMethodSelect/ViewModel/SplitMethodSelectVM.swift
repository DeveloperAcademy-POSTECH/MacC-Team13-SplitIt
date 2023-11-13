//
//  SplitMethodSelectVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/01.
//

import Foundation
import RxSwift
import RxCocoa

class SplitMethodSelectVM {
    struct Input {
        let smartSplitButtonTapped: ControlEvent<Void>
        let equalSplitButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let showSmartSplitCSInfoView: ControlEvent<Void>
        let showEqualSplitCSInfoView: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let showSmartSplitCSInfoView = input.smartSplitButtonTapped
        let showEqualSplitButtonTapped = input.equalSplitButtonTapped
        
        return Output(showSmartSplitCSInfoView: showSmartSplitCSInfoView, showEqualSplitCSInfoView: showEqualSplitButtonTapped)
    }
}

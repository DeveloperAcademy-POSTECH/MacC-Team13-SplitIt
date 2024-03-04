//
//  UINavigationController+.swift
//  SplitIt
//
//  Created by Zerom on 2/26/24.
//

import UIKit

extension UINavigationController {
    
    func popToBaseViewController(baseIndex: Int, animated: Bool) {
        let startIndex = baseIndex + 1
        let lastIndex = self.viewControllers.count - 2
        
        if lastIndex >= startIndex {
            self.viewControllers.removeSubrange(startIndex...lastIndex)
        }
        
        self.popViewController(animated: animated)
    }
    
    func removeFromBaseToPreViewController(baseIndex: Int) {
        let startIndex = baseIndex + 1
        let lastIndex = self.viewControllers.count - 2
        
        if lastIndex >= startIndex {
            self.viewControllers.removeSubrange(startIndex...lastIndex)
        }
    }
}

//
//  UIButton+.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/22.
//

import UIKit

extension UIButton {
    func removeAllActions() {
        enumerateEventHandlers { action, _, event, _ in
            if let action = action {
                removeAction(action, for: event)
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}

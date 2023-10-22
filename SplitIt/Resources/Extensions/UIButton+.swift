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
}

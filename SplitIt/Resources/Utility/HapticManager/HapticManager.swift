//
//  HapticManager.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/05.
//

import UIKit

class HapticManager {
    
    /// type: warning, error, success
    func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// style: heavy, light, medium, rigid, soft
    func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

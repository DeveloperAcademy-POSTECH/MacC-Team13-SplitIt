//
//  Notification+.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/17.
//

import Foundation
extension Notification.Name {
    //MARK: Edit(ExclItem) 관련 NotificationName 정의
    static let exclItemIsAdded = Notification.Name("exclItemIsAdded")
    static let exclItemIsEdited = Notification.Name("exclItemIsEdited")
    static let exclItemIsDeleted = Notification.Name("exclItemIsDeleted")
}

//
//  UIViews+.swift
//  SplitIt
//
//  Created by cho on 2023/10/18.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}


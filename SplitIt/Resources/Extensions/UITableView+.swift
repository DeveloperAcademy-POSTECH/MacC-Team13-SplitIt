//
//  UIView+.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit

extension UITableView {
    func screenshot(completion: @escaping (UIImage?) -> Void) {
        let contentWidthOrigin = self.contentSize.width
        let contentHeightOrigin = self.contentSize.height
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame

        self.contentOffset = .zero

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layer.frame = CGRect(x: 0, y: 0, width: contentWidthOrigin * 2, height: contentHeightOrigin * 2)
            self.layer.borderColor = UIColor.clear.cgColor
            self.isScrollEnabled = false

            UIGraphicsBeginImageContextWithOptions(CGSize(width: contentWidthOrigin, height: contentHeightOrigin), false, 3.0)

            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()

            self.contentOffset = savedContentOffset
            self.frame = savedFrame
            self.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.isScrollEnabled = true

            UIGraphicsEndImageContext()

            completion(capturedImage)
        }
    }
}

//
//  UIView+.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit

extension UITableView {
    func screenshot() -> UIImage? {
        // self.scrollToRow(at: lastIndex, at: UITableView.ScrollPosition.none, animated: false)
        
        let contentWidthOrigin = self.contentSize.width
        let contentHeightOrigin = self.contentSize.height

        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame

        self.contentOffset = CGPoint.zero
        self.layer.frame = CGRect(x: 0, y: 0, width: contentWidthOrigin, height: contentHeightOrigin)

        UIGraphicsBeginImageContextWithOptions(CGSize(width: contentWidthOrigin, height: contentHeightOrigin), false, 2.0)

        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        UIGraphicsEndImageContext()
        
        return image
    }
}

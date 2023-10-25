//
//  UIView+.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit

extension UITableView {
    func screenshot() -> UIImage? {
        let contentWidthOrigin = self.contentSize.width
        let contentHeightOrigin = self.contentSize.height
        
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame
        
//        if contentHeightOrigin >= UIScreen.main.bounds.height {
//
//
//            let contentWidthTrans = contentWidthOrigin * UIScreen.main.bounds.height / contentHeightOrigin
//            let contentHeightTrans = UIScreen.main.bounds.height
//        } else {
//            self.layer.frame = CGRect(x: 0, y: 0, width: contentWidthOrigin, height: contentHeightOrigin)
//        }
//
        self.contentOffset = CGPoint.zero
        
        self.layer.frame = CGRect(x: 0, y: 0, width: contentWidthOrigin, height: contentHeightOrigin)
        
        UIGraphicsBeginImageContext(CGSize(width: contentWidthOrigin, height: contentHeightOrigin))
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        UIGraphicsEndImageContext()
        return image
    }
}

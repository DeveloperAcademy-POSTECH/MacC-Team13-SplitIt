//
//  clearButton.swift
//  SplitIt
//
//  Created by cho on 2023/10/21.
//

import UIKit
import SnapKit



struct ClearButton {
    
    var backView = UIView()
    
    var clearBtn: UIImageView
    
    init(view: UIView) {
        
        self.clearBtn = UIImageView()
        self.clearBtn.image = UIImage(systemName: "x.circle.fill")
        self.clearBtn.tintColor = .gray
        
        let tapGesture = UITapGestureRecognizer()
        backView.addGestureRecognizer(tapGesture)
        
    }

    mutating func setupConstraints(in view: UIView) {
        view.addSubview(backView)
        backView.addSubview(clearBtn)
   
        clearBtn.snp.makeConstraints { make in
            make.height.width.equalTo(14)

        }

    }
    
    
}

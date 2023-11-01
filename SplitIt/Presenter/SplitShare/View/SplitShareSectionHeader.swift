//
//  SplitShareSectionHeader.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import Then
import SnapKit

class SplitShareSectionHeader: UIView {
    let splitImage = UIImageView()
    let dateLabel = UILabel()
    let dashLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    private func setAttribute() {
        
        splitImage.do {
            $0.image = UIImage(named: "ShareViewSplitLogo")
            $0.sizeToFit()
        }
        
        dateLabel.do {
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        dashLineView.do {
            let lineDashPattern: [NSNumber]? = [6, 6]

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = lineDashPattern
            shapeLayer.strokeColor = UIColor.BorderSecondary.cgColor

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: UIScreen.main.bounds.width - 96, y: 0)])
            
            shapeLayer.path = path
            $0.layer.addSublayer(shapeLayer)
        }
    }
    
    private func setLayout() {
        [splitImage,dateLabel,dashLineView].forEach {
            addSubview($0)
        }
        
        splitImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(splitImage.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        dashLineView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
        }
    }
}

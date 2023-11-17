//
//  SplitMethodCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/11/17.
//

import UIKit
import Then
import Reusable
import SnapKit

class SplitMethodCell: UICollectionViewCell, Reusable {

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let recommendView = UIView()
    let recommendLabel = UILabel()
    let mainView = UIView()
    let textStackView = UIStackView()
    
    // Properties
    var mainViewSize: CGSize!
    var imageSize: CGSize!
    var textStackSize: CGSize!
    var recommendViewSize: CGSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setAttribute()
        setLayout()
    }
    
    func setAttribute() {
        self.backgroundColor = .SurfaceBrandCalmshell
        
        contentView.do {
            $0.backgroundColor = .SurfaceWhite
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
            $0.frame = $0.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.font = .KoreanSubtitle
            $0.textColor = .AppColorGrayscale1000
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.setLineSpacing(4)
        }
        
        recommendView.do {
            $0.backgroundColor = .SurfaceSecondary
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        recommendLabel.do {
            $0.text = "추천"
            $0.font = .KoreanCaption1
            $0.textColor = .AppColorGrayscaleBase
        }
        
        textStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.distribution = .fill
        }
    }
    
    func setLayout() {
        let viewSize = contentView.bounds.size
        self.imageSize = CGSize(width: viewSize.width * 9/33,
                                height: viewSize.width * 9/33)
        self.textStackSize = CGSize(width: viewSize.width * 224/330,
                                    height: viewSize.width * 7/33)
        self.mainViewSize = CGSize(width: textStackSize.width,
                                   height: imageSize.height + textStackSize.height + 16)
        self.recommendViewSize = CGSize(width: viewSize.width * 44/330,
                                    height: viewSize.width * 27/330)
        imageView.layer.cornerRadius = imageSize.width / 2.0
        
        
        [mainView, recommendView].forEach {
            contentView.addSubview($0)
        }
        
        [recommendLabel].forEach {
            recommendView.addSubview($0)
        }
        
        [imageView, textStackView].forEach {
            mainView.addSubview($0)
        }
        
        [titleLabel, descriptionLabel].forEach {
            textStackView.addArrangedSubview($0)
        }
        
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(mainViewSize.width)
            $0.height.equalTo(mainViewSize.height)
        }
        
        recommendView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(recommendViewSize.width)
            $0.height.equalTo(recommendViewSize.height)
        }
        
        recommendLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(imageSize.width)
            $0.height.equalTo(imageSize.height)
        }
        
        textStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(textStackSize.width)
            $0.height.equalTo(textStackSize.height)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }

    func configure(item: SplitMethod) {
        let image = UIImage(named: item.image)
        imageView.image = image
        titleLabel.text = item.title
        descriptionLabel.text = item.descriptions
        recommendView.isHidden = !item.isRecommended
    }
}


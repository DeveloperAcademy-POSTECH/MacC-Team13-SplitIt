//
//  SplashVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/22.
//

import UIKit
import SnapKit
import Then

class SplashVC: UIViewController {

    let splashImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(splashImage)
        
        splashImage.image = UIImage(named: "SplashImage")
        
        splashImage.snp.makeConstraints {
            $0.width.height.equalTo(280)
            $0.top.equalToSuperview().offset(252)
            $0.centerX.equalToSuperview()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 여기에 애니메이션 또는 다른 작업을 추가할 수 있습니다.
    }
}

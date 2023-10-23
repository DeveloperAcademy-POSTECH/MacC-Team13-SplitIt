//
//  TestVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.


import UIKit
import SnapKit
import RxSwift

protocol TestDelegate {
    func check()
}

class TestVC: UIViewController, TestDelegate {
    func check() {
        print("TestVC의 check 함수")
    }
    

    let btn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btn)
        view.backgroundColor = .white

        btn.setTitle("눌러줘!", for: .normal)
        btn.setTitleColor(.blue, for: .normal) // Use setTitleColor instead of tintColor

        // Add constraints for the button's width and height
        btn.snp.makeConstraints { make in
            make.width.equalTo(100) // Set width
            make.height.equalTo(50) // Set height
            make.center.equalToSuperview()
        }
        
        
        
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    
    }
    
    @objc func buttonTapped() {
        let vc = SecondVC()
        vc.sendDelegate = self
        self.present(vc, animated: true)
    }
}



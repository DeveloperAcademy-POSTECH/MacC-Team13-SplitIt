//
//  TestVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/23.
//

import UIKit
import SnapKit

class SecondVC: UIViewController {

    //var sendDelegate: TestDelegate?
    
    let main = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sendDelegate?.check()
        
        view.addSubview(main)
        view.backgroundColor = .white
        main.text = "으아아아앙"
        
        main.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    
    

 

}

//
//  CustomKeyBoard.swift
//  SplitIt
//
//  Created by cho on 2023/10/26.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then


protocol CustomKeyboardDelegate: AnyObject {
    //func tapKey(value: String)
}

class CustomKeyboard: UIInputViewController {

    private let disposeBag = DisposeBag()
    private let valueSubject = PublishSubject<String>()
    private let customKeySubject = PublishSubject<String>()

    var customKeyObservable: Observable<String> {
        return customKeySubject.asObservable()
    }
    
    var valueObservable: Observable<String> {
            return valueSubject.asObservable()
        }

    weak var delegate: CustomKeyboardDelegate?
    
    
    func tapKey( value: String) {
        customKeySubject.onNext(value)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //근데 inputView 왜 있어야하는지 모르겠음
        let inputView = UIInputView(frame: CGRect(x: 0, y: 0, width: 400, height: 200), inputViewStyle: .keyboard)
        inputView.backgroundColor = .lightGray
        self.inputView = inputView
        
        //키보드 크기 설정
        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        keyboardView.backgroundColor = .green
        
        inputView.addSubview(keyboardView)
        
        //임시로 일단 버튼 하나 생성
        let btn1 = UIButton(type: .custom)
        
        btn1.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(20)
            make.center.equalToSuperview()
        }
        
        btn1.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
            $0.backgroundColor = .red
            $0.setTitle("버튼입니다!", for: .normal)
            $0.setTitleColor(.black, for: .normal)

        }

        btn1.rx.tap
            .map { "버어트은!" }
            .bind(to: customKeySubject)
            .disposed(by: disposeBag)


        //self.inputView = keyboardView
    }
}

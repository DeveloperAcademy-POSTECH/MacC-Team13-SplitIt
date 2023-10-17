//
//  CSMemberConfirmVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

class CSMemberConfirmVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSMemberConfirmVM()
    
    let titleMessage = UILabel()
    let tableView = UITableView()
    let memberCountLabel = UILabel()
    let memberCountDescription = UILabel()
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }

    func setAttribute() {
        view.backgroundColor = .systemBackground

        titleMessage.do {
            $0.text = "입력한 내용이 정확한지 확인해주세요"
        }
        
        nextButton.do {
            $0.setTitle("똑똑한 정산하기", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
        
        setTableView()
    }
    

    
    func setTableView() {
        tableView.do {
            $0.register(cellType: CSMemberConfirmCell.self)
            $0.rowHeight = 35
            $0.separatorStyle = .none
            $0.layer.cornerRadius = 30
            $0.backgroundColor = UIColor(hex: 0xD1D1D1)
            $0.clipsToBounds = true
        }
        
        memberCountDescription.do {
            $0.text = "위 인원으로 정산을 시작합니다."
        }
    }
    
    func setLayout() {
        [titleMessage,nextButton,tableView,memberCountLabel,memberCountDescription].forEach {
            view.addSubview($0)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }


        tableView.snp.makeConstraints {
            $0.top.equalTo(titleMessage).offset(34)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(memberCountLabel.snp.top).offset(-22)
        }

        memberCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(memberCountDescription.snp.top).offset(-7)
        }
        
        memberCountDescription.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-50)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(170)
        }

    }
    
    func setBinding() {
        let input = CSMemberConfirmVM.Input(viewDidLoad: Driver.just(()),
                                                   nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        viewModel.memberList
            .bind(to: tableView.rx.items(cellIdentifier: "CSMemberConfirmCell")) {
                (row, item, cell) in
                if let csCell = cell as? CSMemberConfirmCell {
                    csCell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
        
        output.memberCountText
            .drive(memberCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.showExclCycle
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
//                let vc = ExclItemNameInputVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

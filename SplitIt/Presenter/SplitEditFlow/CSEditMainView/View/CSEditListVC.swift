//
//  CSEditListVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.
//

import UIKit
import Reusable
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class CSEditListVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSEditListVM()
    
    let header = NavigationHeader()
    
    let titleEditBtn = UIButton(type: .system)
    let titleLabel = UILabel()
    lazy var titleStackView: UIStackView = {
        return setStackView(titleBtn: titleEditBtn ,
                            st: "이름",
                            view: titleLabel)
    }()
    let totalAmountEditBtn = UIButton(type: .system)
    let totalAmountLabel = UILabel()
    lazy var totalAmountStack: UIStackView = {
        return setStackView(titleBtn: totalAmountEditBtn ,
                            st: "사용한 총액",
                            view: totalAmountLabel)
    }()
    let memberEditBtn = UIButton(type: .system)
    let memberLabel = UILabel()
    lazy var memberStack: UIStackView = {
        return setStackView(titleBtn: memberEditBtn ,
                            st: "함께한 사람들",
                            view: memberLabel)
    }()
    
    let tableHeaderLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    let exclAddButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let delButton = UIButton(type: .system)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.configureBackButton(viewController: self)
            $0.configureTitle(title: "모임 수정하기")
        }
        
        tableHeaderLabel.do { label in
            label.text = "따로 계산할 것"
            label.textColor = .lightGray
            label.font = .systemFont(ofSize: 12)
        }
        
        tableView.do { view in
            view.register(cellType: CSEditListCell.self)
            view.rowHeight = UITableView.automaticDimension
            view.estimatedRowHeight = 43
            view.isScrollEnabled = false
            view.backgroundColor = UIColor(hex: 0xF8F7F4)
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
        }
        
        exclAddButton.do { btn in
            btn.setTitle("따로 계산할 것 추가하기", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 12)
            btn.setTitleColor(.lightGray, for: .normal)
        }
        
        saveButton.do { btn in
            btn.setTitle("수정하기", for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 24
        }
        
        delButton.do { btn in
            btn.setTitle("삭제하기", for: .normal)
            btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
            btn.setTitleColor(.lightGray, for: .normal)
        }
        
    }
    
    func setLayout() {
        
        [header, titleStackView, totalAmountStack, memberStack, tableHeaderLabel,tableView, exclAddButton, saveButton, delButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(25)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        totalAmountStack.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        memberStack.snp.makeConstraints { make in
            make.top.equalTo(totalAmountStack.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        tableHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(memberStack.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableHeaderLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
            viewModel.itemsObservable
                .map { $0.count * 43 }
                .subscribe { int in
                    make.height.equalTo(int)
                }
                .disposed(by: disposeBag)
//            make.height.equalTo()
        }
        
        exclAddButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleStackView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(93)
            make.height.equalTo(48)
        }
        
        delButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleStackView)
            make.top.equalTo(saveButton.snp.bottom).offset(29)
        }
        
    }
    
    func setBinding() {
        viewModel.titleObservable
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalObservable
            .bind(to: totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.membersObservable
            .bind(to: memberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.itemsObservable
            .bind(to: tableView.rx.items(cellIdentifier: "CSEditListCell", cellType: CSEditListCell.self)) { _, item, cell in
                cell.csTitleLabel.text = "\(item.name) 값"
            }
            .disposed(by: disposeBag)
        
        let input = CSEditListVM.Input(titleBtnTap: titleEditBtn.rx.tap,
                                              totalPriceTap: totalAmountEditBtn.rx.tap,
                                              memberTap: memberEditBtn.rx.tap,
                                       exclItemTap: tableView.rx.itemSelected.asControlEvent(), delCSInfoTap: delButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.pushTitleEditVC
            .subscribe(onNext: { self.pushTitleEditViewController()})
            .disposed(by: disposeBag)
        output.pushPriceEditVC
            .subscribe(onNext: { self.pushTotalPriceEditViewController()})
            .disposed(by: disposeBag)
        output.pushMemberEditVC
            .subscribe(onNext: { self.pushMemberEditViewController()})
            .disposed(by: disposeBag)
        output.pushExclItemEditVC
            .subscribe(onNext: {
                self.pushExclItemEditViewController(index: $0)
            })
            .disposed(by: disposeBag)
//        output.popDelCSInfo
//            .subscribe { }
//            .disposed(by: disposeBag)
    }

}


// MARK: CSEditListView/Navigation-PUSH
extension CSEditListVC {
    private func pushTitleEditViewController() {
        let vc = CSTitleEditVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func pushTotalPriceEditViewController() {
        let vc = CSTotalAmountEditVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushMemberEditViewController() {
        let vc = CSMemberEditVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushExclItemEditViewController(index: IndexPath) {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .white
//        navigationController?.pushViewController(vc, animated: true)
    }
}


func setStackView(titleBtn: UIButton, st: String, view: UILabel) -> UIStackView {
    let titleLB = UILabel()
    titleLB.do { label in
        label.text = st
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
    }
    
    titleBtn.do { button in
        button.setTitle("수정하기", for: .normal)
        button.tintColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .left
    }
    
    let roundView = UIView(frame: .zero)
    roundView.do { view in
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
    }
    
    view.font = .systemFont(ofSize: 15)
    
    [view, titleBtn].forEach { view in
        roundView.addSubview(view)
    }
    
    view.snp.makeConstraints { make in
        make.leading.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
    }
    
    titleBtn.snp.makeConstraints { make in
        make.trailing.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
    }
    
    roundView.snp.makeConstraints { make in
        make.height.equalTo(43)
    }
    
    let titleStackView = UIStackView(arrangedSubviews: [titleLB,roundView])
    titleStackView.do { stack in
        stack.axis = .vertical
        stack.spacing = 4
    }
    
    return titleStackView
}

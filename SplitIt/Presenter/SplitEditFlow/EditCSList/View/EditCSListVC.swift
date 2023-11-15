//
//  EditCSListVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/30.
//

import UIKit
import Reusable
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxAppState
import RealmSwift

final class EditCSListVC: UIViewController, UIScrollViewDelegate {
    
    var disposeBag = DisposeBag()
    var viewModel = EditCSListVM()
    
    let headerView = SPNavigationBar()
    let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        setKeyboardNotification()
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        headerView.do {
            $0.applyStyle(style: .splitEdit, vc: self)
        }
        
        tableView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.register(cellType: EditCSListCell.self)
            $0.rowHeight = 208
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rx.event.bind { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            }.disposed(by: disposeBag)
            
            $0.addGestureRecognizer(tapGesture)
            tapGesture.delegate = self
            
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
        
    }
    
    func setLayout() {
        
        [headerView, tableView].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setBinding() {
        let input = EditCSListVM.Input(
                                    viewDidLoad: self.rx.viewWillAppear,
                                     csEditTapped: tableView.rx.itemSelected)
        
        viewModel.csinfoList
            .drive(tableView.rx.items(cellIdentifier: "EditCSListCell", cellType: EditCSListCell.self)) { [weak self] (idx, item, cell) in
                guard let self = self else { return }
                let memberCount = self.viewModel.memberCount()
                let exclCount = self.viewModel.exclItemCount()
                cell.configure(csinfo: item, csMemberCount: memberCount[idx], exclItemCount: exclCount[idx])
            }
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.pushCSEditView
            .drive(onNext: { [weak self] csinfoIdx in
                guard let self = self else { return }
                let vc = EditCSItemVC(csinfoIdx: csinfoIdx)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension EditCSListVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.tableView)
    }
}

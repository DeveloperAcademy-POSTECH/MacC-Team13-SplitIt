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

final class EditCSListVC: UIViewController, UIScrollViewDelegate {
    
    var disposeBag = DisposeBag()
    let viewModel = EditCSListVM()
    
    let headerView = SPNavigationBar()
    let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SplitRepository.share.fetchSplitArrFromDBWithSplitIdx(splitIdx: viewModel.splitIdx)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setBinding() {
        let input = EditCSListVM.Input(viewDidAppear: self.rx.viewDidAppear,
                                       csEditTapped: tableView.rx.itemSelected)
        
        let output = viewModel.transform(input: input)
        
        output.csInfoList
            .drive(tableView.rx.items(cellIdentifier: "EditCSListCell", cellType: EditCSListCell.self)) { [weak self] (idx, item, cell) in
                guard let self = self else { return }
                let memberCount = output.memberCount
                let exclCount = output.exclItemCount
                
                Driver.combineLatest(memberCount, exclCount)
                    .drive { (members, excls) in
                        guard idx < members.count, idx < excls.count else { return }
                        cell.configure(csinfo: item, csMemberCount: members[idx], exclItemCount: excls[idx])
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.pushCSEditView
            .drive(onNext: { [weak self] csinfoIdx in
                guard let self = self else { return }
                let vc = EditCSItemVC(csinfoIdx: csinfoIdx)
                self.navigationController?.pushViewController(vc, animated: true)
                SplitRepository.share.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: csinfoIdx)
            })
            .disposed(by: disposeBag)
    }
    
}


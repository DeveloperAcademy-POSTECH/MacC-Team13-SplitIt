//
//  SplitShareVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import RxCocoa
import RxSwift
import RxAppState
import Then
import SnapKit
import Reusable
import SnapshotKit
import Toast

class SplitShareVC: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = SplitShareVM()
    
    let header = SPNavigationBar()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let csAddButton = SPButton()
    let editButton = SPButton()
    let shareButton = SPButton()
    
    let popUpBackGroundView = UIView()
    let popUpView = SPPopUp()
    let popUpTapGesture = UITapGestureRecognizer()
    
    var splitDate: Date = .now
    
    var resultArr: [SplitMemberResult] = []
    var csInfos: [CSInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBind()
        
        if UserDefaults.standard.string(forKey: "userBank") == nil { setPopUp() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .createToShare, vc: self)
        }
        
        tableView.do {
            $0.separatorStyle = .none
            $0.delegate = self
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.register(cellType: SplitShareTableCell.self)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
            $0.showsVerticalScrollIndicator = false
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        csAddButton.do {
            $0.applyStyle(style: .primaryMushroom, shape: .square)
            $0.buttonState.accept(true)
        }
        
        editButton.do {
            $0.applyStyle(style: .primaryCalmshell, shape: .square)
            $0.setImage(UIImage(systemName: "pencil"), for: .normal)
            $0.tintColor = .TextPrimary
            $0.setTitle(" 정산 수정", for: .normal)
            $0.buttonState.accept(true)
        }
        
        shareButton.do {
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.setTitle("영수증 공유하기", for: .normal)
            $0.buttonState.accept(true)
        }
    }
    
    private func setLayout() {
        [header,tableView,csAddButton,editButton,shareButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(csAddButton.snp.top).offset(-24)
        }
        
        csAddButton.snp.makeConstraints {
            $0.bottom.equalTo(shareButton.snp.top).offset(-40)
            $0.leading.equalToSuperview().offset((UIScreen.main.bounds.width - 276) / 2)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalTo(csAddButton.snp.bottom)
            $0.leading.equalTo(csAddButton.snp.trailing).offset(16)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    private func setBind() {
        let input = SplitShareVM.Input(viewDidAppear: self.rx.viewDidAppear,
                                       shareButtonTapped: shareButton.rx.tap,
                                       csAddButtonTapped: csAddButton.rx.tap,
                                       editButtonTapped: editButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.splitResult
            .asDriver()
            .drive(onNext: { [weak self] results in
                guard let self = self else { return }
                self.resultArr = results
            })
            .disposed(by: disposeBag)
        
        output.csInfos
            .asDriver()
            .drive(onNext: { [weak self] csInfos in
                guard let self = self else { return }
                self.csInfos = csInfos
                csAddButton.setTitle("+ \(csInfos.count+1)차 추가", for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.split
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.splitDate = $0.map { $0.createDate }.first ?? .now
            })
            .disposed(by: disposeBag)
        
        output.splitResult
            .bind(to: tableView.rx.items(cellIdentifier: "SplitShareTableCell")) { indexPath, item, cell in
                if let cell = cell as? SplitShareTableCell {
                    cell.configure(item: item, indexPath: indexPath)
                }
            }
            .disposed(by: disposeBag)
        
        output.sendPayString
            .drive(onNext: { [weak self] sendPayString in
                guard let self = self else { return }
                self.tableView.layer.borderColor = UIColor.clear.cgColor
                self.tableView.layer.cornerRadius = 0
                let image = self.tableView.takeSnapshotOfFullContent()
                
                var items: [Any] = []
                
                if sendPayString != "" { items.append(sendPayString) }
                items.append(image as Any)
                
                let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                vc.excludedActivityTypes = [.saveToCameraRoll]
                self.present(vc, animated: true)
                
                self.tableView.layer.borderColor = UIColor.BorderPrimary.cgColor
                self.tableView.layer.cornerRadius = 8
                
                vc.completionWithItemsHandler = { activity, success, items, error in
                    if success {
                        var style = ToastStyle()
                        style.messageFont = .KoreanCaption1
                        self.view.makeToast("  ✓  공유가 완료되었습니다!  ", duration: 3.0, position: .top, style: style)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.showNewCSCreateFlow
            .asDriver()
            .drive(onNext: {
                let vc = SplitMethodSelectVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showCSEditView
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = EditCSListVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        popUpTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.removePopUp()
            })
            .disposed(by: disposeBag)
    }
    
    private func setPopUp() {
        popUpBackGroundView.do {
            $0.backgroundColor = .black
            $0.layer.opacity = 0.6
            $0.addGestureRecognizer(popUpTapGesture)
        }
        
        popUpView.do {
            $0.applyStyle(style: .goToMyInfo, vc: self)
        }
        
        [popUpBackGroundView,popUpView].forEach {
            view.addSubview($0)
        }
        
        popUpBackGroundView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        popUpView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(35)
        }
    }
    
    private func removePopUp() {
        popUpBackGroundView.removeFromSuperview()
        popUpView.removeFromSuperview()
    }
}

extension SplitShareVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SplitShareSectionHeader()
        headerView.configure(item: self.csInfos, splitDate: splitDate)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count = csInfos.count
        var defaultHeight: CGFloat = 134
        
        if count > 0 { defaultHeight += 18 }
        
        let headerHeight = defaultHeight + CGFloat(count * 22)
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = SplitShareSectionFooter()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = resultArr[indexPath.row].exclDatas.count
        var defaultHeight: CGFloat = 60
        
        if count > 0 { defaultHeight += 16 }
        
        let cellHeight = defaultHeight + CGFloat(count * 19)
        return cellHeight
    }
}

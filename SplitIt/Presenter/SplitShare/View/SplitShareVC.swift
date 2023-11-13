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
    let mainTitle = UILabel()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let csAddButton = SPButton()
    let editButton = SPButton()
    let shareButton = SPButton()
    
    var splitDate: Date = .now
    
    var resultArr: [SplitMemberResult] = []
    var csInfos: [CSInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBind()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .print, vc: self)
        }
        
        mainTitle.do {
            $0.text = "영수증을 스크롤하여 확인해보세요"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
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
        }
        
        csAddButton.do {
            $0.applyStyle(style: .primaryMushroom, shape: .square)
            $0.buttonState.accept(true)
        }
        
        editButton.do {
            $0.applyStyle(style: .primaryCalmshell, shape: .square)
            $0.setTitle("✎ 정산 수정", for: .normal)
            $0.buttonState.accept(true)
        }
        
        shareButton.do {
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.setTitle("정산자의 확인을 기다리고 있어요", for: .disabled)
            $0.setTitle("친구에게 영수증 공유하기", for: .normal)
            $0.buttonState.accept(true)
        }
    }
    
    private func setLayout() {
        [header,mainTitle,tableView,csAddButton,editButton,shareButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(24)
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
        let input = SplitShareVM.Input(viewWillAppear: self.rx.viewWillAppear,
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
                let image = self.tableView.takeSnapshotOfFullContent()
                
                var items: [Any] = []
                
                if sendPayString != "" { items.append(sendPayString) }
                items.append(image as Any)
                
                let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                vc.excludedActivityTypes = [.saveToCameraRoll]
                self.present(vc, animated: true)
                
                self.tableView.layer.borderColor = UIColor.BorderPrimary.cgColor
                
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
        var defaultHeight: CGFloat = 100
        
        if count > 0 { defaultHeight += 18 }
        
        let headerHeight = defaultHeight + CGFloat(count * 20)
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = SplitShareSectionFooter()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = resultArr[indexPath.row].exclDatas.count
        var defaultHeight: CGFloat = 44
        
        if count > 0 { defaultHeight += 16 }
        
        let cellHeight = defaultHeight + CGFloat(count * 18)
        return cellHeight
    }
}

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

class SplitShareVC: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = SplitShareVM()
    
    let header = NaviHeader()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let csAddButton = NewSPButton()
    let editButton = NewSPButton()
    let shareButton = NewSPButton()
    
    var splitDate: Date = .now
    
    var resultArr: [SplitMemberResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBind()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(.print)
            $0.setBackButton(viewController: self)
        }
        
        tableView.do {
            $0.separatorStyle = .none
            $0.delegate = self
            $0.backgroundColor = UIColor(red: 0.9915664792, green: 0.9719635844, blue: 0.9203471541, alpha: 1)
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.register(cellType: SplitShareTableCell.self)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
        }
        
        csAddButton.do {
            $0.applyStyle(style: .smallButton, shape: .square)
            $0.setTitle("+ 2차 추가", for: .normal)
            $0.buttonState.accept(true)
        }
        
        editButton.do {
            $0.applyStyle(style: .smallButton, shape: .square)
            $0.setTitle("✎ 정산 수정", for: .normal)
            $0.buttonState.accept(true)
        }
        
        shareButton.do {
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.setTitle("정산자의 확인을 기다리고 있어요", for: .disabled)
            $0.setTitle("친구에게 영수증 공유하기", for: .normal)
        }
    }
    
    private func setLayout() {
        [header,tableView,csAddButton,editButton,shareButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(24)
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
                                       viewDidAppear: self.rx.viewDidAppear,
                                       shareButtonTapped: shareButton.rx.tap,
                                       currentTableViewScrollState: tableView.rx.contentOffset,
                                       tableView: tableView,
                                       csAddButtonTapped: csAddButton.rx.tap,
                                       editButtonTapped: editButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        resultArr = output.splitResult.value
        
        output.splitResult
            .bind(to: tableView.rx.items(cellIdentifier: "SplitShareTableCell")) { _, item, cell in
                if let cell = cell as? SplitShareTableCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
        
        output.split
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.splitDate = $0.map { $0.createDate }.first!
            })
            .disposed(by: disposeBag)
        
        output.buttonState
            .asDriver()
            .drive(shareButton.buttonState)
            .disposed(by: disposeBag)
        
        output.sendItems
            .asDriver()
            .drive(onNext: { items in
                if items.count != 0 {
                    let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    vc.excludedActivityTypes = [.saveToCameraRoll]
                    self.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.showNewCSCreateFlow
            .asDriver()
            .drive(onNext: {
                let vc = CSInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showCSEditView
            .asDriver()
            .drive(onNext: {
                // EditView로 이동하기
            })
            .disposed(by: disposeBag)
    }
}

extension SplitShareVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SplitShareSectionHeader()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        headerView.dateLabel.text = "정산 날짜: \(dateFormatter.string(from: splitDate))"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = resultArr[indexPath.row].exclDatas.count
        var defaultHeight: CGFloat = 44
        
        if count > 0 { defaultHeight += 16 }
        
        let cellHeight = defaultHeight + CGFloat(count * 18)
        return cellHeight
    }
}

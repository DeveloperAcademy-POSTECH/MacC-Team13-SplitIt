//
//  SplitShareVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit
import Reusable

class SplitShareVC: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = SplitShareVM()
    
    let header = NaviHeader()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let shareButton = SPButton()
    
    var splitTitle: String = ""
    var splitDate: Date = .now
    
    var resultArr: [SplitMemberResult] = []
    
//    var splitIdx: String = "65367d4f7748e5fbfe959b18"
    var splitIdx: String = "6536a2d87c3bdd7453335f7b"
    
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
            $0.dataSource = self
            $0.backgroundColor = .SurfacePrimary
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
            $0.register(cellType: SplitShareTableCell.self)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
        }
        
        shareButton.do {
            $0.setTitle("친구에게 영수증 공유하기", for: .normal)
            $0.applyStyle(.primaryWatermelon)
            $0.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        [header,tableView,shareButton].forEach {
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
            $0.bottom.equalTo(shareButton.snp.top).offset(-82)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    private func setBind() {
        let input = SplitShareVM.Input(viewWillAppear: Driver<Void>.just(()), splitIdx: splitIdx)
        let output = viewModel.transform(input: input)
        
        resultArr = output.splitResult.value
        
        output.split
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.splitTitle = $0.map { $0.title }.first!
                self.splitDate = $0.map { $0.createDate }.first!
            })
            .disposed(by: disposeBag)
    }
    
    @objc func shareButtonTapped() {
        guard let image = tableView.screenshot() else { return }
        let items: [Any] = [image, "성공성공~~"]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.excludedActivityTypes = [.saveToCameraRoll]
                present(vc, animated: true)
    }
}

extension SplitShareVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SplitShareSectionHeader()
        headerView.titleLabel.text = splitTitle
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        headerView.dateLabel.text = dateFormatter.string(from: splitDate)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = resultArr[indexPath.row].exclDatas.count
        
        var defaultHeight: CGFloat = 44
        
        if count > 0 {
            defaultHeight += 16
        }
        
        let cellHeight = defaultHeight + CGFloat(count * 16)
        
        return cellHeight
    }
}

extension SplitShareVC: UITableViewDataSource, Reusable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as SplitShareTableCell
        cell.selectionStyle = .none
        cell.nameLabel.text = resultArr[indexPath.row].memberName
        cell.priceLabel.text = NumberFormatter.localizedString(from: resultArr[indexPath.row].memberPrice as NSNumber, number: .decimal)
        if !cell.isCheck {
            cell.setExclDatas(item: resultArr[indexPath.row].exclDatas)
            cell.setLine()
        }
        cell.isCheck = true
        
        return cell
    }
}

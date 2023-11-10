//
//  JSDetailVC.swift
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

final class JSDetailVC: UIViewController, UIScrollViewDelegate, SPAlertDelegate {
    
    var disposeBag = DisposeBag()
    var viewModel = JSDetailVM()
    
    let headerView = SPNavigationBar()
    let collectionView = UITableView(frame: .zero)
    let splitTitleTF = SPTextField()
    let textFiledCounter = UILabel()
    let titleLabel = UILabel()
    
    var cellHeight = [0.0]
    
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
        
        titleLabel.do {
            $0.text = "이름이 있으면 나중에 찾기 쉬워요"
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        splitTitleTF.do {
            $0.textColor = .TextPrimary
            $0.placeholder = "ex) 팀 회식, 생일파티, 집들이"
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.applyStyle(.normal)
        }
        
        textFiledCounter.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        collectionView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.register(cellType: JSDetailCell.self)
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
        let divider = UIView().then {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
        }
        
        [headerView, titleLabel, splitTitleTF, textFiledCounter, divider, collectionView].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(38)
        }
        
        splitTitleTF.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(46)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(splitTitleTF.snp.bottom).offset(6)
            $0.trailing.equalTo(splitTitleTF.snp.trailing).inset(5)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(splitTitleTF.snp.bottom).offset(40)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(divider.snp.bottom).offset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setBinding() {
        viewModel.csinfoList
            .drive(collectionView.rx.items(cellIdentifier: "JSDetailCell", cellType: JSDetailCell.self)) { [weak self] idx, item, cell in
                guard let self = self else { return }
                let memberCount = self.viewModel.memberCount()
                let exclCount = self.viewModel.exclItemCount()
                cell.configure(csinfo: item, csMemberCount: memberCount[idx], exclItemCount: exclCount[idx])
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
                let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                self.cellHeight.append(size)
            }
            .disposed(by: disposeBag)
        
        let input = JSDetailVM.Input(
                                    viewDidLoad: self.rx.viewWillAppear,
                                     title: splitTitleTF.rx.text.orEmpty.asDriver(),
                                     csEditTapped: collectionView.rx.itemSelected)
        
        let output = viewModel.transform(input: input)
        
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? .TextSecondary
                : .AppColorStatusError
            })
            .disposed(by: disposeBag)
        
        output.splitTitle
            .drive(splitTitleTF.rx.text)
            .disposed(by: disposeBag)
        
        output.pushCSEditView
            .drive(onNext: { [weak self] csinfoIdx in
                guard let self = self else { return }
                let vc = EditCSListVC(csinfoIdx: csinfoIdx)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension JSDetailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.collectionView)
    }
}

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

final class JSDetailVC: UIViewController {
    
    var disposeBag = DisposeBag()
    var viewModel = JSDetailVM()
    
    let headerView = NaviHeader()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let nextButton = NewSPButton()
    let splitTitleTF = SPTextField()
    let textFiledCounter = UILabel()
    let textFiledNotice = UILabel()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        headerView.do {
            $0.applyStyle(.edit)
            $0.setBackButton(viewController: self)
        }
        
        titleLabel.do {
            $0.text = "영수증 이름을 지어보세요"
            $0.textColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        splitTitleTF.do {
            $0.applyStyle(.normal)
            $0.font = .KoreanCaption1
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        textFiledCounter.do {
            $0.font = .KoreanCaption2
        }
        
        textFiledNotice.do {
            $0.text = "ex) 팀 회식, 생일파티, 집들이"
            $0.font = .KoreanCaption1
//            $0.textColor = .TextSecondary
            $0.textColor = .TextDeactivate
        }
        
        collectionView.do {
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.register(cellType: JSDetailCell.self)
            let layout = UICollectionViewFlowLayout()
//            layout.estimatedItemSize = .init(width: 330, height: 208)
            layout.itemSize = .init(width: 330, height: 208)
            $0.collectionViewLayout = layout
        }
        
        nextButton.do {
            $0.buttonState.accept(true)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
            $0.setTitle("영수증에 반영하기", for: .normal)
        }
    }
    
    func setLayout() {
        let divider = UIView().then {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
        }
        [headerView, titleLabel, splitTitleTF, textFiledCounter, textFiledNotice, divider, collectionView, nextButton].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        textFiledNotice.snp.makeConstraints {
            $0.centerY.equalTo(splitTitleTF)
            $0.leading.equalTo(splitTitleTF).inset(15)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(splitTitleTF.snp.bottom).offset(40)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(divider.snp.bottom).offset(24)
            $0.height.equalTo(410)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
        
    }
    
    func setBinding() {
        viewModel.csinfoList
            .drive(collectionView.rx.items(cellIdentifier: "JSDetailCell", cellType: JSDetailCell.self)) { idx, item, cell in
                cell.configure(csinfo: item, csMemberCount: 5, exclItemCount: 5)
            }
            .disposed(by: disposeBag)
        
        let input = JSDetailVM.Input(viewDidLoad: self.rx.viewDidLoad,
                                     nextButtonTapped: nextButton.rx.tap,
                                     title: splitTitleTF.rx.text.orEmpty.asDriver(),
                                     csEditTapped: collectionView.rx.itemSelected)
        
        let output = viewModel.transform(input: input)
        
        output.splitTitle
            .drive(splitTitleTF.rx.text)
            .disposed(by: disposeBag)
        
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldIsEmpty
            .map { [weak self] bool in
                guard let self = self else { return false }
                self.textFiledNotice.isHidden = bool
                return bool
            }
            .drive(nextButton.buttonState)
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
        
        output.textFieldIsValid
            .map { [weak self] isValid -> String in
                guard let self = self else { return "" }
                if !isValid {
                    return String(self.splitTitleTF.text?.prefix(self.viewModel.maxTextCount) ?? "")
                } else {
                    return self.splitTitleTF.text ?? ""
                }
            }
            .drive(splitTitleTF.rx.text)
            .disposed(by: disposeBag)
    }
    
}

//
//  ExclItemInputVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import RxGesture

class ExclItemInputVC: UIViewController, SPAlertDelegate {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclItemInputVM()
    
    var backAlert = SPAlertController()
    var exitAlert = SPAlertController()
    var isExit: Bool? = nil
    
    let header = SPNavigationBar()
    let exclListLabel = UILabel()
    let textDivider = UILabel()
    let exclItemCountLabel = UILabel()
    let exclItemAddButton = SPButton()
    
    let contentView = UIView()
    let emptyView = ExclItemInputEmptyView()
    let tableView = UITableView(frame: .zero)
    
    let nextButton = SPButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .exclItemCreate, vc: self)
        }
        
        exclListLabel.do {
            $0.text = "따로 정산 목록"
            $0.font = .KoreanSubtitle
            $0.textColor = .TextPrimary
        }
        
        textDivider.do {
            $0.text = "|"
            $0.font = .KoreanSubtitle
            $0.textColor = .TextSecondary
        }
        
        exclItemCountLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        exclItemAddButton.do {
            $0.setTitle("항목 추가", for: .normal)
            $0.buttonState.accept(true)
            $0.applyStyle(style: .primaryWatermelon, shape: .square)
            $0.titleLabel?.font = .KoreanSmallButtonText
        }
        
        nextButton.do {
            $0.setTitle("정산 결과 확인하기", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
        }
        
        setTableView()
    }
    
    func setTableView() {
        let rowHeight = 126.0 + 16.0
        tableView.do {
            $0.register(cellType: ExclItemCell.self)
            $0.backgroundColor = .SurfacePrimary
            $0.showsVerticalScrollIndicator = false
            $0.rowHeight = rowHeight
            $0.separatorStyle = .none
        }
    }
    
    func setLayout() {
        [header, exclListLabel, textDivider, exclItemCountLabel, exclItemAddButton, tableView, emptyView, nextButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        exclListLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(34)
        }
        
        textDivider.snp.makeConstraints {
            $0.centerY.equalTo(exclListLabel)
            $0.leading.equalTo(exclListLabel.snp.trailing).offset(4)
        }
        
        exclItemCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(exclListLabel)
            $0.leading.equalTo(textDivider.snp.trailing).offset(4)
        }
        
        exclItemAddButton.snp.makeConstraints {
            $0.centerY.equalTo(exclListLabel).offset(-3)
            $0.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(24)
            $0.width.equalTo(exclItemAddButton.snp.height).multipliedBy(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(exclListLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.top)
            $0.leading.trailing.equalTo(tableView)
            $0.height.equalTo(emptyView.snp.width).dividedBy(3)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(33)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        // MARK: Alert가 존재할 때 Swipe Back Left Side 감지
        let swipeBackLeftSideObservable = self.view.rx.panGesture()
            .when(.began)
            .filter { gesture in
                let location = gesture.location(in: self.view)
                return location.x < 20
                && !(self.navigationController?.interactivePopGestureRecognizer!.isEnabled)!
            }

        let input = ExclItemInputVM.Input(viewDidDisappear: self.rx.viewDidDisappear,
                                          nextButtonTapped: nextButton.rx.tap,
                                          exclItemAddButtonTapped: exclItemAddButton.rx.tap,
                                          exitButtonTapped: header.rightButton.rx.tap,
                                          backButtonTapped: header.leftButton.rx.tap,
                                          swipeBack: swipeBackLeftSideObservable)
        //MARK: swipeBack을 하면 Alert가 뜨도록!
        let output = viewModel.transform(input: input)
        
        output.exclItemsRelay
            .map{ "\($0.count)건" }
            .asDriver(onErrorJustReturn: "")
            .drive(exclItemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.exclItemsRelay
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "ExclItemCell", cellType: ExclItemCell.self)) { (idx, item, cell) in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        output.nextButtonIsEnable
            .drive(nextButton.buttonState)
            .disposed(by: disposeBag)
        
        output.showExclItemInfoModal
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = ExclItemInfoAddModalVC()
                vc.modalPresentationStyle = .formSheet
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showEmptyView
            .drive(onNext: { [weak self] tableViewisEmpty in
                guard let self = self else { return }
                emptyView.isHidden = !tableViewisEmpty
                tableView.isHidden = tableViewisEmpty
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let exclItemIdx = output.exclItemsRelay.value[indexPath.row].exclItem.exclItemIdx
                let vm = ExclItemInfoEditModalVM()
                vm.exclItemIdx = exclItemIdx
                let vc = ExclItemInfoEditModalVC(viewModel: vm)
                
                vc.modalPresentationStyle = .formSheet
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.exclItemsRelay
            .asDriver()
            .map { $0.count == 0 }
            .drive(onNext: { [weak navigationController] shouldPop in
                navigationController?.interactivePopGestureRecognizer?.isEnabled = shouldPop
            })
            .disposed(by: disposeBag)

        output.showResultView
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                SplitRepository.share.updateDataToDB()
                let vc = SplitShareVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showBackAlert
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let itemCount = output.exclItemsRelay.value.count
                if itemCount > 0 {
                    self.showAlert(view: backAlert,
                              type: .warnNormal,
                              title: "정산 멤버를 다시 선택하시겠어요?",
                              descriptions: "추가한 따로 정산 목록 \(itemCount)개가 사라져요",
                              leftButtonTitle: "취 소",
                              rightButtonTitle: "다시 선택")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.showExitAlert
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showExitAlert(view: exitAlert)
            })
            .disposed(by: disposeBag)
        
        backAlert.rightButtonTapSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        exitAlert.rightButtonTapSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleExitAlertButtonTap()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleExitAlertButtonTap() {
        guard let navigationController = navigationController else { return }

        if let splitShareVC = navigationController.viewControllers.first(where: { $0 is SplitShareVC }) as? SplitShareVC {
            navigationController.popToViewController(splitShareVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

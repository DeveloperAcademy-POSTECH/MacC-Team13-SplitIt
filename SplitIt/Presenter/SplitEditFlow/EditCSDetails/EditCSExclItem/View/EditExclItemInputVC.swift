//
//  EditCSExclItemVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import Toast

class EditExclItemInputVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = EditExclItemInputVM()
    
    let header = SPNavigationBar()
    let exclListLabel = UILabel()
    let exclItemCountLabel = UILabel()
    let exclItemAddButton = SPButton()
    
    let contentView = UIView()
    let emptyView = ExclItemInputEmptyView()
    let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        header.do {
            $0.applyStyle(style: .editExclItemList, vc: self)
        }
        
        exclListLabel.do {
            let numberAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.KoreanSubtitle,
                .foregroundColor: UIColor.TextPrimary,
            ]

            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.KoreanSubtitle,
                .foregroundColor: UIColor.TextSecondary
            ]
            
            let numberString = NSAttributedString(string: "목록", attributes: numberAttributes)
            let textString = NSAttributedString(string: " |", attributes: textAttributes)

            let finalString = NSMutableAttributedString()
            finalString.append(numberString)
            finalString.append(textString)
            $0.attributedText = finalString
        }
        
        exclItemCountLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
            $0.textAlignment = .justified
        }
        
        exclItemAddButton.do {
            $0.setTitle("항목 추가", for: .normal)
            $0.buttonState.accept(true)
            $0.applyStyle(style: .primaryWatermelon, shape: .square)
            $0.titleLabel?.font = .KoreanSmallButtonText
        }
        
        setTableView()
    }
    
    func setTableView() {
        let rowHeight = 129.0 + 8.0
        tableView.do {
            $0.register(cellType: ExclItemCell.self)
            $0.backgroundColor = .SurfacePrimary
            $0.showsVerticalScrollIndicator = false
            $0.rowHeight = rowHeight
            $0.separatorStyle = .none
        }
    }
    
    func setLayout() {
        [header, exclListLabel, exclItemCountLabel, exclItemAddButton, tableView, emptyView].forEach {
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
        
        exclItemCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(exclListLabel)
            $0.leading.equalTo(exclListLabel.snp.trailing).offset(4)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.top)
            $0.leading.trailing.equalTo(tableView)
            $0.height.equalTo(emptyView.snp.width).dividedBy(3)
        }
    }
    
    func setBinding() {
        let input = EditExclItemInputVM.Input(backToReceiptTapped: header.rightButton.rx.tap,
                                              exclItemAddButtonTapped: exclItemAddButton.rx.tap)
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
        
        output.showSplitShareView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.viewControllers.forEach {
                    if let vc = $0 as? SplitShareVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.exclItemNotification
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self else { return }
                showToast(notificationName: notification.name)
            })
            .disposed(by: disposeBag)
    }
    
    func showToast(notificationName: Notification.Name) {
        var style = ToastStyle()
        style.messageFont = .KoreanCaption1
        
        switch notificationName {
        case .exclItemIsAdded:
            self.view.makeToast("  ✓  추가가 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
        case .exclItemIsEdited:
            self.view.makeToast("  ✓  수정이 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
        case .exclItemIsDeleted:
            self.view.makeToast("  ✓  삭제가 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
        default:
            break
        }
    }
}

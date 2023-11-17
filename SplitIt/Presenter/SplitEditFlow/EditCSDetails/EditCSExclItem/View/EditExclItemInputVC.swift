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
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        header.do {
            $0.applyStyle(style: .editExclItemList, vc: self)
        }
        
        exclListLabel.do {
            $0.text = "따로 정산 목록"
            $0.font = .KoreanSubtitle
            $0.textColor = .TextPrimary
        }
        
        exclItemCountLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        exclListLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(34)
        }
        
        exclItemCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(exclListLabel.snp.bottom)
            $0.leading.equalTo(exclListLabel.snp.trailing).offset(8)
        }
        
        exclItemAddButton.snp.makeConstraints {
            $0.bottom.equalTo(exclListLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(24)
            $0.width.equalTo(exclItemAddButton.snp.height).multipliedBy(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(exclListLabel.snp.bottom).offset(12)
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
        let input = EditExclItemInputVM.Input(viewDidDisAppear: self.rx.viewDidAppear,
                                              nextButtonTapped: header.rightButton.rx.tap,
                                          exclItemAddButtonTapped: exclItemAddButton.rx.tap)
        Driver.just(true)
            .drive(header.buttonState)
            .disposed(by: disposeBag)
        
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
        
        output.exclItemsRelay
            .asDriver()
            .distinctUntilChanged{ (prev, cur) in
                print("1")
                print("prev: \(prev)")
                print("cur: \(cur)")
                if output.showToastMessage.value {
                    print("2")
                    self.processChanges(previousItems: prev, currentItems: cur)
                }
                output.showToastMessage.accept(true)
                return false
            }
        
//            .scan([ExclItemInfo]()){ (prev, cur) in
//                print("1")
//                print("prev: \(prev)")
//                print("cur: \(cur)")
//                if output.showToastMessage.value {
//                    print("2")
//                    self.processChanges(previousItems: prev, currentItems: cur)
//                }
//                output.showToastMessage.accept(true)
//                return cur
//            }
            .drive()
            .disposed(by: disposeBag)
           
            
        
//        output.nextButtonIsEnable
//            .drive(nextButton.buttonState)
//            .disposed(by: disposeBag)
        
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
        
        output.showResultView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.viewControllers.forEach {
                    if let vc = $0 as? SplitShareVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        header.leftButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                SplitRepository.share.updateDataToDB()
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
//        viewModel.isEdit.asDriver()
//            .drive(onNext: {[weak self] bool in
//                guard let self = self else { return }
//                if bool {
//                    var style = ToastStyle()
//                    style.messageFont = .KoreanCaption1
//                    self.view.makeToast("  ✓  수정 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
//                }
//            })
//            .disposed(by: disposeBag)
    }
    
    func processChanges(previousItems: [ExclItemInfo], currentItems: [ExclItemInfo]) {
        if previousItems.count == currentItems.count {
            print("11111111")
            // 리스트의 크기가 동일하면 수정된 것으로 간주합니다.
            var style = ToastStyle()
            style.messageFont = .KoreanCaption1
            self.view.makeToast("  ✓  수정 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
        } else if previousItems.count > currentItems.count {
            // 이전 항목이 더 많으면 삭제된 것으로 간주합니다.
            print("22222222")
            var style = ToastStyle()
            style.messageFont = .KoreanCaption1
            self.view.makeToast("  ✓  삭제 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
        } else {
            print("3333333")
            // 이전 항목이 더 적으면 추가된 것으로 간주합니다.
            var style = ToastStyle()
            style.messageFont = .KoreanCaption1
            self.view.makeToast("  ✓  추가 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
        }
    }
}

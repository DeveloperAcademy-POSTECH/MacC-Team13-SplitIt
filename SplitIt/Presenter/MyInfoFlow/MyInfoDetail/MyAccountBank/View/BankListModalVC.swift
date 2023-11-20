//
//  BankListModalVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import SnapKit


class BankListModalVC: UIViewController, UIScrollViewDelegate {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var disposeBag = DisposeBag()
    var selectedBankName = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "userBank") ?? "")

    let topView = UIView()
    let selectedBankLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        setAddView()
        setAttribute()
        setCollectionView()
        setLayout()
    }
    
    
    func setLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()

        }
        
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
            make.top.centerX.equalToSuperview()
        }
        
        selectedBankLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    func setCollectionView() {
        collectionView.register(BankCell.self, forCellWithReuseIdentifier: "BankCell")
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Bank>>(
            configureCell: { (_, collectionView, indexPath, item) in
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankCell", for: indexPath) as! BankCell
                cell.backgroundColor = .clear
                
                cell.nameLabel.text = item.name
        
                return cell
            }
        )
        
        
        BankManager.shared.getAllBanks()
            .map { [SectionModel(model: "Section", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        

        collectionView.rx.modelSelected(Bank.self)
            .subscribe(onNext: { bank in
                self.dismiss(animated: true, completion: nil)
                self.selectedBankName.accept(bank.name)
            })
            .disposed(by: disposeBag)
    }
    
    func setAddView() {
        [topView, collectionView].forEach {
            view.addSubview($0)
        }
        
        topView.addSubview(selectedBankLabel)
    }
    
    
    func setAttribute() {
        
        view.backgroundColor = .SurfaceBrandCalmshell
        collectionView.backgroundColor = .SurfaceBrandCalmshell
        topView.backgroundColor = .SurfaceBrandCalmshell
        
        selectedBankLabel.text = "정산받을 은행을 선택해주세요"
        selectedBankLabel.font = UIFont.systemFont(ofSize: 21)
        selectedBankLabel.textColor = .TextPrimary
        
    }
}
    
    
extension BankListModalVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 326
        let cellHeight: CGFloat = 48
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
   
}


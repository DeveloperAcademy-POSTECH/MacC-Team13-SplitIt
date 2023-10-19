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
    var selectedBankName: BehaviorRelay<String> = BehaviorRelay<String>(value: "은행을 선택해주세요")

    
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        setAttribute()
        setCollectionView()
        setLayout()
    }
    
    
    func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(1500)
            make.width.equalTo(380)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
    }
    
    func setCollectionView() {
        collectionView.register(BankCell.self, forCellWithReuseIdentifier: "BankCell")
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Bank>>(
            configureCell: { (_, collectionView, indexPath, item) in
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankCell", for: indexPath) as! BankCell
                cell.backgroundColor = .gray
                
                let label = UILabel()

                cell.contentView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false

                label.text = item.name
                
                label.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
                
                return cell
            }
        )
        
        BankManager.shared.getAllBanks()
            .map { [SectionModel(model: "Section", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        

        collectionView.rx.modelSelected(Bank.self)
            .subscribe(onNext: { bank in
                UserData.shared.updateUserBankName(bank.name)
                self.dismiss(animated: true, completion: nil)
                print(bank.name, bank.backIdx)
                self.selectedBankName.accept(bank.name)
            })
            .disposed(by: disposeBag)
    }
    
 
    
    func setAttribute() {
        
        view.addSubview(collectionView)
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        
        
    }
}
    
    
extension BankListModalVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 100.0
        let cellHeight: CGFloat = 70.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}


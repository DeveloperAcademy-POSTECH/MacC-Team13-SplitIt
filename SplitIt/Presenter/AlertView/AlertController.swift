////
////  AlertController.swift
////  SplitIt
////
////  Created by cho on 2023/10/24.
////
//
//import UIKit
//
//protocol ExclMemberSectionHeaderDelegate: AnyObject {
//    func presentCustomAlertVC(item: ExclMemberSection, name: String)
//    func didDeleteItem(item: ExclMemberSection)
//}
//
//
//class AlertController: UIViewController, ExclMemberSectionHeaderDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//       
//    }
//    
//    func presentCustomAlertVC(item: ExclMemberSection, name: String) {
//           let customAlertVC = CustomAlertVC()
//           customAlertVC.modalPresentationStyle = .overFullScreen
//           customAlertVC.delegate = self
//           customAlertVC.item = item
//           customAlertVC.itemName = name // name을 설정
//           self.present(customAlertVC, animated: false)
//       }
//
//       func didDeleteItem(item: ExclMemberSection) {
//           SplitRepository.share.deleteExclItemAndRelatedData(exclItemIdx: item.exclItem.exclItemIdx)
//           print("항목이 삭제되었습니다.")
//       }
//
//   
//}

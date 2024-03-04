//
//  Manager.swift
//  SplitIt
//
//  Created by Zerom on 1/12/24.
//

import Foundation
import RealmSwift

protocol RealmManagerType {
    func updateData<T: LocalConvertibleType>(arr: [T])
    func deleteDatas<T: Object & LocalConvertibleType>(deleteType: T.Type, idxArr: [String])
}

extension RealmManagerType {
    func updateData<T: LocalConvertibleType>(arr: [T]) {
        do {
            let realm = try Realm()
            
            arr.forEach { object in
                let rmObject = object as! Object
                
                try! realm.write {
                    realm.add(rmObject, update: .all)
                }
            }
        } catch {
            print("UpdateDate To Realm Error")
        }
    }
    
    func deleteDatas<T: Object & LocalConvertibleType>(deleteType: T.Type, idxArr: [String]) {
        do {
            let realm = try Realm()
            let idxArr = idxArr.map { try! ObjectId(string: $0) }
            
            idxArr.forEach { idx in
                if let deleteData = realm.object(ofType: T.self, forPrimaryKey: idx) {
                    try! realm.write {
                        realm.delete(deleteData)
                    }
                }
            }
        } catch {
            print("DeleteDate To Realm Error")
        }
    }
}

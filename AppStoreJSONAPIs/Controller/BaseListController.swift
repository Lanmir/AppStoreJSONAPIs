//
//  BaseListController.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 05/11/24.
//

import UIKit
//MARK: BaseListController
class BaseListController: UICollectionViewController{
    
    //MARK: ViewController Initializer
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

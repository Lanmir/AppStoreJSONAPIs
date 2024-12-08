//
//  AppsPageHeader.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 06/11/24.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
    
    let appHeaderHorizontalController = AppsHeaderHorizontalController() //Nesting viewController
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(appHeaderHorizontalController.view) // adding viewController on top of headerView
        appHeaderHorizontalController.view.fillSuperview() 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

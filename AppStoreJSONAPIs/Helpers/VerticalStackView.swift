//
//  VerticalStackView.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 02/11/24.
//

import UIKit
//MARK: VerticalStackView
class VerticalStackView: UIStackView {

    init(arrangedSubViews: [UIView], spacing:CGFloat = 0){
        super.init(frame: .zero)// initial frame size , ignored since we use autolayout
        arrangedSubViews.forEach({addArrangedSubview($0)}) //adds each view in the array to the stackView
        self.spacing = spacing // option to set spacing
        self.axis = .vertical // sets the stack to vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

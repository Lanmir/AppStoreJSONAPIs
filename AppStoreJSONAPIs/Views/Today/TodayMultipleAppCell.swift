//
//  TodayMultipleAppCell.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 18/11/24.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            
            multipleAppsController.apps = todayItem.apps // feeding genre app data
            multipleAppsController.collectionView.reloadData()
            multipleAppsController.collectionView.backgroundColor = .systemBackground
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32),numberOfLines: 2)
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [categoryLabel, titleLabel].forEach{$0.textColor = .systemGray}
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        
        
        let stackView = VerticalStackView(arrangedSubViews: [
            categoryLabel,
            titleLabel,
            multipleAppsController.view
            ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

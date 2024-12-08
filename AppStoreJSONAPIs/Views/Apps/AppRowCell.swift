//
//  AppsRowCell.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 05/11/24.
//

import UIKit
//MARK: AppRowCell
class AppRowCell: UICollectionViewCell{
    
    var app: FeedResult! {
        didSet {
            companyLabel.text = app.name
            nameLabel.text = app.name
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }

    
    //MARK: SubView properties
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company name", font: .systemFont(ofSize: 13))
    
    let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //MARK: ImageView Properties
        imageView.backgroundColor = .purple
        imageView.constrainWidth(constant: 64) // convenience method from UIView + layout
        imageView.constrainHeight(constant: 64)
        //MARK: Button properties
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 32 / 2
        //MARK: StackView
        let stackView = UIStackView(arrangedSubviews: [imageView,VerticalStackView(arrangedSubViews: [nameLabel,companyLabel],spacing: 4),getButton])
        stackView.spacing = 16
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

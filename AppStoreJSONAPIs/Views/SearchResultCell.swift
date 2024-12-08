//
//  SearchResultCell.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 01/11/24.
//

import UIKit

// MARK: Cell Class
class SearchResultCell: UICollectionViewCell {
    //MARK: Cell URl methods
    var appResult: Result!{
        didSet{
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            ratingsLabel.text = "Ratings: \(appResult.averageUserRating ?? 0)"
            
            let url = URL(string: appResult.artworkUrl100)
            appIconImageView.sd_setImage(with: url)
            
            if appResult.screenshotUrls!.count > 0{ // some apps might not have screenshots, so check to avoid crash
                screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![0]))
            }
            
            if appResult.screenshotUrls!.count > 1{
                screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![1]))
            }
            
            if appResult.screenshotUrls!.count > 1{
                screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![2]))
            }
        }
    }
    
    //MARK: Cell Subviews
    let appIconImageView: UIImageView = {
        let iv = UIImageView() // image object
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }() // () after closure to execute the property
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "App Name"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos & Videos"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "8.48M"
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    // Use lazy var to access instance variables and functions
    lazy var screenshot1ImageView = self.createScreenShotImageView()
    lazy var screenshot2ImageView = self.createScreenShotImageView()
    lazy var screenshot3ImageView = self.createScreenShotImageView()
    
    func createScreenShotImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor // we use .cgcolor since borderColor is from Core Graphics
        imageView.contentMode = .scaleAspectFill // fills images proportionally
        return imageView
    }
    
    //MARK: Cell Layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //MARK: StackViews
        
        //creating the stack of views to display
        let infoTopStackView = UIStackView(arrangedSubviews: [appIconImageView,VerticalStackView(arrangedSubViews: [nameLabel,categoryLabel,ratingsLabel]),getButton])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        let screenshotsStackView = UIStackView(arrangedSubviews: [screenshot1ImageView,screenshot2ImageView,screenshot3ImageView])
        screenshotsStackView.spacing = 12
        screenshotsStackView.distribution = .fillEqually // used to place all stacks on the same axis
        
        let overallStackView = UIStackView(arrangedSubviews: [infoTopStackView,screenshotsStackView])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        
        //applying the stack on top of the view
        addSubview(overallStackView)
        
        //FillSuperView is a created method to manually set autolayout constraints
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
//        stackView.translatesAutoresizingMaskIntoConstraints = false    // set to false to manually set autolayout
//        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

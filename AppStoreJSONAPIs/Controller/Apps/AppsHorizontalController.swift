//
//  AppsHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 05/11/24.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    
    var appGroup: AppGroup?
    
    var didSelectHandler: ((FeedResult) -> ())?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appGroup?.feed.results[indexPath.item]{
            didSelectHandler?(app)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16) // padding from the border to inside of content
        
        
    }
    //MARK: Properties
    let topBottomPadding: CGFloat = 12
    let lineSpacing: CGFloat = 10
    
    //MARK: Cell Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroup?.feed.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
        let app = appGroup?.feed.results[indexPath.item]
        cell.companyLabel.text = app?.artistName
        cell.nameLabel.text = app?.name
        cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 3
        return .init(width: view.frame.width - 48, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0) // padding based on outer view for cells
    }
}

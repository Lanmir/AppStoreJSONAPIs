//
//  AppsController.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 05/11/24.
//

import UIKit
//MARK: AppsController
class AppsPageController:BaseListController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "id"
    let headerId = "headerId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.backgroundColor = .white
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        //1 register cell for header
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
//    var topFreeApps: AppGroup?
    var socialApps = [SocialApp]()
    var groups = [AppGroup]()
    
    fileprivate func fetchData(){
        
        var group1: AppGroup?
        var group2: AppGroup?
//        var group3: AppGroup?
        // help you sync your data fetches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchTopPaid { AppGroup, err in
            print("done with paid")
            
            dispatchGroup.leave()
            group1 = AppGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopFree { AppGroup, err in
            print("done with free")
            dispatchGroup.leave()
            group2 = AppGroup
        }
//        dispatchGroup.enter()
//        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/albums.json") { AppGroup, err in
//            print("done with albums")
//            dispatchGroup.leave()
//            group3 = AppGroup
//        }
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { apps, err in
            // you should chech for errors
            dispatchGroup.leave()
            self.socialApps = apps ?? []
//            self.collectionView.reloadData()
        }
        //completion
        dispatchGroup.notify(queue: .main) {
            print("Completed your dispatch group task...")
            self.activityIndicatorView.stopAnimating()
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
//            if let group = group3 {
//                self.groups.append(group)
//            }
            self.collectionView.reloadData()
        }
        
    }
    
    //2 create view for header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApps
        header.appHeaderHorizontalController.collectionView.reloadData() // without reload you'll see blank
        return header
    }
    //3 size for header layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = groups[indexPath.item]
        
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData() // whenever you set the appGroup up u need to refresh the controller
        cell.horizontalController.didSelectHandler = { [weak self] feedResult in //Use [weak self] to avoid retain cycle
            let controller = AppDetailController(appId: feedResult.id)
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}

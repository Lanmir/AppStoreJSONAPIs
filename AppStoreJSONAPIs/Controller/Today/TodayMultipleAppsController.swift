//
//  TodayMultipleAppsController.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 18/11/24.
//

import UIKit
//MARK: - TodayMultipleAppsController
class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    //MARK: - properties
//    var dismissHandler: (() -> Void)?
    let cellId = "cellId"
    
    var apps = [FeedResult]()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( UIImage(imageLiteralResourceName: "close_button") , for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true)
//        dismissHandler?()
    }
    
//    @objc fileprivate func handleDragForDaily(gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//
//        if gesture.state == .changed {
//            // Move the view down as the user drags
//            let transform = CGAffineTransform(translationX: 0, y: max(0, translation.y))
//            view.transform = transform
//        } else if gesture.state == .ended {
//            // Threshold to trigger dismissal
//            if translation.y > 200 { // Adjust this value as needed
//                handleDailyListDismissal()
//            } else {
//                // Revert to the original position if the drag is not enough
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.view.transform = .identity
//                })
//            }
//        }
//    }
//
//    @objc func handleDailyListDismissal(){
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
//            self.view.transform = .identity
//            self.tabBarController?.tabBar.transform = .identity
//        }, completion: { _ in
//            self.dismiss(animated: true)
//        })
//    }
//
//    func setupDragGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragForDaily))
//        view.addGestureRecognizer(panGesture)
//    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullscreen {
            setupCloseButton()
            navigationController?.isNavigationBarHidden = true
        } else {
            collectionView.isScrollEnabled = false
        }
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        
//        setupDragGesture()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override var prefersStatusBarHidden: Bool { return true }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
    }
    //MARK: - CollectionView Methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = self.apps[indexPath.item].id
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen{
            return .init(top: 12, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mode == .fullscreen{
            return apps.count
        }
        return min(4, apps.count)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        cell.app = self.apps[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 68
        if mode == .fullscreen{
            return .init(width: view.frame.width - 48, height: height)
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode){
        self.mode = mode
        super.init() // need to always super init to compile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

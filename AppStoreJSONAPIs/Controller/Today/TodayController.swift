//
//  TodayController.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 13/11/24.
//

import UIKit
//MARK: - Today Controller
class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    var items = [TodayItem]()
    var appFullscreenController: AppFullscreenController!
    var appFullscreenBeginOffsetY: CGFloat = 0
    var appFullscreenBeginOffsetX: CGFloat = 0
    var anchoredConstraints: AnchoredConstraints?
    var startingFrame: CGRect?
    let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular)) //acts like a UIView, try other styles
    static let cellsize :CGFloat = 500
    
    //MARK: - Activity indicator
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    //MARK: - View Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.superview?.setNeedsLayout() // re-layouts the tabbar
//        navigationController?.navigationBar.superview?.setNeedsLayout() //didn't work
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        blurVisualEffect.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        navigationController?.isNavigationBarHidden = true
//        navigationController?.navigationBar.isHidden = true
//        collectionView.backgroundColor = .systemPink
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    //MARK: - Service Method
    fileprivate func fetchData() {
        //dispatch Group
        let dispatchGroup = DispatchGroup()
        
        var freeGroup: AppGroup?
        var paidGroup: AppGroup?
        dispatchGroup.enter()
        Service.shared.fetchTopFree { appGroup, err in
            // make sure to check error
            freeGroup = appGroup
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Service.shared.fetchTopPaid { appGroup, err in
            paidGroup = appGroup
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){
            // i'll have access to two app genres
            print("finished fetching app daily list")
            self.activityIndicatorView.stopAnimating()
            self.items = [
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                TodayItem.init(category: "Daily list", title: freeGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: freeGroup?.feed.results ?? []),
                TodayItem.init(category: "Daily list", title: paidGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: paidGroup?.feed.results ?? []),
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .single, apps: []), ]
            self.collectionView.reloadData()
        }
    }
    //MARK: - Screen Methods
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
//        fullController.dismissHandler = {
//            fullController.handleDailyListDismissal()
//        }
//        fullController.setupDragGesture()
        fullController.modalPresentationStyle = .fullScreen
        let navigationController = BackEnabledNavigationController(rootViewController: fullController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
        //#1
        setupSingleAppFullscreenController(indexPath)
        
        //#2 setup  fullscreen in starting position
        setupAppFullscreenStartingPosition(indexPath)
        
        //#3 begin the fullscreen animation
        beginAnimationAppFullscreen()
        
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath){
//        navigationController?.navigationBar.isHidden = true
        
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
//            self.navigationController?.navigationBar.isHidden = false
            self.handleAppFullscreenDismissal()
        }
        
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        //#1 setup pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag)) // takes over gestureRecognizer of the view
        gesture.delegate = self // enables the view to recognize gesture
        appFullscreenController.view.addGestureRecognizer(gesture)
        //#2 add blur effect
        
        //#3 not interfere with tableview scrolling
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // allows the tableView and pan gesture to recognize simultaneously
    }
    
    
    
    @objc fileprivate func handleDrag(gesture : UIPanGestureRecognizer){
        
        if gesture.state == .began{
            appFullscreenBeginOffsetY = appFullscreenController.tableView.contentOffset.y //initial scroll y offset of tableView
            appFullscreenBeginOffsetX = appFullscreenController.tableView.contentOffset.x
        }
//        if appFullscreenController.tableView.contentOffset.y > 0 {    //disables the drag dismiss when scrolled down
//            return
//        }
        // Get translation Values
        let translationY = gesture.translation(in: appFullscreenController.view).y
        let translationX = gesture.translation(in: appFullscreenController.view).x
        
        // Determine if the user is scrolling vertically or horizontally
        let isVerticalGesture = abs(translationY) > abs(translationX)
            
        // Handle vertical gesture (drag down)
        if isVerticalGesture && appFullscreenController.tableView.contentOffset.y <= 0 {
            if gesture.state == .changed && translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffsetY
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            } else if gesture.state == .ended && translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
        // Handle horizontal gesture (swipe left-to-right)
        if !isVerticalGesture {
            if gesture.state == .changed && translationX > 0 {
                let trueOffset = translationX - appFullscreenBeginOffsetX
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            } else if gesture.state == .ended && translationX > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath){
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return } // sets the frame constraints as the cell superview
        
        self.startingFrame = startingFrame // setting the global  startingframe
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath){
       
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController) // Adding childView to render out all parts of the view
        
        
        self.collectionView.isUserInteractionEnabled = false
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return } //passing the global frame
        
        //Auto layout constraints animation
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded() // Starts the animation
    }
    
    
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffect.alpha = 1
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
            self.view.layoutIfNeeded() // Starts the animation

//            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100) // deprecated from ios 13
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
        }, completion: nil)
    }
    
    
    
    
    @objc func handleAppFullscreenDismissal(){
        //access starting frame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            //this frame code is bad
//            gesture.view?.frame = self.startingFrame ?? .zero
            self.blurVisualEffect.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // Starts the animation
            self.appFullscreenController.tableView.contentOffset = .zero // needed to be put under layout if needed , why?
                        
//            self.tabBarController?.tabBar.transform = .identity  // deprecated from ios 13
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
//            cell.closeButton.alpha = 0
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview() // dismiss from superView
            self.appFullscreenController.removeFromParent() //to not overload parent with multiple childViews
            self.collectionView.isUserInteractionEnabled = true
            
            
        })
    }
    
    
    //MARK: - CollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullScreen(indexPath: indexPath)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap))) // setting the multiple apps cell with a gesture
        return cell
        
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer){
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell{
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let apps = self.items[indexPath.item].apps
                let appFullscreenController = TodayMultipleAppsController(mode: .fullscreen)
                let fullscreenNavigationController = BackEnabledNavigationController(rootViewController: appFullscreenController)
                appFullscreenController.apps = apps
                fullscreenNavigationController.modalPresentationStyle = .fullScreen
                navigationController?.present(fullscreenNavigationController, animated: true)
                return
            }
            superview = superview?.superview
        }
    }
    
    
    //MARK: - CollectionViewLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellsize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

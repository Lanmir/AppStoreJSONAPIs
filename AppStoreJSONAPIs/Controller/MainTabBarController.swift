//
//  MainTabBarController.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 01/11/24.
//

import UIKit
//MARK: TabBarController
class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tabBar.tintColor = .white
//        tabBar.barTintColor = .lightGray
//        tabBar.unselectedItemTintColor = .gray
//        tabBar.isTranslucent = false   \ these are methods to modify tabBar
        
        //Array of tabs in the tabBar
        viewControllers = [
            
            createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
            createNavController(viewController: CompositionalController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search"),
            createNavController(viewController: MusicController(), title: "Music", imageName: "music"),
        ]
    }
    //MARK: Tab Creation Func
    fileprivate func createNavController(viewController: UIViewController,title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .systemBackground
        viewController.navigationItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}

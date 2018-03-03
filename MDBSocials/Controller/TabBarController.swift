//
//  ViewController.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/3/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarController = UITabBarController()
        
        let feedViewController = FeedVC()
        feedViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        let eventViewController = EventVC()
        eventViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let viewControllerList = [feedViewController, eventViewController]
        tabBarController.viewControllers = viewControllerList
        tabBarController.viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0)}
        
    }
}

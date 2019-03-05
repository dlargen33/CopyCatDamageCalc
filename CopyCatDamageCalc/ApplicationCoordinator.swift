//
//  ApplicationCoordinator.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 2/27/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
  
  let window: UIWindow
  let dataStore: DataStore
  
  init(window: UIWindow, router: UINavigationController, dataStore: DataStore) {
    self.window = window
    self.dataStore = dataStore
    super.init(router: router)
  }
  
  override func start() {
    UINavigationBar.appearance().barTintColor = UIColor(named: "NavbarColor")
    UINavigationBar.appearance().tintColor  = .white
    UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white ]
    
    //This should be async. An observable should be returned and subscribe to that.
    dataStore.loadModels()
    
    let coordinator = ScenariosCoordinator(router: UINavigationController(), dataStore: dataStore)
    self.addChildCoordinator(child: coordinator)
    coordinator.start()
    window.rootViewController = router
    window.makeKeyAndVisible()
    router.present(coordinator.router, animated: true)   
  }

}

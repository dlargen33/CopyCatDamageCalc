//
//  Coordinator.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 2/27/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit

public protocol Coordinatable {
  func start()
}

public class Coordinator: NSObject, Coordinatable {
  
  public let router: UINavigationController
  
  private var childCoordinators: [Coordinator] = []
   
  public init(router: UINavigationController){
    self.router = router
  }
  
  public func start() {}
  
  public func addChildCoordinator(child: Coordinator) {
    childCoordinators.append(child)
  }
  
  public func removeChildCoordinator(child: Coordinator ) {
    guard let index = self.childCoordinators.index(of: child) else {
      return
    }
   
    childCoordinators.remove(at: index)
  }  
}



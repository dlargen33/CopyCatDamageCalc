//
//  ScenariosCoordinator.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 2/28/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScenariosCoordinator: Coordinator {
  
  private let dataStore: DataStore
  private let disponseBag = DisposeBag()
  
  init(router: UINavigationController, dataStore: DataStore){
    self.dataStore = dataStore
    super.init(router: router)
  }
  
  override func start() {
    self.router.setViewControllers([self.scenarioListVC], animated: false)
  }
  
  lazy var scenarioListVC : ScenarioListViewController = { [unowned self] in
    let vm  = ScenarioListViewModel(dataStore: self.dataStore)
    
    vm.needsCreateScenario
      .subscribe(onNext: {
        self.router.pushViewController(self.createScenarioVC, animated: true)
      }).disposed(by: disponseBag)
    
    vm.needsScenarioDetail
      .subscribe(onNext: { (scenario) in
        self.router.pushViewController(self.scenarioDetailController(scenario: scenario), animated: true)
    }).disposed(by: disponseBag)
    
    return ScenarioListViewController.intialize(viewModel: vm)
    }()
  
  lazy var createScenarioVC: CreateScenarioViewController = { [unowned self] in
      let vm = CreateScenarioViewModel(dataStore: self.dataStore)
      vm.needsScenarioDetail
        .subscribe(onNext: { (scenario) in
          self.router.pushViewController(self.scenarioDetailController(scenario: scenario), animated: true)
        }).disposed(by: disponseBag)
    
      return CreateScenarioViewController.intialize(viewModel: vm)
  }()
  
  private func scenarioDetailController(scenario: Scenario) -> ScenarioDetailViewController {
    let vm = ScenarioDetailViewModel(scenario: scenario)
    let vc = ScenarioDetailViewController.intialize(viewModel: vm)
    return vc
  }
  
}



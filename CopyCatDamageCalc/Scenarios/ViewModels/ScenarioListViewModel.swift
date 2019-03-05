//
//  ScenarioListViewModel.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/1/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScenarioListViewModel {

  //Driver drives the UI makes sure things happen on the UI thread
  //Driver has a relay it subscribed to.  This Rx magic
  public let scenarios: Driver<[Scenario]>
  private let scenariosRelay = BehaviorRelay<[Scenario]>(value: [Scenario]())
  
  private let disposeBag = DisposeBag()
  private let dataStore: DataStore
  
  public let needsCreateScenario = PublishSubject<Void>()
  public let needsScenarioDetail = PublishSubject<Scenario>()
  
  init (dataStore: DataStore) {
    self.dataStore = dataStore
    self.scenarios = scenariosRelay.asDriver()
  }
  
  func load() {
    let scenarios = dataStore.scenarios
    self.scenariosRelay.accept(scenarios)
  } 
  
  func selectedCreateScenario() {
    self.needsCreateScenario.onNext(())
  }
  
  func selectedScenario(at index: Int) {
    guard self.dataStore.scenarios.count > 0 else {
      return
    }
    let scenario = self.dataStore.scenarios[index]
    self.needsScenarioDetail.onNext(scenario)
  }
  
  func scenarioCount() -> Int {
    return self.dataStore.scenarios.count
  }
  
  func scenario(at index: Int) -> Scenario {
    return self.dataStore.scenarios[index]
  }
  
}

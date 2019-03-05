//
//  ScenarioListViewController.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/1/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScenarioListViewController: UIViewController, Reusable {

  @IBOutlet weak var noScenariosView: UIView!
  @IBOutlet weak var scenariosTableView: UITableView!
  
  var viewModel: ScenarioListViewModel!
  let disposeBag = DisposeBag()
  var scenarios = [Scenario]()
  
  class func storyboard() -> UIStoryboard {
    return UIStoryboard(name: "Scenarios", bundle: nil)
  }
  
  class func intialize(viewModel: ScenarioListViewModel) -> ScenarioListViewController {
    let vc = storyboard().instantiateViewController() as ScenarioListViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      scenariosTableView.rowHeight = UITableView.automaticDimension
      scenariosTableView.estimatedRowHeight = 100
      setupBindings()    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     self.viewModel.load()
  }
  
  private func setupBindings() {
    let rightBarButtonItem = self.navigationItem.rightBarButtonItem
    rightBarButtonItem?.rx.tap.subscribe(onNext: {
      self.viewModel.selectedCreateScenario()
    }).disposed(by: disposeBag)
    
    self.viewModel.scenarios.asObservable()
      .subscribe(onNext: {
        self.scenarios = $0
        self.scenarios.count <= 0 ? self.view.bringSubviewToFront(self.noScenariosView) : self.view.sendSubviewToBack(self.noScenariosView)
        self.scenariosTableView.reloadData()
      }).disposed(by: disposeBag)
  }
}


extension ScenarioListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      viewModel.selectedScenario(at: indexPath.row)
  }
}

extension ScenarioListViewController:  UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.scenarioCount()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ScenarioCell = tableView.dequeueReusableCell()
    let scenario = viewModel.scenario(at: indexPath.row)
    cell.nameLabel.text = scenario.name
    cell.characterClassLabel.text = scenario.characterClass.rawValue
    cell.weaponLabel.text = scenario.weapon.name
    return cell
  }
  
}

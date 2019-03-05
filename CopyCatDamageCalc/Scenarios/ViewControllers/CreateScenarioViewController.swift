//
//  CreateScenarioViewController.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/1/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateScenarioViewController: UITableViewController, Reusable {

  @IBOutlet weak var characterLevelSlider: UISlider!
  @IBOutlet weak var characterLevelLabel: UILabel!
  @IBOutlet weak var minWeaponDamageTextField: UITextField!
  @IBOutlet weak var maxWeaponDamageTextField: UITextField!
  @IBOutlet weak var weaponStrengthModifierTextField: UITextField!
  @IBOutlet weak var elementType: UITextField!
  @IBOutlet weak var boostSlider: UISlider!
  @IBOutlet weak var boostLabel: UILabel!
  @IBOutlet weak var weaponTextField: UITextField!
  @IBOutlet weak var scenarioNameTextField: UITextField!
  
  var viewModel: CreateScenarioViewModel!
  let disposeBag = DisposeBag()
  
  class func storyboard() -> UIStoryboard {
    return UIStoryboard(name: "Scenarios", bundle: nil)
  }
  
  class func intialize(viewModel: CreateScenarioViewModel) -> CreateScenarioViewController {
    let vc = storyboard().instantiateViewController() as CreateScenarioViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.boostSlider.isEnabled = false
    setupBindings()    
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.load()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 4
  }
  
  private func setupBindings() {
    //hook up the right bar button and trigger the calculation
    let rightBarButtonItem = self.navigationItem.rightBarButtonItem
    rightBarButtonItem?.rx.tap.subscribe(onNext: {
      self.viewModel.selectedSave()
    }).disposed(by: disposeBag)
    
    //used when updating a scenario.  a scenario object will be provided to VM and the UI will render the values
    viewModel.scenarioDriver.asObservable()
      .subscribe(onNext: { (scenario) in
        self.characterLevelSlider.value = Float(scenario.level)
        self.characterLevelLabel.text = "\(scenario.level)"
        self.minWeaponDamageTextField.text =  "\(scenario.minDamage)"
        self.maxWeaponDamageTextField.text = "\(scenario.maxDamage)"
        self.weaponStrengthModifierTextField.text = "\(scenario.attributeModifier)"        
    }).disposed(by: disposeBag)
    
    //bind scenario name
    scenarioNameTextField.rx.text.orEmpty
      .bind(to: self.viewModel.scenarioNameRelay)
      .disposed(by: disposeBag)
    
    //bind updates from character slider to the VM
    characterLevelSlider.rx.value
      .bind(to: self.viewModel.characterLevelRelay)
      .disposed(by: disposeBag)
    
    //label is used to show the results of the user sliding the label
    //bind changes to the VM to UI.
    viewModel.characterLevelDriver
      .map({ "\(Int($0))"})
      .drive(characterLevelLabel.rx.text)
      .disposed(by: disposeBag)    
    
    //bind changes to the min damage to the VM
    minWeaponDamageTextField.rx.text.orEmpty
      .bind(to: self.viewModel.minWeaponDamageRelay)
      .disposed(by: disposeBag)
    
    
    //set up the weapons picker view and label
    let weaponsPickerView = UIPickerView()
    self.weaponTextField.inputView = weaponsPickerView
    
    self.viewModel.weapons
      .bind(to: weaponsPickerView.rx.itemTitles) { _, item in
        return item
    }.disposed(by: disposeBag)
    
    //reactive wrapper for delegate message pickerView:didSelectRow:inComponent:.
    //publish to the relay when the user selects something
    weaponsPickerView.rx.modelSelected(String.self)
      .asObservable()
      .subscribe(onNext: { (elementText) in
        self.viewModel.weaponRelay.accept(elementText.last ?? "")
      }).disposed(by: disposeBag)
    
      //when an Item is selected in the weapons picker view
      //update the text field.
      self.viewModel.weaponDriver
        .drive(self.weaponTextField.rx.text)
        .disposed(by: disposeBag)
    
    //bind changes to the max damage to the VM
    maxWeaponDamageTextField.rx.text.orEmpty
      .bind(to: self.viewModel.maxWeaponDamageRelay)
      .disposed(by: disposeBag)
    
     //bind changes to the strength to the VM
    weaponStrengthModifierTextField.rx.text.orEmpty
      .bind(to: self.viewModel.weaponModifierRelay)
      .disposed(by: disposeBag)
    
     //bind changes to the element boost to the VM
    boostSlider.rx.value
      .bind(to: self.viewModel.elementValueRelay)
      .disposed(by: disposeBag)
    
    //a label is used to show the results of the boost slider
    viewModel.elementValueDriver
      .map({ "\(Int($0))%"})
      .drive(self.boostLabel.rx.text)
      .disposed( by: disposeBag)
    
    let elementTypePicker = UIPickerView()
    elementType.inputView = elementTypePicker
    
    //get the string values of all the element enum values.
   var vals = Element.allCases.map { element in
      return element.rawValue
    }
    vals.insert("None", at: 0)
    
    Observable.of(vals)
      .bind(to: elementTypePicker.rx.itemTitles) { _, item in
        return item
    }.disposed(by: disposeBag)
    
    //reactive wrapper for delegate message pickerView:didSelectRow:inComponent:.
    elementTypePicker.rx.modelSelected(String.self)
      .asObservable()
      .subscribe(onNext: { (elementText) in
        let text = elementText.last ?? "None"
        self.boostSlider.isEnabled = text != "None"
        self.viewModel.elementRelay.accept(text)
      }).disposed(by: disposeBag)
    
    //when a value in the Element Picker is selected update the text field.
    //the driver is tied to the relay that is updated
    self.viewModel.elementDriver
      .drive(self.elementType.rx.text)
      .disposed(by: disposeBag)
  }
  
}

//
//  ScenarioViewModel.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/3/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateScenarioViewModel {
  
  private let dataStore: DataStore
  
  public let needsScenarioDetail = PublishSubject<Scenario>()
  
  // MARK:- Field Input Relays
  public let characterLevelRelay  = BehaviorRelay<Float>(value: 1.0)
  public let characterLevelDriver: Driver<Float>
  
  public let minWeaponDamageRelay  = BehaviorRelay<String>(value: "")
  public let maxWeaponDamageRelay = BehaviorRelay<String>(value: "")
  public let weaponModifierRelay  = BehaviorRelay<String>(value: "")
  public let scenarioNameRelay = BehaviorRelay<String>(value: "")
  
  public let elementRelay  = BehaviorRelay<String>(value: "")
  public let elementDriver: Driver<String>
  
  public let elementValueRelay  = BehaviorRelay<Float>(value: 0.0)
  public let elementValueDriver: Driver<Float>
  
  public let weaponRelay = BehaviorRelay<String>(value: "")
  public let weaponDriver: Driver<String>
  
  public let scenarioDriver: Driver<Scenario>
  private let scenarioRelay =  BehaviorRelay<Scenario>(value: Scenario())
  
  var weapons: Observable<[String]> {
    get {
      let weapons = self.dataStore.weapons.map { (weapon) in
        return weapon.name
      }
        return Observable.of(weapons)
    }
  }
  
  init(dataStore: DataStore){
    self.dataStore = dataStore
    self.characterLevelDriver = characterLevelRelay.asDriver()
    self.scenarioDriver = self.scenarioRelay.asDriver()
    self.elementValueDriver = self.elementValueRelay.asDriver()
    self.elementDriver = self.elementRelay.asDriver()
    self.weaponDriver = self.weaponRelay.asDriver()
  }
  
  func load() {
     self.scenarioRelay.accept(Scenario())
  }
  
  func selectedSave() {
    guard self.isValid() else {
      //set a relay so UI can respond
      return
    }
    
    // the alogoritm to calculate damage.  This is applied to min and max value dmg values.
    /*
        Damage =
          primary = level * 10 * 1
          ((primary + modifier)/100 ) * (attackDamageModifier /100) * (1 + (Boost/100))
     
          Min/Max Damage * ( ((primary + modifier)/100 ) * ( attackDamamge /100) * (1 + (Boost/100)) )
     
      Average Damage Per Second =
          ((Min Damage * Weapon Per Second * Attack APS Modifier) + (Mac Damage * Weapon Per Second * Attack APS Modifie) ) / 2
     
     */
    
      let primary = Int(self.characterLevelRelay.value) * 10 * 1  //this is hardcoded but really should be part to the character class
      let weaponModifier = Int(self.weaponModifierRelay.value) ?? 0
      let baseAttackStrength = Double((primary + weaponModifier)) / 100.0
    
      let attacks = self.dataStore.attacks
      let selectedElement = Element(rawValue:elementRelay.value)
    
      let weapon = self.dataStore.weapons.first { (weapon) in
        return weapon.name == self.weaponRelay.value
      } ?? Weapon(name: "mace", attacksPerSecond: 1)
    
      let baseMinDamange = Double(self.minWeaponDamageRelay.value) ?? 0.0
      let baseMaxDamage = Double(self.maxWeaponDamageRelay.value) ?? 0.0
    
      var results = [ScenarioResult]()
    
      attacks.forEach { (attack) in
        //get the attack damage modifier.
        let attackModifier = attack.damageModifier
        
        var boostIncrease = 0
        if let element = selectedElement, element == attack.element {
          boostIncrease = Int(self.elementValueRelay.value)
        }
        let boostModifier = 1.0 + (Double(boostIncrease) / 100.0 )
        
        let totalModifier = (baseAttackStrength) * (attackModifier) * (boostModifier)
        
        let minDamage  = baseMinDamange * totalModifier
        let maxDamage = baseMaxDamage * totalModifier
        
        //calculate the DPS
        let minDPS = minDamage * weapon.attacksPerSecond * attack.attacksPerSecondModifier
        let maxDPS = maxDamage * weapon.attacksPerSecond * attack.attacksPerSecondModifier
        let DPS = (maxDPS + minDPS) / 2
        
        print("Attack: \(attack.name) Min Damage: \(minDamage) Max Damage: \(maxDamage) DPS: \(DPS)")
        
        results.append(ScenarioResult(attack: attack, minDamage: minDamage, maxDamage: maxDamage, damagePerSecond: DPS))
      }
    
      var elementModifier = 0
      if let _ = selectedElement {
        elementModifier = Int(elementValueRelay.value)
      }
    
      //build of the scenario object and save it
      let scenario = Scenario(  name: scenarioNameRelay.value,
                              characterClass: .warrior,
                                              level: Int(characterLevelRelay.value),
                                         weapon: weapon,
                                    minDamage: Int(minWeaponDamageRelay.value) ?? 0,
                                   maxDamage: Int(maxWeaponDamageRelay.value) ?? 0,
                            attributeModifier: Int(weaponModifierRelay.value) ?? 0,
                                         element: selectedElement,
                             elementModifier: elementModifier,
                                            results: results)
    
    self.dataStore.scenarios.append(scenario)
    self.dataStore.saveModels()
    self.needsScenarioDetail.onNext(scenario)
  }
  
  func isValid() -> Bool {
   return  [scenarioNameRelay, weaponRelay, minWeaponDamageRelay, maxWeaponDamageRelay, weaponModifierRelay].reduce(true) { (previous, relay)  in
      return previous && !relay.value.isEmpty
    }
  }
  
}

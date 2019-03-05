//
//  Attack.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 2/27/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit

/*protocol Initializable {
  init()
}

extension Initializable {
  init(){
    self.init()
  }
}

extension Array : Initializable {
} */



enum Element: String, Codable, CaseIterable {
  case physical
  case fire
  case cold
}


//Not being used but probably will at some point
enum CharacterClass: String, Codable {
  case warrior
  
  var attribute: CharacterAttribute {
    switch self {
    case .warrior:
      return CharacterAttribute.strength
    }
  }
}

enum CharacterAttribute: String, Codable {
  case strength
  
  var abbreviation: String {
    switch self {
    case .strength:
      return "STR"
    }
  }
  
  var damangeModifer: Double {
    switch self {
    case .strength:
        return 0.1
    }
  }
}


struct Attack: Codable  {
  var name: String
  var damageModifier: Double
  var attacksPerSecondModifier: Double
  var element: Element
}

struct Weapon: Codable {
  var name: String
  var attacksPerSecond: Double
}

struct Scenario: Codable {
  var name: String = ""
  var characterClass: CharacterClass = .warrior
  var level: Int = 1
  var weapon: Weapon = Weapon(name: "mace", attacksPerSecond: 1.0)
  var minDamage: Int = 0
  var maxDamage: Int = 0
  var attributeModifier: Int = 0
  var element: Element?
  var elementModifier: Int?
  var results: [ScenarioResult] = [ScenarioResult]()
 }

struct ScenarioResult:  Codable {
  var attack: Attack
  var minDamage: Double
  var maxDamage: Double
  var damagePerSecond: Double
}


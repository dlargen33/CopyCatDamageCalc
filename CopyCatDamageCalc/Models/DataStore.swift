//
//  DataStore.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 2/27/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit

class DataStore: NSObject {
  
  var attacks = [Attack]()
  var weapons = [Weapon]()
  var scenarios = [Scenario]()
  
  func loadModels() {
    //yeah the data should be stored somewhere else and all of this should be done async.
    guard let attacksURL =  Bundle.main.url(forResource: "attacks", withExtension: "json"),
        let weaponsURL = Bundle.main.url(forResource: "weapons", withExtension: "json"),
          let scenariosURL =  self.scenariosURL else {
      return
    }
    attacks = loadModel(type: [Attack].self, url: attacksURL) ?? [Attack]()
    weapons = loadModel(type: [Weapon].self, url: weaponsURL) ?? [Weapon]()
    scenarios = loadModel(type: [Scenario].self, url: scenariosURL) ?? [Scenario]()
  }
  
  func saveModels() {
    //really just saving the scenarios that were generated
    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(scenarios)
      guard let scenariosURL = self.scenariosURL else {
        return
      }
      try data.write(to: scenariosURL)
    }
    catch {
      print(error)
    }
  }
  
  private var scenariosURL: URL? {
    get {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("scenarios.json")
    }
  }
  
  private func loadModel<T> (type: T.Type, url: URL) -> T? where T:Codable { //, T:Initializable {
     do {
      let decoder = JSONDecoder()
      let data = try Data(contentsOf: url)
      let model = try decoder.decode(type, from: data)
      return model
    }
    catch {
      print(error)
      //return T.init()
      return nil;
    }
  }
}

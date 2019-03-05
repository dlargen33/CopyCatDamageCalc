//
//  ScenarioDetailViewModel.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/5/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ScenarioDetailViewModel {
  
  public let scenarioDriver: Driver<String>
  private let scenarioRelay = BehaviorRelay<String>(value: "")
  
  private let scenario: Scenario
  private var template  = """
<html>
<style>
@font-face {
font-family: 'Maax';
font-style: normal;
font-weight: normal;
src: local('Maax-Regular');
}

@font-face {
font-family: 'Maax Bold';
font-style: normal;
font-weight: bold;
src: local('Maax-Bold');
}

table, th, td {
border: 1px solid black;
border-collapse: collapse;
}
th, td {
padding: 15px;
text-align: left;
}

th {
font-family: "Maax Bold", sans-serif;
}

body { font-family: "Maax", sans-serif; }

strong { font-family: "Maax Bold", sans-serif; }
</style>

<body>
<table style ="width:100%">
<caption>A level %LEVEL% %CLASS% using an %WEAPON% with the following stats:<br><br>%WEAPON-MIN%-%WEAPON-MAX% DMG, %ATTRIBUTE-MOD% STR, %ELEMENT-MOD% %ELEMENT% <br><br></caption>
<tr>
<th> Attack </th>
<th> Minimum </th>
<th> Maximum </th>
<th> DPS </th>
</tr>
%DATA%
</table>
</body>

</html>
"""
private let resultsTemplate =  """
<tr>
  <td> %ATTACK% </td>
  <td> %MIN-DAMAGE% </td>
  <td> %MAX-DAMAGE% </td>
  <td> %DPS% </td>
</tr>
"""
  init(scenario: Scenario){
    self.scenario = scenario
    self.scenarioDriver = scenarioRelay.asDriver()
  }
  
  func load() {
    let modifiedTemplate = replaceHeaderTokens(source: template)
    print(modifiedTemplate)
    let resultRows = replaceResultsToken(source: resultsTemplate)
    print(resultRows)
    let final = modifiedTemplate.replacingOccurrences(of: "%DATA%", with:resultRows)
    print(final)
    self.scenarioRelay.accept(final)
    //set data on relay to drive driver
  }
  
  private func replaceHeaderTokens(source: String ) -> String {
     var modifiedSource = source
     ["%LEVEL%", "%CLASS%", "%WEAPON%", "%WEAPON-MIN%", "%WEAPON-MAX%", "%ATTRIBUTE-MOD%", "%ELEMENT-MOD%", "%ELEMENT%"].forEach { (token) in
        modifiedSource = replaceHeaderToken(source: modifiedSource, token: token)
    }
    return modifiedSource
  }
  
  private func replaceHeaderToken(source: String, token: String) -> String {
    //this stinks.  I beleive I could use KVC. I would need to change somethings up on the model objects
    //Area to improve
    
    switch token {
      case "%LEVEL%":
        return source.replacingOccurrences(of: token, with: String(self.scenario.level))
      case "%CLASS%":
         return source.replacingOccurrences(of: token, with: self.scenario.characterClass.rawValue)
      case "%WEAPON%":
         return source.replacingOccurrences(of: token, with: self.scenario.weapon.name)
      case "%WEAPON-MIN%":
         return source.replacingOccurrences(of: token, with: String(self.scenario.minDamage))
      case "%WEAPON-MAX%":
         return source.replacingOccurrences(of: token, with: String(self.scenario.maxDamage))
      case "%ATTRIBUTE-MOD%":
         return source.replacingOccurrences(of: token, with: String(self.scenario.attributeModifier))
      case "%ELEMENT-MOD%":
         return source.replacingOccurrences(of: token, with: String(self.scenario.elementModifier ?? 0))
      case "%ELEMENT%":
         return source.replacingOccurrences(of: token, with: String(self.scenario.element?.rawValue ?? ""))
      default:
         print("No match for token: \(token)")
         return source
    }
  }
  
  private func replaceResultsToken(source: String ) -> String {
    var modifiedSource = ""
    var rows = ""
    
    self.scenario.results.forEach { (result) in
      modifiedSource = source
      ["%ATTACK%", "%MIN-DAMAGE%", "%MAX-DAMAGE%", "%DPS%"].forEach({ (token) in
        modifiedSource = replaceResultToken(source: modifiedSource, token: token, result: result)
      })
      rows = rows + modifiedSource
    }
    return rows
  }
  
  private func replaceResultToken(source: String, token: String, result: ScenarioResult) -> String {
   
    let fmt = NumberFormatter()
    fmt.locale = Locale(identifier: "en_US_POSIX")
    fmt.maximumFractionDigits = 3
    fmt.minimumFractionDigits = 0
    
    switch token {
      case "%ATTACK%":
        return source.replacingOccurrences(of: token, with: result.attack.name)
      case "%MIN-DAMAGE%":
        return source.replacingOccurrences(of: token, with: fmt.string(from: NSNumber(value: result.minDamage )) ?? "")
      case "%MAX-DAMAGE%":
        return source.replacingOccurrences(of: token, with: fmt.string(from: NSNumber(value: result.maxDamage )) ?? "")
      case "%DPS%":
        return source.replacingOccurrences(of: token, with: fmt.string(from: NSNumber(value: result.damagePerSecond )) ?? "")
      default:
        print("No match for token: \(token)")
        return source
      }
  }
}

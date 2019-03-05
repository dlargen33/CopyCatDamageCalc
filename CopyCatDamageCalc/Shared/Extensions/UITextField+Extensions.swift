//
//  UITextField+Extensions.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/4/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  @IBInspectable var doneAccessory: Bool {
    get {
      return self.doneAccessory
    }
    set (hasDone) {
      if hasDone{
        addDoneButton()
      }
    }
  }
  
  func addDoneButton()  {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.inputAccessoryView = doneToolbar
  }
  
  @objc func doneButtonAction() {
    self.resignFirstResponder()
  }
}

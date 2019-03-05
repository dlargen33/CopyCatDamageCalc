//
//  Reusable.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/1/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import Foundation

import Foundation
import UIKit

protocol Reusable {
  static var reuseIdentifier: String { get }
  static var nib: UINib { get }
}

extension Reusable {
  static var reuseIdentifier: String { return String(describing: self) }
  static var nib : UINib { return UINib(nibName: String(describing: self), bundle: nil) }
}




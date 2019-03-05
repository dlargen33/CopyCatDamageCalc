//
//  UIViewController+Extensions.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/1/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  class func instantiateFromStoryboard<T>(storyboardName: String) -> T  where T: Reusable, T:UIViewController{
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewController()
  }
}

extension UIStoryboard {
  func instantiateViewController<T>() ->T where T:Reusable, T:UIViewController {
    return self.instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
  }
}

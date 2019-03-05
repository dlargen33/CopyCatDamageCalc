//
//  ScenarioDetailViewController.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/5/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class ScenarioDetailViewController: UIViewController, Reusable {

  @IBOutlet weak var webView: WKWebView!
  
  private var viewModel: ScenarioDetailViewModel!
  private let disposeBag = DisposeBag()
  
  class func storyboard() -> UIStoryboard {
    return UIStoryboard(name: "Scenarios", bundle: nil)
  }
  
  class func intialize(viewModel: ScenarioDetailViewModel) -> ScenarioDetailViewController {
    let vc = storyboard().instantiateViewController() as ScenarioDetailViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.scenarioDriver.drive(onNext: { (html) in
      self.webView.loadHTMLString(html, baseURL: nil)
    }).disposed(by: disposeBag)
    
    viewModel.load()    
  }
}

//
//  ScenarioCell.swift
//  CopyCatDamageCalc
//
//  Created by Donald Largen on 3/1/19.
//  Copyright © 2019 Largen SoftwareLLC. All rights reserved.
//

import UIKit

class ScenarioCell: UITableViewCell, Reusable{

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var characterClassLabel: UILabel!
  @IBOutlet weak var weaponLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

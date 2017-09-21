//
//  GymCell.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/9/21.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import Foundation
import UIKit
class GymCell: UITableViewCell {
    
    var imageURL: String?
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var gymTitleLabel: UILabel!
    
    @IBOutlet weak var gymImageView: UIImageView!
    
    @IBOutlet weak var gymAddress: UILabel!
}

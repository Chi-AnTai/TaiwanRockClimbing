//
//  RouteCell.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/9/21.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import Foundation
import UIKit

class RouteCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var thunbnailImageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var uploaderLabel: UILabel!
    
    var key: String?
    
    var name: String?
    
    var email: String?
}

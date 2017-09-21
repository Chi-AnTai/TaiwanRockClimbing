//
//  DifficultyCell.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import Foundation
import UIKit



class DifficultyCell: UITableViewCell {
    
    var imageURL: String?
    
    var autoID: String?
    
    var creator: String?
    
    var imageUUID: String?
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var numberOfRoute: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var areaColorLabel: UILabel!
    
    var key:String?
    
}


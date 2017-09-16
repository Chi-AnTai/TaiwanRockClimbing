//
//  DifficultyCell.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import Foundation
import UIKit

struct CurrentUser {
    
    var name: String
    
    var email: String
    
    var password: String
    
    var uid: String
    
}

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


class GymCell: UITableViewCell {
    
    var imageURL: String?
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var gymTitleLabel: UILabel!
    
    @IBOutlet weak var gymImageView: UIImageView!
    
    @IBOutlet weak var gymAddress: UILabel!
}

class RouteCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var thunbnailImageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var uploaderLabel: UILabel!
    
    var key: String?
    
    var name: String?
    
    var email: String?
}

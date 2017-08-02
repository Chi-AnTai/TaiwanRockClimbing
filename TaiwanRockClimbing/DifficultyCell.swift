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

    @IBOutlet weak var difficultyLabel: UILabel!

    @IBOutlet weak var numberOfRoute: UILabel!
}


class GymCell: UITableViewCell {

    @IBOutlet weak var gymTitleLabel: UILabel!
}

class RouteCell: UITableViewCell {

    @IBOutlet weak var thunbnailImageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
}

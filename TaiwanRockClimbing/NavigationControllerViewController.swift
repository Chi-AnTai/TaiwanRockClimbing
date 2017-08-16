//
//  NavigationControllerViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/8/11.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit

class NavigationControllerViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 18)!]
        //        let gradientLayer = CAGradientLayer()
        //        var updatedFrame = self.navigationBar.bounds
        //        updatedFrame.size.height += 20
        //        gradientLayer.frame = updatedFrame
        //        gradientLayer.colors = [UIColor.gray.cgColor, UIColor.white.cgColor]
        //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        //        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        //
        
        
        //        gradientLayer.shadowOffset = CGSize(width: 0, height: 1)
        //        gradientLayer.shadowColor = UIColor.init(red: 178/255, green: 178/255, blue: 178/255, alpha: 0.85).cgColor
        //
        //        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //        gradientLayer.shadowRadius = 2.0
        //        gradientLayer.shadowOpacity = 0.85
        //        gradientLayer.masksToBounds = false
        
        //        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        //        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //
        //        self.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        //
        //        self.navigationBar.layer.shadowColor = UIColor.init(red: 53/255, green: 184/255, blue: 208/255, alpha: 0.85).cgColor
        //        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //        self.navigationBar.layer.shadowRadius = 4.0
        //        self.navigationBar.layer.shadowOpacity = 0.85
        //        self.navigationBar.layer.masksToBounds = false
        // Do any additional setup after loading the view.
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

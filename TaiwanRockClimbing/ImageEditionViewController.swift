//
//  ImageEditionViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/8/10.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit

class ImageEditionViewController: UIViewController {
    var editImage: UIImage?
    var lastTouch = CGPoint(x: 0, y: 0)
    var context:CGContext?
    var destinationViewController: UIViewController?
    
    @IBAction func reEditAction(_ sender: Any) {
        
        UIGraphicsBeginImageContext(editImageView.frame.size)
        
        self.editImage?.draw(in: CGRect(x: 0,
                                        y: 0,
                                        width: self.view.frame.width,
                                        height: self.view.frame.height-80))
        
        context = UIGraphicsGetCurrentContext()
        
        editImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    @IBAction func cancelEditAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func editCompleteAction(_ sender: Any) {
        
        if let target = destinationViewController as? AddRouteViewController {
            target.photoImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    @IBOutlet weak var editImageView: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            lastTouch = firstTouch.location(in: view)
            print(lastTouch.y)
            lastTouch.y = lastTouch.y - 80
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchLocation = firstTouch.location(in: view)
            var adjustTouchlocation = touchLocation
            adjustTouchlocation.y = adjustTouchlocation.y - 80
            drawLine(from: lastTouch, to: adjustTouchlocation)
            lastTouch = adjustTouchlocation
        }
    }
    func drawLine(from: CGPoint, to: CGPoint) {
        self.context?.move(to: from)
        self.context?.addLine(to: to)
        self.context?.setLineWidth(4)
        self.context?.setStrokeColor(UIColor.blue.cgColor)
        self.context?.strokePath()
        
        editImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editImageView.frame = CGRect.init(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height-80)
        
        UIGraphicsBeginImageContext(editImageView.frame.size)
        self.editImage?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-80))
        context = UIGraphicsGetCurrentContext()
        editImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

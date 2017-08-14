//
//  ImageEditionViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/8/10.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
class EditImage: UIImageView {
    var editImage: UIImage?
    var lastTouch = CGPoint(x: 0, y: 0)
    var context:CGContext?
    var dismissButton = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            lastTouch = firstTouch.location(in: self)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchLocation = firstTouch.location(in: self)
            
            drawLine(from: lastTouch, to: touchLocation)
            
            lastTouch = touchLocation
        }
    }
    func drawLine(from: CGPoint, to: CGPoint) {
        self.context?.move(to: from)
        self.context?.addLine(to: to)
        
        
        self.context?.setLineWidth(5)
        
        self.context?.setStrokeColor(UIColor.blue.cgColor)
        
        self.context?.strokePath()
        
        //testImageView.image?.draw(in: view.frame)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        
        //        UIGraphicsEndImageContext()
    }
    
    


    

}

class ImageEditionViewController: UIViewController {
    var editImage: UIImage?
    var lastTouch = CGPoint(x: 0, y: 0)
    var context:CGContext?
    var destinationViewController: UIViewController?

    @IBAction func reEditAction(_ sender: Any) {
        UIGraphicsBeginImageContext(editImageView.frame.size)
        self.editImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 607))
        context = UIGraphicsGetCurrentContext()
        editImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    @IBAction func cancelEditAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editCompleteAction(_ sender: Any) {
        
        if let target = destinationViewController as? AddRouteViewController {
            print("dismissing")
        target.photoImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    @IBOutlet weak var editImageView: UIImageView!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            lastTouch = firstTouch.location(in: view)
            print(lastTouch.y)
            lastTouch.y = lastTouch.y - 60
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchLocation = firstTouch.location(in: view)
            var adjustTouchlocation = touchLocation
            adjustTouchlocation.y = adjustTouchlocation.y - 60
            drawLine(from: lastTouch, to: adjustTouchlocation)
            
            //lastTouch = touchLocation
            lastTouch = adjustTouchlocation
        }
    }
    func drawLine(from: CGPoint, to: CGPoint) {
        self.context?.move(to: from)
        self.context?.addLine(to: to)
        
        
        self.context?.setLineWidth(5)
        
        self.context?.setStrokeColor(UIColor.blue.cgColor)
        
        self.context?.strokePath()
        
        //testImageView.image?.draw(in: view.frame)
        editImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        //        UIGraphicsEndImageContext()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(editImageView.frame.size)
        self.editImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 607))
        context = UIGraphicsGetCurrentContext()
        editImageView.image = UIGraphicsGetImageFromCurrentImageContext()

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

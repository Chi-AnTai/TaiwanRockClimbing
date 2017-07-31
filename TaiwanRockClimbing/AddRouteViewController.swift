//
//  AddRouteViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/31.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class AddRouteViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let imagePickerController = UIImagePickerController()
    
    @IBAction func takePhotoAction(_ sender: Any) {
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
        present(imagePickerController, animated: true, completion: nil)

        
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoNSURL = info[UIImagePickerControllerMediaURL] as? NSURL
        //print("videoURL:\(String(describing: videoURL))")
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil) }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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

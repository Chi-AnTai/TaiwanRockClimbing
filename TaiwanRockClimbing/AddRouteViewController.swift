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
import NVActivityIndicatorView
import Crashlytics

extension UIImage {
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}


class AddRouteViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,NVActivityIndicatorViewable {
    
    var currentUser: CurrentUser?
    
    let imagePickerController = UIImagePickerController()
    
    var difficultyPicker = UIPickerView()
    
    var difficultyOption = ["V0","V1","V2","V3","V4","V5","V6","V7"]
    
    var gym = ""
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var areaTextField: UITextField!
    
    @IBOutlet weak var difficultyTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var pointsTextField: UITextField!
    
    @IBOutlet weak var editImageView: UIImageView!
    
    @IBOutlet weak var uploadRoute: UIBarButtonItem!
    
    func alertGenerator(message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert
        )
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func uploadButton(_ sender: UIBarButtonItem) {
        
        if areaTextField.text == "" {
            
            alertGenerator(message: "area is empty")
        }
            
        else if difficultyTextField.text  == "" {
            
            alertGenerator(message: "difficulty is empty")
        }
            
        else if colorTextField.text == "" {
            
            alertGenerator(message: "color is empty")
        }
            
        else if pointsTextField.text == "" {
            
            alertGenerator(message: "points is empty")
            
        }
        else if photoImageView.image == nil {
            
            alertGenerator(message: "image is empty")
        }
        else{
            
            startAnimating(CGSize.init(width: 150, height: 150),message: "uploading")
            
            let storageRef = Storage.storage().reference()
            
            let uuid = NSUUID.init()
            
            if photoImageView.image != nil {
               
                let imageData = UIImageJPEGRepresentation(photoImageView.image!, 1)
                
                let uploadImage = storageRef.child("\(uuid).png").putData(imageData!, metadata: nil) { (metadata, error) in
                    
                    guard let metadata = metadata else {
                        
                        self.stopAnimating()
                       
                        return
                    }
                    
                    if let downloadUrl = metadata.downloadURL() {
                        
                        let downloadUrlString = String(describing: downloadUrl)
                        
                        let databaseRef = Database.database().reference()
                        
                        let difficultyPath = self.difficultyRoute(difficulty:self.difficultyTextField.text!
                        )
                        
                        let uploadRoute = databaseRef
                            .child("\(self.gym)Route")
                            .child(difficultyPath)
                            .childByAutoId()
                            .setValue([
                                "area": self.areaTextField.text!,
                                "color": self.colorTextField.text!,
                                "points": self.pointsTextField.text!,
                                "difficulty": self.difficultyTextField.text!,
                                "imageURL": downloadUrlString,
                                "imageUUID": "\(uuid)",
                                "creator": self.currentUser!.email,
                                "creatorName": self.currentUser!.name]
                        )
                        
                        self.stopAnimating()
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    self.stopAnimating()
                }
            }
        }
    }
    
    
    
    @IBAction func takePhotoAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let attributedString = NSAttributedString(string: "選取照片後可以編輯岩點",
                                                  attributes: [
                                                    NSFontAttributeName : UIFont.systemFont(ofSize: 20),
                                                    NSForegroundColorAttributeName : UIColor.red]
        )
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        let recordAction = UIAlertAction(title: "拍攝照片", style: .default) { (UIAlertAction) in
            
            self.takePhoto()
        }
        
        alertController.addAction(recordAction)
        
        let pickAction = UIAlertAction(title: "選取照片", style: .default) { (UIAlertAction) in
            
            self.pickPhoto()
        }
        
        alertController.addAction(pickAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func takePhoto() {

        imagePickerController.sourceType = .camera
        
        imagePickerController.cameraCaptureMode = .photo
        
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func pickPhoto() {
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let videoNSURL = info[UIImagePickerControllerMediaURL] as? NSURL
        
        let lowQualityImage = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 1)
        
        photoImageView.image = UIImage(data: lowQualityImage!)
        
        self.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let target = storyboard.instantiateViewController(withIdentifier: "ImageEdition") as! ImageEditionViewController
        
        target.editImage = UIImage(data: lowQualityImage!)
        
        target.destinationViewController = self
        
        self.present(target, animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if difficultyTextField.text == "" {
            
            difficultyTextField.text = "V0"
        }
        
        return difficultyOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        difficultyTextField.text = difficultyOption[row]
        
        return
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return difficultyOption[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        difficultyPicker.delegate = self
        
        difficultyPicker.dataSource = self
        
        difficultyTextField.inputView = difficultyPicker
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func difficultyRoute(difficulty: String) -> String {
        
        if difficulty == "V0" || difficulty == "V1" {
            
            return "V0V1"
        }
        
        if difficulty == "V2" || difficulty == "V3" {
            
            return "V2V3"
        }
        
        if difficulty == "V4" || difficulty == "V5" {
            
            return "V4V5"
        }
        
        return "V6V7"
        
    }
    
    
  }

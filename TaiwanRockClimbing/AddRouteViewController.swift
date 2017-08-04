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

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}


class AddRouteViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let imagePickerController = UIImagePickerController()
    var difficultyPicker = UIPickerView()
    var difficultyOption = ["V0","V1","V2","V3","V4","V5","V6","V7"]
    var gym = "STONE"
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var areaTextField: UITextField!
    
    @IBOutlet weak var difficultyTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var pointsTextField: UITextField!
    
    
    @IBAction func uploadButton(_ sender: UIBarButtonItem) {
        let storageRef = Storage.storage().reference()
        let uuid = NSUUID.init()
        if photoImageView.image != nil {
        let imageData = UIImageJPEGRepresentation(photoImageView.image!, 0.0)
            //UIImageJPEGRepresentation(photoImageView.image!, 0.3)
            //UIImagePNGRepresentation(photoImageView.image!)
            
        let uploadImage = storageRef.child("\(uuid).png").putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
                
            }
            if let downloadUrl = metadata.downloadURL() {
            print(downloadUrl)
            let downloadUrlString = String(describing: downloadUrl)
            print(downloadUrlString)
            let databaseRef = Database.database().reference()
            let difficultyPath = self.difficultyRoute(difficulty: self.difficultyTextField.text!)
            let uploadRoute = databaseRef.child("\(self.gym)Route").child(difficultyPath).childByAutoId().setValue(["area": self.areaTextField.text!, "color": self.colorTextField.text!, "points": self.pointsTextField.text!, "difficulty": self.difficultyTextField.text!, "imageURL": downloadUrlString])
            
            }
        }
        }
        
    }
    
    
    
    @IBAction func takePhotoAction(_ sender: Any) {
        
        //imagePickerController.sourceType = .photoLibrary
        imagePickerController.sourceType = .camera
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
       
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [kUTTypeImage as NSString as String]
        present(imagePickerController, animated: true, completion: nil)

        
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoNSURL = info[UIImagePickerControllerMediaURL] as? NSURL
        //print("videoURL:\(String(describing: videoURL))")
        let lowQualityImage = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 0.2)
        photoImageView.image = UIImage(data: lowQualityImage!)
        self.dismiss(animated: true, completion: nil) }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
        

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        let imageData = UIImagePNGRepresentation(photoImageView.image!)
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

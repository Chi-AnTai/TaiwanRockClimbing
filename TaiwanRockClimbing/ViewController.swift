//
//  ViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/24.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import Firebase
import AVFoundation
import AVKit



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let imagePickerController = UIImagePickerController()
    var gym = "123"
    var difficulty = "wer"
    

    
    var movieData: Data?
    @IBOutlet weak var thunbnailImageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    @IBAction func pickVideoAction(_ sender: Any) {
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)

        
//        imagePickerController.sourceType = .savedPhotosAlbum
//        imagePickerController.delegate = self
//        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
//        
//        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
//        present(imagePickerController, animated: true, completion: nil)
//
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoNSURL = info[UIImagePickerControllerMediaURL] as? NSURL
        //print("videoURL:\(String(describing: videoURL))")
        self.dismiss(animated: true, completion: nil)
        
        let videoURL = videoNSURL as URL!
        if let first = NSData(contentsOf: videoURL! ) as Data? {
            
            movieData = first
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let uuid = NSUUID.init()
            //let riversRef = storageRef.child("\(uuid)")
        
            let uploadTask = storageRef.child("\(uuid).mp4").putData(movieData!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                
            }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let databaseRef = Database.database().reference()
                let downloadURL = metadata.downloadURL()
                print(downloadURL)
                let asset = AVAsset(url: downloadURL!)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                if let realdownloadURL = downloadURL {
                databaseRef.child("\(self.gym)Route").child(self.difficulty).childByAutoId().child("video").setValue("\(realdownloadURL)")
                }
                
                
                do {
                    print("making")
                    let thunbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
                self.thunbnailImageView.image = UIImage.init(cgImage: thunbnailCGImage)
                                    }
                catch {}
            
                
                let avplayerController = AVPlayerViewController()
                
                
                
                let player = AVPlayer(url: downloadURL!)
                
              
                avplayerController.player = player
                self.showDetailViewController(avplayerController, sender: self)
            }
        }
        
    }
    
    
    @IBOutlet weak var pickVideo: UIButton!
    
    
    
    
       
    
        
        
        
                

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


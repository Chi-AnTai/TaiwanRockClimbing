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



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    let imagePickerController = UIImagePickerController()
    var gym = ""
    var difficulty = "wer"
    var rouleImageURL: String?
    var autoID: String = "none"
    var urls: [String] = []
    var thunbnailImages: [UIImage] = []
    var imageDic: [String:UIImage] = [:]
    
    
        
    @IBOutlet weak var routeImageView: UIImageView!
    
    @IBOutlet weak var videoTableView: UITableView!

    @IBAction func addVideo(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
        
        
        
    }
    
    // @IBOutlet weak var routeImageView: UIImageView!

    
    var movieData: Data?
//    @IBOutlet weak var thunbnailImageView: UIImageView!
    
//    @IBOutlet weak var videoView: UIView!
    @IBAction func pickVideoAction(_ sender: Any) {
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
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
        
            let uploadTask = storageRef.child(autoID).child("\(uuid).mp4").putData(movieData!, metadata: nil) { (metadata, error) in
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
                databaseRef.child("video").child(self.autoID).childByAutoId().setValue("\(realdownloadURL)")
                }
            
                
//                let avplayerController = AVPlayerViewController()
//                
//                
//                
//                let player = AVPlayer(url: downloadURL!)
//                
//              
//                avplayerController.player = player
//                self.showDetailViewController(avplayerController, sender: self)
            }
        }
        
    }
    
    
    @IBOutlet weak var pickVideo: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thunbnailImages.count    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteCell
        
//        if let imageURL = URL(string: urls[indexPath.row]) {
//        
//        let asset = AVAsset(url: imageURL)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        
//        do {
//            print("making image")
//            let thunbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
//            cell.thunbnailImageView.image = UIImage.init(cgImage: thunbnailCGImage)
//        }
//        catch {}
//        }
        //cell.thunbnailImageView.image = thunbnailImages[indexPath.row]
        cell.thunbnailImageView.image = imageDic[urls[indexPath.row]]
        cell.playButton.tag = indexPath.row
        cell.playButton.tintColor = UIColor.white
        cell.playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        
                return cell
    }
    
    func playVideo(sender: UIButton) {
    print(sender.tag)
        let avplayerController = AVPlayerViewController()
        
        
        if let playVideoURL = URL(string: urls[sender.tag]){
        let player = AVPlayer(url: playVideoURL)
        
        
        avplayerController.player = player
            player.play()
        self.showDetailViewController(avplayerController, sender: self)
        }
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(autoID)
        
        DispatchQueue.global().async {
            if let url = self.rouleImageURL {
                let downloadURL = URL(string: url)
                let data = try? Data(contentsOf: downloadURL!)
                DispatchQueue.main.async {
                    self.routeImageView.image = UIImage(data: data!)
                }
                
            }

        }
//        if let url = self.rouleImageURL {
//        let downloadURL = URL(string: url)
//        let data = try? Data(contentsOf: downloadURL!)
//            routeImageView.image = UIImage(data: data!)
//        }
        
        
        let databaseRef = Database.database().reference()
        
        
        databaseRef.child("video").child(autoID).observe(.childAdded, with: { (snapshot) in
            
            if let requestData = snapshot.value as? String {
                
                    print("find data")
                    self.urls.append(requestData)
                DispatchQueue.global().async {
                    print(self.thunbnailImages.count)
                    if let imageURL = URL(string: requestData) {
                        
                        let asset = AVAsset(url: imageURL)
                        let imageGenerator = AVAssetImageGenerator(asset: asset)
                        
                        do {
                            print("making image")
                            let thunbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
                            
                            let thunbImage = UIImage.init(cgImage: thunbnailCGImage)
                            self.imageDic[requestData] = thunbImage
                            self.thunbnailImages.append(UIImage.init(cgImage: thunbnailCGImage)
                            )                     }
                        catch {}
                        DispatchQueue.main.async {
                            self.videoTableView.reloadData()

                        }
                        
                    }

                }
//                if let imageURL = URL(string: self.urls[self.urls.count-1]) {
//                    
//                    let asset = AVAsset(url: imageURL)
//                    let imageGenerator = AVAssetImageGenerator(asset: asset)
//                    
//                    do {
//                        print("making image")
//                        let thunbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
//                        self.thunbnailImages.append(UIImage.init(cgImage: thunbnailCGImage)
//)                     }
//                    catch {}
//                    self.videoTableView.reloadData()
//                }
//
                
                
                
                
                
                
                self.videoTableView.reloadData()
                
            }})

 //       if self.rouleImageURL != nil {
 //           let routeURL = URL(string: self.rouleImageURL!)
 //           if let data = try? Data(contentsOf: routeURL!) {
 //     //  routeImageView.image = UIImage(data: data)
        
  //          }
  //      }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("tring to delete")
            // remove the item from the data model
            
            
            // delete the table view row
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
            print("tring to insert")
        }
    }



}


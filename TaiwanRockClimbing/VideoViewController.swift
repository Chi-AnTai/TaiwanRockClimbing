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
import NVActivityIndicatorView
import SDWebImage



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    let imagePickerController = UIImagePickerController()
    var gym = ""
    var difficulty = "wer"
    var rouleImageURL: String?
    var autoID: String = "none"
    var urls: [String] = []
    var thunbnailImages: [UIImage] = []
    var imageDic: [String:UIImage] = [:]
    var currentUser: CurrentUser?
    var uploaderName: [String] = []
    var uploaderEmail: [String] = []
    var videoKey: [String] = [] {
        didSet {
            routeInfoLabel.text = "\(routeInfo) 目前有\(videoKey.count)部影片"
        }
    }
    var routeInfo: String = ""
    
       
    @IBOutlet weak var routeInfoLabel: UILabel!
        
    @IBOutlet weak var routeImageView: UIImageView!
    
    @IBOutlet weak var videoTableView: UITableView!

    @IBAction func addVideo(_ sender: UIBarButtonItem) {
//        imagePickerController.sourceType = .camera
//        imagePickerController.delegate = self
//        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
//        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
//        present(imagePickerController, animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let attributedString = NSAttributedString(string: "請盡量橫拍", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20), //your font here
            NSForegroundColorAttributeName : UIColor.red
            ])
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        
        let recordAction = UIAlertAction(title: "拍攝影片", style: .default) { (UIAlertAction) in
            self.recordVideo()
        }
        alertController.addAction(recordAction)
        let pickAction = UIAlertAction(title: "選取影片", style: .default) { (UIAlertAction) in
            self.pickVideo()
        }
        alertController.addAction(pickAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    func recordVideo() {
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
                imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
                present(imagePickerController, animated: true, completion: nil)
    
    }
    
    
    func pickVideo() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    
    }
    

    
    var movieData: Data?

//    @IBAction func pickVideoAction(_ sender: Any) {
//        imagePickerController.sourceType = .camera
//        imagePickerController.delegate = self
//        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
//        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
//        present(imagePickerController, animated: true, completion: nil)
//    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
        let videoNSURL = info[UIImagePickerControllerMediaURL] as? NSURL
        self.dismiss(animated: true, completion: nil)
        
        
        startAnimating(CGSize.init(width: 120, height: 120),message: "uploading")
        
        let videoURL = videoNSURL as URL!
        if let first = NSData(contentsOf: videoURL! ) as Data? {
            
            movieData = first
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let uuid = NSUUID.init()
                        let uploadTask = storageRef.child(autoID).child("\(uuid).mp4").putData(movieData!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                
            }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let databaseRef = Database.database().reference()
                let downloadURL = metadata.downloadURL()
                
                let asset = AVAsset(url: downloadURL!)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                if let realdownloadURL = downloadURL {
                databaseRef.child("video").child(self.autoID).child("\(uuid)").setValue(["url": "\(realdownloadURL)", "name": self.currentUser!.name, "email": self.currentUser!.email])
                }
                self.stopAnimating()

            }
        }
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return thunbnailImages.count
        return imageDic.count
    
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteCell
        

        cell.thunbnailImageView.image = imageDic[urls[indexPath.row]]
        cell.thunbnailImageView.clipsToBounds = true
        cell.thunbnailImageView.layer.cornerRadius = 8
        
        
        cell.shadowView.layer.shadowColor = UIColor.gray.cgColor
        cell.shadowView.layer.shadowRadius = 8
        cell.shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.shadowView.layer.shadowOpacity = 0.5
        
        
        cell.playButton.tag = indexPath.row
        cell.playButton.tintColor = UIColor.white
        cell.playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        cell.email = uploaderEmail[indexPath.row]
        cell.name = uploaderName[indexPath.row]
        cell.key = videoKey[indexPath.row]
        cell.uploaderLabel.text = "Uploaded by \(uploaderName[indexPath.row])"
        print("cellname=\(uploaderName[indexPath.row])")
        
                return cell
    }
    
    func playVideo(sender: UIButton) {
        Analytics.logEvent("play video", parameters: [autoID:videoKey[sender.tag]])

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
        routeInfoLabel.text = "\(routeInfo) 目前有\(videoKey.count)部影片"
        print(autoID)
        if let url = self.rouleImageURL {
            let downloadURL = URL(string: url)
        self.routeImageView.sd_setImage(with: downloadURL, placeholderImage: UIImage.init(named: "icon_photo"))
            self.routeImageView.contentMode = UIViewContentMode.scaleToFill
        }
        
//        DispatchQueue.global().async {
//            if let url = self.rouleImageURL {
//                let downloadURL = URL(string: url)
//                let data = try? Data(contentsOf: downloadURL!)
//                DispatchQueue.main.async {
//                    self.routeImageView.contentMode = UIViewContentMode.scaleToFill
//                    self.routeImageView.image = UIImage(data: data!)
//                    self.routeImageView.contentMode = UIViewContentMode.scaleToFill
//                    self.videoTableView.reloadData()
//                    
//                    
//                    
//                }
//                
//            }
//
//        }
//        if let url = self.rouleImageURL {
//        let downloadURL = URL(string: url)
//        let data = try? Data(contentsOf: downloadURL!)
//            routeImageView.image = UIImage(data: data!)
//        }
        
        
        let databaseRef = Database.database().reference()
        
        
        databaseRef.child("video").child(autoID).observe(.childAdded, with: { (snapshot) in
            
            if let requestData = snapshot.value as? [String:String] {
                
                print(snapshot.value)
                print("here")
                print(requestData["url"]!)
                
                if let name = requestData["name"] as? String, let email = requestData["email"] as? String {
                    self.uploaderName.append(name)
                    self.uploaderEmail.append(email)
                    self.videoKey.append(snapshot.key)
                }
                    self.urls.append(requestData["url"]!)
                DispatchQueue.global().async {
                    
                    if let imageURL = URL(string: requestData["url"]!) {
                        
                        let asset = AVAsset(url: imageURL)
                        let imageGenerator = AVAssetImageGenerator(asset: asset)
                        
                        do {
                            
                            let thunbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
                            
                            let thunbImage = UIImage.init(cgImage: thunbnailCGImage)
                            self.imageDic[requestData["url"]!] = thunbImage
                            //self.thunbnailImages.append(UIImage.init(cgImage: thunbnailCGImage))
                            print(self.thunbnailImages.count)
                            //self.videoTableView.reloadData() 
                            print("making image done")
                            DispatchQueue.main.async {
                                self.videoTableView.reloadData()
                                
                            }

                        }
                        catch {}
//                        DispatchQueue.main.async {
//                            self.videoTableView.reloadData()
//
//                        }
                        
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
                
                
                
                
                
                
                //self.videoTableView.reloadData()
                
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
            if currentUser!.email == uploaderEmail[indexPath.row] {
                
                print("tring to delete")
                
                
                let alertController = UIAlertController(
                    title: "刪除",
                    message: "確定要刪除影片嗎？",
                    preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(
                    title: "取消",
                    style: .cancel,
                    handler: nil)
                alertController.addAction(cancelAction)
                
                // 建立[刪除]按鈕
                let okAction = UIAlertAction(title: "刪除", style: .destructive) { (UIAlertAction) in
                    
                    let databaseRef = Database.database().reference()
                    databaseRef.child("video").child(self.autoID).child(self.videoKey[indexPath.row]).removeValue()
                    let storageRef = Storage.storage().reference()
                    storageRef.child(self.autoID).child("\(self.videoKey[indexPath.row]).mp4").delete(completion: { (error) in
                        if let error = error {
                            print("\(error)")
                            // Uh-oh, an error occurred!
                        } else {
                            print("success")
                           
                            // File deleted successfully
                        }
                    })

                }
                alertController.addAction(okAction)
                
                // 顯示提示框
                self.present(
                    alertController,
                    animated: true,
                    completion: nil)

                        }
            else {
                
                let alertController = UIAlertController(title: "錯誤", message: "這不是你上傳的影片", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    return
                })
                
                alertController.addAction(okAction)
                self.present(
                    alertController,
                    animated: true,
                    completion: nil)

            print("not match")
            }
            // remove the item from the data model
            
            
            // delete the table view row
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
//    func deleteSomething() {
//        // 建立一個提示框
//        let alertController = UIAlertController(
//            title: "刪除",
//            message: "刪除字樣會變紅色的",
//            preferredStyle: .alert)
//        
//        // 建立[取消]按鈕
//        
//        
//        
//        let cancelAction = UIAlertAction(
//            title: "取消",
//            style: .cancel,
//            handler: nil)
//        alertController.addAction(cancelAction)
//        
//        // 建立[刪除]按鈕
//        let okAction = UIAlertAction(title: "刪除", style: .destructive) { (UIAlertAction) in
//            print("deleting")
//        }
//        alertController.addAction(okAction)
//        
//        // 顯示提示框
//        self.present(
//            alertController,
//            animated: true,
//            completion: nil)
//    }




}


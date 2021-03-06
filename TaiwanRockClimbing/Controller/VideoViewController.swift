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
    
    var difficulty = ""
    
    var rouleImageURL: String?
    
    var autoID: String = ""
    
    var urls: [String] = []
    
    var imageDic: [String:UIImage] = [:]
    
    var currentUser: CurrentUser?
    
    var uploaderName: [String] = []
    
    var uploaderEmail: [String] = []
    
    var creator: String = ""
    
    var videoKey: [String] = [] {
        
        didSet {
            routeInfoLabel.text = "\(routeInfo)目前有 \(videoKey.count) 部影片"
        }
    }
    
    var routeInfo: String = ""
    @IBOutlet weak var zoomoutView: UIView!
    
    @IBOutlet weak var zoomoutImageView: UIImageView!
    
    @IBOutlet weak var routeInfoLabel: UILabel!
    
    @IBOutlet weak var routeImageView: UIImageView!
    
    @IBOutlet weak var videoTableView: UITableView!
    
    @IBAction func editAction(_ sender: Any) {
       
        if currentUser!.email == creator {
        
        }
        else {
            let alertController = UIAlertController(title: "錯誤",
                                                    message: "這不是你上傳的路線",
                                                    preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                return
            })
            
            alertController.addAction(okAction)
            self.present(alertController,
                         animated: true,
                         completion: nil
            )
        }
        
    }
    @IBAction func zoomoutAction(_ sender: Any) {
        self.zoomoutView.isHidden = false
        
        self.zoomoutImageView.isHidden = false
    }
    @IBAction func addVideo(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "",
                                                message: nil,
                                                preferredStyle: .actionSheet
        )
        
        let attributedString = NSAttributedString(string: "影片長度上限一分鐘",
                                                  attributes: [
                                                    NSFontAttributeName :UIFont.systemFont(ofSize: 20),
                                                    NSForegroundColorAttributeName : UIColor.red
            ]
        )
        
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        let recordAction = UIAlertAction(title: "拍攝影片", style: .default) { (UIAlertAction) in
            
            self.recordVideo()
        }
        
        alertController.addAction(recordAction)
        
        let pickAction = UIAlertAction(title: "選取影片", style: .default) { (UIAlertAction) in
            
            self.pickVideo()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(pickAction)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func recordVideo() {
        imagePickerController.sourceType = .camera
        
        imagePickerController.delegate = self
        
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeMedium
        
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        
        imagePickerController.videoMaximumDuration = 60.0
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    func pickVideo() {
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeMedium
        
        imagePickerController.videoMaximumDuration = 60.0
        
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    
    var movieData: Data?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePickerController.videoQuality = UIImagePickerControllerQualityType.typeLow
        
        let videoNSURL = info[UIImagePickerControllerMediaURL] as? NSURL
        
        self.dismiss(animated: true, completion: nil)
        
        
        startAnimating(CGSize.init(width: 120, height: 120),message: "uploading")
        
        let videoURL = videoNSURL as URL!
        
        if let nsMovieData = NSData(contentsOf: videoURL! ) as Data? {
            
            movieData = nsMovieData
            
            let storage = Storage.storage()
            
            let storageRef = storage.reference()
            
            let uuid = NSUUID.init()
            
            let uploadTask = storageRef.child(autoID).child("\(uuid).mp4").putData(movieData!, metadata: nil)
            { (metadata, error) in
                
                guard let metadata = metadata else {
                    
                    return
                    
                }
             
                let databaseRef = Database.database().reference()
                
                let downloadURL = metadata.downloadURL()
                
                let asset = AVAsset(url: downloadURL!)
                
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                
                if let realdownloadURL = downloadURL {
                    
                    databaseRef
                        .child("video")
                        .child(self.autoID)
                        .child("\(uuid)").setValue([
                            "url": "\(realdownloadURL)",
                            "name": self.currentUser!.name,
                            "email": self.currentUser!.email]
                    )
                }
                
                
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        
        cell.uploaderLabel.text = "此影片由 \(uploaderName[indexPath.row]) 提供"
        
        return cell
    }
    
    func playVideo(sender: UIButton) {
        
        Analytics.logEvent("playvideo", parameters: [autoID:videoKey[sender.tag]])
        
        let avplayerController = AVPlayerViewController()
        
        if let playVideoURL = URL(string: urls[sender.tag]){
            
            let player = AVPlayer(url: playVideoURL)
            
            avplayerController.player = player
            
            player.play()
            
            self.showDetailViewController(avplayerController, sender: self)
        }
    }
    
    func pinchedView(_ sender: UIPinchGestureRecognizer) {
        
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 1.0
        
        if (sender.view?.frame.width)! <= UIScreen.main.bounds.width &&
            (sender.view?.frame.height)! <= UIScreen.main.bounds.height {
            
            zoomoutImageView.center.x = UIScreen.main.bounds.width/2
            zoomoutImageView.center.y = UIScreen.main.bounds.height/2
            
        }
        
    }
    
    func tapView() {
        
    self.zoomoutView.isHidden = true
        
    self.zoomoutImageView.isHidden = true
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        routeInfoLabel.text = "\(routeInfo) 目前有 \(videoKey.count) 部影片"
        
        let cancelZoomout = UITapGestureRecognizer(target: self, action: #selector(self.tapView))
        
        self.zoomoutView.addGestureRecognizer(cancelZoomout)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchedView(_:)))
        
        self.zoomoutImageView.addGestureRecognizer(pinchGesture)
        
        
        if let url = self.rouleImageURL {
            
            let downloadURL = URL(string: url)
            
            self.routeImageView.sd_setImage(with: downloadURL, placeholderImage: UIImage.init(named: "icon_photo"))
            
            self.zoomoutImageView.sd_setImage(with: downloadURL)
            
        }
        
        let databaseRef = Database.database().reference()
        
        
        databaseRef
            .child("video")
            .child(autoID)
            .observe(.childAdded, with: { (snapshot) in
                
                if let requestData = snapshot.value as? [String:String] {
                    
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
                                
                                DispatchQueue.main.async {
                                    
                                    self.stopAnimating()
                                    
                                    self.videoTableView.reloadData()
                                    
                                }
                                
                            }
                                
                            catch {}
                            
                            
                        }
                        
                    }
                }})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if currentUser!.email == uploaderEmail[indexPath.row] {
                
                let alertController = UIAlertController(
                    title: "刪除",
                    message: "確定要刪除影片嗎？",
                    preferredStyle: .alert
                )
                
                let cancelAction = UIAlertAction(
                    title: "取消",
                    style: .cancel,
                    handler: nil
                )
                
                alertController.addAction(cancelAction)
                
                let okAction = UIAlertAction(title: "刪除", style: .destructive) { (UIAlertAction) in
                    
                    self.startAnimating(CGSize.init(width: 120, height: 120),message: "deleting")
                    
                    let databaseRef = Database.database().reference()
                    
                    databaseRef.child("video").child(self.autoID).child(self.videoKey[indexPath.row]).removeValue()
                    
                    let storageRef = Storage.storage().reference()
                    storageRef.child(self.autoID).child("\(self.videoKey[indexPath.row]).mp4").delete(completion: { (error) in
                        if let error = error {
                            print("\(error)")
                            self.stopAnimating()
                        } else {
                            self.imageDic.removeValue(forKey: self.urls[indexPath.row])
                            self.urls.remove(at: indexPath.row)
                            self.uploaderName.remove(at: indexPath.row)
                            self.uploaderEmail.remove(at: indexPath.row)
                            self.videoKey.remove(at: indexPath.row)
                            self.stopAnimating()
                            self.videoTableView.reloadData()
                                                   }
                    })
                    
                }
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
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
                
                
            }
        }
    }
    
    
    
    
}


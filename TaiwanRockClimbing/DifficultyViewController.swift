//
//  DifficultyViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

struct routeInfo {
    
    var area: String
    
    var color: String
    
    var difficulty: String
    
    var points: String
    
    var image: String
    
    var autoID: String
    
    var creator: String
    
    var creatorName: String
    
    var imageUUID: String
}




class DifficultyViewController: UIViewController,UITabBarDelegate,UITableViewDataSource, NVActivityIndicatorViewable {
    
    var gym = ""
    
    var gymImageURL = ""
    
    var V0V1: [routeInfo] = []
    
    var V2V3: [routeInfo] = []
    
    var V4V5: [routeInfo] = []
    
    var V6V7: [routeInfo] = []
    
    var currentUser: CurrentUser?
    
    var isDownloadingFirst: Bool = false
    
    var isDownloadingSecond: Bool = false
    
    var isDownloadingThird: Bool = false
    
    var isDownloadingFourth: Bool = false
    
    @IBOutlet weak var difficultyTableView: UITableView!
    
    @IBOutlet weak var gymImageView: UIImageView!
    
    @IBOutlet weak var difficultySegment: UISegmentedControl!
    
    @IBAction func difficultyAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 1: if isDownloadingSecond == false {
            
            self.isDownloadingSecond = true
            
            let databaseRef = Database.database().reference()
            
            databaseRef
                .child("\(gym)Route")
                .child("V2V3")
                .observe(.childAdded, with: { (snapshot) in
                    
                self.isDownloadingFirst = true
                    
                if let requestData = snapshot.value as? [String: String] {
                    
                    self.V2V3.append(routeInfo(area: requestData["area"]!,
                                               color: requestData["color"]!,
                                               difficulty: requestData["difficulty"]!,
                                               points: requestData["points"]!,
                                               image: requestData["imageURL"]!,
                                               autoID: snapshot.key,
                                               creator: requestData["creator"]!,
                                               creatorName: requestData["creatorName"]!,
                                               imageUUID: requestData["imageUUID"]!
                        )
                    )
                    
                    self.difficultyTableView.reloadData()
                }
            }
            )
        }
        
        self.difficultyTableView.reloadData()
            
        case 2: if isDownloadingThird == false {
            
            self.isDownloadingThird = true
            
            let databaseRef = Database.database().reference()
            
            databaseRef
                .child("\(gym)Route")
                .child("V4V5")
                .observe(.childAdded, with: { (snapshot) in
                    
                self.isDownloadingFirst = true
                    
                if let requestData = snapshot.value as? [String: String] {
                    
                    self.V4V5.append(routeInfo(area: requestData["area"]!,
                                               color: requestData["color"]!,
                                               difficulty: requestData["difficulty"]!,
                                               points: requestData["points"]!,
                                               image: requestData["imageURL"]!,
                                               autoID: snapshot.key,
                                               creator: requestData["creator"]!,
                                               creatorName: requestData["creatorName"]!,
                                               imageUUID: requestData["imageUUID"]!
                        )
                    )
                    
                    self.difficultyTableView.reloadData()
                    
                }
            }
            )}
        
        self.difficultyTableView.reloadData()
            
        case 3: if isDownloadingFourth == false {
            
            self.isDownloadingFourth = true
            
            let databaseRef = Database.database().reference()
            
            databaseRef.child("\(gym)Route").child("V6V7").observe(.childAdded, with: { (snapshot) in
                
                self.isDownloadingFirst = true
                
                if let requestData = snapshot.value as? [String: String] {
                    
                    self.V6V7.append(routeInfo(area: requestData["area"]!,
                                               color: requestData["color"]!,
                                               difficulty: requestData["difficulty"]!,
                                               points: requestData["points"]!,
                                               image: requestData["imageURL"]!,
                                               autoID: snapshot.key,
                                               creator: requestData["creator"]!,
                                               creatorName: requestData["creatorName"]!,
                                               imageUUID: requestData["imageUUID"]!
                        )
                    )
                    
                    self.difficultyTableView.reloadData()
                    
                }
            }
            )}
        
        self.difficultyTableView.reloadData()
            
        default: self.difficultyTableView.reloadData()
        }
    }
    
    let difficultyLevel: [String] = ["V0-V1","V2-V3","V4-V5","V6V7"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if difficultySegment.selectedSegmentIndex == 1 {
            
            return V2V3.count
        }
        
        if difficultySegment.selectedSegmentIndex == 2 {
            
            return V4V5.count
        }
        
        if difficultySegment.selectedSegmentIndex == 3 {
            
            return V6V7.count
        }
        
        return V0V1.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "difficultyCell", for: indexPath) as! DifficultyCell
        
        if difficultySegment.selectedSegmentIndex == 1 {
            
            cell.autoID = V2V3[indexPath.row].autoID
            
            cell.imageURL = V2V3[indexPath.row].image
            
            cell.creator = V2V3[indexPath.row].creator
            
            cell.imageUUID = V2V3[indexPath.row].imageUUID
            
            cell.difficultyLabel.text = V2V3[indexPath.row].difficulty
            
            cell.areaColorLabel.text = "\(V2V3[indexPath.row].area)區: \(V2V3[indexPath.row].color)色"
            
            cell.numberOfRoute.text = "岩點數：\(V2V3[indexPath.row].points)"
            cell.pointsLabel.text = "此路線由 \(V2V3[indexPath.row].creatorName) 上傳"
            
            cell.difficultyLabel.layer.cornerRadius = cell.difficultyLabel.frame.width/2
            
            cell.difficultyLabel.layer.masksToBounds = true
            
            return cell
        }
            
        else if difficultySegment.selectedSegmentIndex == 2 {
            
            cell.autoID = V4V5[indexPath.row].autoID
            
            cell.imageURL = V4V5[indexPath.row].image
            
            cell.creator = V4V5[indexPath.row].creator
            
            cell.imageUUID = V4V5[indexPath.row].imageUUID
            
            cell.difficultyLabel.text = V4V5[indexPath.row].difficulty
            
            cell.areaColorLabel.text = "\(V4V5[indexPath.row].area)區: \(V4V5[indexPath.row].color)色"
            
            cell.numberOfRoute.text = "岩點數：\(V4V5[indexPath.row].points)"
            
            cell.pointsLabel.text = "此路線由 \(V4V5[indexPath.row].creatorName) 上傳"
            
            cell.difficultyLabel.layer.cornerRadius = cell.difficultyLabel.frame.width/2
            
            cell.difficultyLabel.layer.masksToBounds = true
            
            return cell
        }
            
        else if difficultySegment.selectedSegmentIndex == 3 {
            
            cell.autoID = V6V7[indexPath.row].autoID
            
            cell.imageURL = V6V7[indexPath.row].image
            
            cell.creator = V6V7[indexPath.row].creator
            
            cell.imageUUID = V6V7[indexPath.row].imageUUID
            
            cell.difficultyLabel.text = V6V7[indexPath.row].difficulty
            
            cell.areaColorLabel.text = "\(V6V7[indexPath.row].area)區: \(V6V7[indexPath.row].color)色"
            
            cell.numberOfRoute.text = "岩點數：\(V6V7[indexPath.row].points)"
            
            cell.pointsLabel.text = "此路線由 \(V6V7[indexPath.row].creatorName) 上傳"
            
            cell.difficultyLabel.layer.cornerRadius = cell.difficultyLabel.frame.width/2
            
            cell.difficultyLabel.layer.masksToBounds = true
            
            return cell
        }
            
        else {
            
            cell.imageURL = V0V1[indexPath.row].image
            
            cell.autoID = V0V1[indexPath.row].autoID
            
            cell.creator = V0V1[indexPath.row].creator
            
            cell.imageUUID = V0V1[indexPath.row].imageUUID
            
            cell.difficultyLabel.text = V0V1[indexPath.row].difficulty
            
            cell.areaColorLabel.text = "\(V0V1[indexPath.row].area)區: \(V0V1[indexPath.row].color)色"
            
            cell.numberOfRoute.text = "岩點數：\(V0V1[indexPath.row].points)"
            
            cell.pointsLabel.text = "此路線由 \(V0V1[indexPath.row].creatorName) 上傳"
            
            cell.difficultyLabel.layer.cornerRadius = cell.difficultyLabel.frame.width/2
            
            cell.difficultyLabel.layer.masksToBounds = true
            
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let targetViewController = segue.destination as? AddRouteViewController {
            
            targetViewController.gym = self.gym
            
            targetViewController.currentUser = self.currentUser
        }
        
        if let cell = sender as? DifficultyCell {
            
            if let targetViewController = segue.destination as? ViewController {
                
                targetViewController.gym = self.gym
                
                targetViewController.currentUser = self.currentUser
                
                targetViewController.rouleImageURL = cell.imageURL
                
                if let passID = cell.autoID,
                    let difficulty = cell.difficultyLabel.text,
                    let areaColor = cell.areaColorLabel.text,
                    let creator = cell.creator,
                    let points = cell.numberOfRoute.text {
                    
                    targetViewController.autoID = passID
                    
                    targetViewController.routeInfo = "\(difficulty)  \(areaColor) \(points) "
                    
                    targetViewController.creator = creator
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        gymImageView.sd_setImage(with: URL.init(string: gymImageURL),
                                 placeholderImage: UIImage(named: "icon_photo")
        )
        
        let databaseRef = Database.database().reference()
        
        // Do any additional setup after loading the view.
        databaseRef.child("\(gym)Route").child("V0V1").observe(.childAdded, with: { (snapshot) in
            
            self.isDownloadingFirst = true
            
            if let requestData = snapshot.value as? [String: String] {
                
                self.V0V1.append(routeInfo(area: requestData["area"]!,
                                           color: requestData["color"]!,
                                           difficulty: requestData["difficulty"]!,
                                           points: requestData["points"]!,
                                           image: requestData["imageURL"]!,
                                           autoID: snapshot.key,
                                           creator: requestData["creator"]!,
                                           creatorName: requestData["creatorName"]!,
                                           imageUUID: requestData["imageUUID"]!
                    )
                )
                
                self.difficultyTableView.reloadData()
                
            }
        
        }
        )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteSomething() {
        
        let alertController = UIAlertController(title: "刪除",
                                                message: "刪除字樣會變紅色的",
                                                preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "取消",
                                         style: .cancel,
                                         handler: nil
        )
        
        alertController.addAction(cancelAction)
        
      
        let okAction = UIAlertAction(title: "刪除", style: .destructive) { (UIAlertAction) in
            
            print("deleting")
        }
        
        alertController.addAction(okAction)
        
       
        self.present(alertController,
                     animated: true,
                     completion: nil
        )
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if difficultySegment.selectedSegmentIndex == 0 {
                
                if V0V1[indexPath.row].creator == currentUser!.email {
                    
                    let alertController = UIAlertController(title: "刪除",
                                                            message: "確定要刪除路線嗎？",
                                                            preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "取消",
                                                     style: .cancel,
                                                     handler: nil
                    )
                    
                    alertController.addAction(cancelAction)
                    
                    let okAction = UIAlertAction(title: "刪除", style: .destructive, handler: { (UIAlertAction) in
                        
                        var deleteKey: [String] = []
                        
                        self.startAnimating(CGSize.init(width: 120, height: 120),message: "刪除中")
                        Database
                            .database()
                            .reference()
                            .child("video")
                            .child(self.V0V1[indexPath.row].autoID)
                            .observeSingleEvent(of: .value, with: { (DataSnapshot) in
                           
                            if let requestData = DataSnapshot.value as? [String:Any] {
                                
                                for element in requestData {
                                    
                                    deleteKey.append(element.key)
                                }
                            }
                                
                            for element in deleteKey {
                                
                                let storageRef = Storage.storage().reference()
                                
                                storageRef
                                    .child(self.V0V1[indexPath.row].autoID)
                                    .child("\(element).mp4")
                                    .delete(completion: { (error) in
                                        
                                    if let error = error {
                                        
                                        print("\(error)")
                                    }
                                    }
                                )
                            }
                                
                            Storage
                                .storage()
                                .reference()
                                .child("\(self.V0V1[indexPath.row].imageUUID).png")
                                .delete(completion: { (error) in
                                
                            })
                            
                            Database
                                .database()
                                .reference()
                                .child("\(self.gym)Route")
                                .child("V0V1")
                                .child(self.V0V1[indexPath.row].autoID)
                                .removeValue()
                                
                            Database
                                .database()
                                .reference()
                                .child("video")
                                .child(self.V0V1[indexPath.row].autoID)
                                .removeValue()
                            
                            self.stopAnimating()
                                
                            self.V0V1.remove(at: indexPath.row)
                                
                            self.difficultyTableView.reloadData()
                        
                            }
                        )
                    }
                    )
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                    
                else {
                    
                    deleteNotAllow(message: "錯誤")
                }
            }
                
            else if difficultySegment.selectedSegmentIndex == 1 {
                
                if V2V3[indexPath.row].creator == currentUser!.email {
                    
                    let alertController = UIAlertController(title: "刪除",
                                                            message: "確定要刪除路線嗎？",
                                                            preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "取消",
                                                     style: .cancel,
                                                     handler: nil
                    )
                    
                    alertController.addAction(cancelAction)
                    
                    let okAction = UIAlertAction(title: "刪除", style: .destructive, handler: { (UIAlertAction) in
                        
                        var deleteKey: [String] = []
                        
                        self.startAnimating(CGSize.init(width: 120, height: 120),message: "刪除中")
                        
                    Database
                        .database()
                        .reference()
                        .child("video")
                        .child(self.V2V3[indexPath.row].autoID)
                        .observeSingleEvent(of: .value, with: { (DataSnapshot) in
                        
                            if let requestData = DataSnapshot.value as? [String:Any] {
                                
                                for element in requestData {
                                    
                                    deleteKey.append(element.key)
                                }
                            }
                            
                            for element in deleteKey {
                                
                                let storageRef = Storage.storage().reference()
                                
                                storageRef
                                    .child(self.V2V3[indexPath.row].autoID)
                                    .child("\(element).mp4")
                                    .delete(completion: { (error) in
                                        
                                    if let error = error {
                                        
                                        print("\(error)")
                                    }
                                    }
                                )
                            }
                            
                        Storage
                            .storage()
                            .reference()
                            .child("\(self.V2V3[indexPath.row].imageUUID).png")
                            .delete(completion: { (error) in
                            
                        })
                            
                            Database
                                .database()
                                .reference()
                                .child("\(self.gym)Route")
                                .child("V2V3")
                                .child(self.V2V3[indexPath.row].autoID)
                                .removeValue()
                            
                            Database
                                .database()
                                .reference()
                                .child("video")
                                .child(self.V2V3[indexPath.row].autoID)
                                .removeValue()
                            
                            self.stopAnimating()
                            
                            self.V2V3.remove(at: indexPath.row)
                            
                        self.difficultyTableView.reloadData()
                        }
                        )
                    }
                    )
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                    
                else {
                    
                    deleteNotAllow(message: "錯誤")
                }
            }
                
            else if difficultySegment.selectedSegmentIndex == 2 {
                
                if V4V5[indexPath.row].creator == currentUser!.email {
                    
                    let alertController = UIAlertController(title: "刪除",
                                                            message: "確定要刪除路線嗎？",
                                                            preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "取消",
                                                     style: .cancel,
                                                     handler: nil
                    )
                    alertController.addAction(cancelAction)
                    
                    let okAction = UIAlertAction(title: "OK", style: .destructive, handler: {
                        (UIAlertAction) in
                        
                        var deleteKey: [String] = []
                        
                        self.startAnimating(CGSize.init(width: 120, height: 120),message: "deleting")
                        Database
                            .database()
                            .reference()
                            .child("video")
                            .child(self.V4V5[indexPath.row].autoID)
                            .observeSingleEvent(of: .value, with: { (DataSnapshot) in
                                
                                if let requestData = DataSnapshot.value as? [String:Any] {
                                                        
                                for element in requestData {
                                    
                                    deleteKey.append(element.key)
                                }
                            }
                                
                            for element in deleteKey {
                                
                                let storageRef = Storage.storage().reference()
                                
                                storageRef
                                    .child(self.V4V5[indexPath.row].autoID)
                                    .child("\(element).mp4")
                                    .delete(completion: { (error) in
                                        
                                    if let error = error {
                                        
                                        print("\(error)")
                                    }
                                    }
                                )
                            }
                                
                            Storage
                                .storage()
                                .reference()
                                .child("\(self.V4V5[indexPath.row].imageUUID).png")
                                .delete(completion: { (error) in
                                
                                }

                                )
                                
                            Database
                                .database()
                                .reference()
                                .child("\(self.gym)Route")
                                .child("V4V5")
                                .child(self.V4V5[indexPath.row].autoID)
                                .removeValue()
                                
                            Database
                                .database()
                                .reference()
                                .child("video")
                                .child(self.V4V5[indexPath.row].autoID)
                                .removeValue()
                                
                            self.stopAnimating()
                                
                            self.V4V5.remove(at: indexPath.row)
                                
                            self.difficultyTableView.reloadData()
                        
                            }
                       )
                    }
                    )
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                    
                else {
                    
                    deleteNotAllow(message: "錯誤")
                }

            }
                
            else if difficultySegment.selectedSegmentIndex == 3 {
                
                if V6V7[indexPath.row].creator == currentUser!.email {
                    
                    let alertController = UIAlertController(title: "刪除",
                                                            message: "確定要刪除路線嗎？",
                                                            preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "取消",
                                                     style: .cancel,handler: nil
                    )
                    
                    alertController.addAction(cancelAction)
                    
                    let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in
                        
                        var deleteKey: [String] = []
                        
                        self.startAnimating(CGSize.init(width: 120, height: 120),message: "deleting")
                        Database
                            .database()
                            .reference()
                            .child("video")
                            .child(self.V6V7[indexPath.row].autoID)
                            .observeSingleEvent(of: .value, with: { (DataSnapshot) in
                            
                            if let requestData = DataSnapshot.value as? [String:Any] {
                                
                                for element in requestData {
                                    
                                    deleteKey.append(element.key)
                                }
                            }
                                
                            for element in deleteKey {
                                
                                let storageRef = Storage.storage().reference()
                                
                                storageRef
                                    .child(self.V6V7[indexPath.row].autoID)
                                    .child("\(element).mp4")
                                    .delete(completion: { (error) in
                                        
                                    if let error = error {
                                        
                                        print("\(error)")
                                    }
                                    }
                                )
                            }
                                
                            Storage
                                .storage()
                                .reference()
                                .child("\(self.V6V7[indexPath.row].imageUUID).png")
                                .delete(completion: { (error) in
                                
                            }
                                )
                                
                            Database
                                .database()
                                .reference()
                                .child("\(self.gym)Route")
                                .child("V6V7")
                                .child(self.V6V7[indexPath.row].autoID)
                                .removeValue()
                                
                            Database
                                .database()
                                .reference()
                                .child("video")
                                .child(self.V6V7[indexPath.row].autoID)
                                .removeValue()
                                
                            self.stopAnimating()
                                
                            self.V6V7.remove(at: indexPath.row)
                                
                            self.difficultyTableView.reloadData()
                       
                            }
                        )
                    }
                    )
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else {
                    
                    deleteNotAllow(message: "錯誤")
                }
            }
        }
    }
    
    func deleteNotAllow(message: String) {
        
        let alertController = UIAlertController(title: message,
                                                message: "這不是你上傳的路線",
                                                preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            return
        }
        )
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    
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

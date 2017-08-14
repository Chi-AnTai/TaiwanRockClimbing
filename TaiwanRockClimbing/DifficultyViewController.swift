//
//  DifficultyViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Firebase

struct routeInfo {
    var area: String
    var color: String
    var difficulty: String
    var points: String
    var image: String
    var autoID: String
}




class DifficultyViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {
    var gym = ""
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
        databaseRef.child("\(gym)Route").child("V2V3").observe(.childAdded, with: { (snapshot) in
            self.isDownloadingFirst = true
            if let requestData = snapshot.value as? [String: String] {
                self.V2V3.append(routeInfo(area: requestData["area"]!, color: requestData["color"]!, difficulty: requestData["difficulty"]!, points: requestData["points"]!, image: requestData["imageURL"]!, autoID: snapshot.key))
                
                self.difficultyTableView.reloadData()
            }
        }
            )
            }
       self.difficultyTableView.reloadData()

        case 2: if isDownloadingThird == false {
            self.isDownloadingThird = true
            let databaseRef = Database.database().reference()
        databaseRef.child("\(gym)Route").child("V4V5").observe(.childAdded, with: { (snapshot) in
            self.isDownloadingFirst = true
            if let requestData = snapshot.value as? [String: String] {
                self.V4V5.append(routeInfo(area: requestData["area"]!, color: requestData["color"]!, difficulty: requestData["difficulty"]!, points: requestData["points"]!, image: requestData["imageURL"]!, autoID: snapshot.key))
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
                self.V6V7.append(routeInfo(area: requestData["area"]!, color: requestData["color"]!, difficulty: requestData["difficulty"]!, points: requestData["points"]!, image: requestData["imageURL"]!, autoID: snapshot.key))
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
            cell.difficultyLabel.text = V2V3[indexPath.row].difficulty
            cell.areaColorLabel.text = "\(V2V3[indexPath.row].area)區: \(V2V3[indexPath.row].color)色"
            cell.pointsLabel.text = "岩點數： \(V2V3[indexPath.row].points)"
            return cell        }

        else if difficultySegment.selectedSegmentIndex == 2 {
            cell.autoID = V4V5[indexPath.row].autoID
            cell.imageURL = V4V5[indexPath.row].image
            cell.difficultyLabel.text = V4V5[indexPath.row].difficulty
            cell.areaColorLabel.text = "\(V4V5[indexPath.row].area)區: \(V4V5[indexPath.row].color)色"
            cell.pointsLabel.text = "岩點數： \(V4V5[indexPath.row].points)"
            return cell        }
        else if difficultySegment.selectedSegmentIndex == 3 {
            cell.autoID = V6V7[indexPath.row].autoID
            cell.imageURL = V6V7[indexPath.row].image
            cell.difficultyLabel.text = V6V7[indexPath.row].difficulty
            cell.areaColorLabel.text = "\(V6V7[indexPath.row].area)區: \(V6V7[indexPath.row].color)色"
            cell.pointsLabel.text = "岩點數： \(V6V7[indexPath.row].points)"
            return cell        }
        else {
        cell.imageURL = V0V1[indexPath.row].image
        cell.autoID = V0V1[indexPath.row].autoID
        cell.difficultyLabel.text = V0V1[indexPath.row].difficulty
        cell.areaColorLabel.text = "\(V0V1[indexPath.row].area)區: \(V0V1[indexPath.row].color)色"
        cell.pointsLabel.text = "岩點數： \(V0V1[indexPath.row].points)"
        
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
                if let passID = cell.autoID  {
                targetViewController.autoID = passID
                }
                
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gym)
        //gymImageView.image = UIImage(named: "Civic Bouldergym")
        gymImageView.tintColor = UIColor(colorLiteralRed: 128/255, green: 128/255, blue: 129.0/255, alpha: 0)
        
        
        let databaseRef = Database.database().reference()

        // Do any additional setup after loading the view.
        databaseRef.child("\(gym)Route").child("V0V1").observe(.childAdded, with: { (snapshot) in
            self.isDownloadingFirst = true
            if let requestData = snapshot.value as? [String: String] {
                self.V0V1.append(routeInfo(area: requestData["area"]!, color: requestData["color"]!, difficulty: requestData["difficulty"]!, points: requestData["points"]!, image: requestData["imageURL"]!, autoID: snapshot.key))
                
                print(snapshot.key)
                self.difficultyTableView.reloadData()

            }
            
            
//            if let requestData = snapshot.value as? [String:String] {
//                var articledata = article(title: requestData["title"]!, content: requestData["content"]!, firstName: requestData["firstName"]!, lastName: requestData["lastName"]!, date: requestData["date"]!)
//                self.requestArticle.append(articledata)
//                self.myTable.reloadData()
//                
//            }
            
            
            
        }
    )
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        self.difficultyTableView.reloadData()
        }
    
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            deleteSomething()
    
            
//            print("tring to delete")
//            // remove the item from the data model
//            if difficultySegment.selectedSegmentIndex == 1 {
////                let databaseRef = Database.database().reference()
////                let autoID = self.V2V3[indexPath.row].autoID
////                print(autoID)
////                self.V2V3.remove(at: indexPath.row)
////                databaseRef.child("\(gym)Route").child("V2V3").child(autoID).removeValue()
////                
//                let storage = Storage.storage()
//                let storageRef = storage.reference()
//                let desertRef = storageRef.child("-KqN4AigQiMGeZ-MiKK8")
//                // Delete the file
//                desertRef.delete { error in
//                    if let error = error {
//                        print("\(error)")
//                        // Uh-oh, an error occurred!
//                    } else {
//                        print("success")
//                        // File deleted successfully
//                    }
//                }
//                self.difficultyTableView.reloadData()
//
//            }
//        } else if editingStyle == .insert {
//            // Not used in our example, but if you were adding a new row, this is where you would do it.
//            print("tring to insert")
//        }
//    }
    func deleteSomething() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "刪除",
            message: "刪除字樣會變紅色的",
            preferredStyle: .alert)
        
        // 建立[取消]按鈕
        
        
        
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[刪除]按鈕
        let okAction = UIAlertAction(title: "刪除", style: .destructive) { (UIAlertAction) in
            print("deleting")
        }
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
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

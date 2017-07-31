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
    var points: Int
    var image: String
    var routeID: String
    
}




class DifficultyViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {
    var gym = ""
    var V0V1: [String] = []
    var V2V3: [String] = []
    var V4V5: [String] = []
    var V6V7: [String] = []
    @IBOutlet weak var difficultyTableView: UITableView!
    
    @IBOutlet weak var difficultySegment: UISegmentedControl!
    
    @IBAction func difficultyAction(_ sender: UISegmentedControl) {
    }
    
    
    let difficultyLevel: [String] = ["V0-V1","V2-V3","V4-V5","V6 Up"]
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
        
        cell.difficultyLabel.text = V0V1[indexPath.row]
        return cell
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        
        
        
        if let cell = sender as? DifficultyCell {
            if let targetViewController = segue.destination as? ViewController {
                targetViewController.gym = self.gym
                
                
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gym)
        let databaseRef = Database.database().reference()

        // Do any additional setup after loading the view.
        databaseRef.child("\(gym)Route").child("V0V1").observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            if let requestData = snapshot.value as? [String: String] {
                self.V0V1.append(requestData["title"]!)
                self.difficultyTableView.reloadData()
                
//            print(requestData["color"])
//            print(requestData["title"])
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

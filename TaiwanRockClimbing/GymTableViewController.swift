//
//  GymTableViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Firebase


class GymTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var gymTableView: UITableView!
    var gymTitle: [String] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymTitle.count    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymCell", for: indexPath) as! GymCell
        cell.gymTitleLabel.text = gymTitle[indexPath.row]
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? GymCell {
            if let targetViewController = segue.destination as? DifficultyViewController {
                targetViewController.gym = cell.gymTitleLabel.text!
                
                
            }
        }
    }

    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let databaseRef = Database.database().reference()
        databaseRef.child("gym").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let requestData = snapshot.value as? [String:String] {
                self.gymTitle.append(requestData["title"]!)
                
            print(requestData["title"])
                self.gymTableView.reloadData()
            }
//            if let requestData = snapshot.value as? [String:String] {
//                var articledata = article(title: requestData["title"]!, content: requestData["content"]!, firstName: requestData["firstName"]!, lastName: requestData["lastName"]!, date: requestData["date"]!)
//                self.requestArticle.append(articledata)
//                self.myTable.reloadData()
//                
//            }
        }


      )  // Do any additional setup after loading the view.
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

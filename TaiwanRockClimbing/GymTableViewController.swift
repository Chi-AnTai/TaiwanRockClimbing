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
    var currentUser: CurrentUser?
    
    
    
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
                targetViewController.currentUser = self.currentUser
                
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let databaseRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
        databaseRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let requestData = snapshot.value as? [String: String] {
                self.currentUser = CurrentUser(name: requestData["name"]!, email: requestData["email"]!, password: requestData["password"]!, uid: snapshot.key)
                print(self.currentUser!.name)
            
            }
            
        })
        }
        
        databaseRef.child("gym").observe(.childAdded, with: { (snapshot) in
            
            if let requestData = snapshot.value as? [String:String] {
                self.gymTitle.append(requestData["title"]!)
           
                self.gymTableView.reloadData()
            }

        }


      )  // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

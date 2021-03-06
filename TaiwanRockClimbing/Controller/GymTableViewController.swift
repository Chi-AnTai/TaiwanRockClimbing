//
//  GymTableViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class GymTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var gymTableView: UITableView!
    
    var gymTitle: [String] = []
    
    var gymAddress: [String] = []
    
    var currentUser: CurrentUser?
    
    var gymImageURL: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gymTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymCell", for: indexPath) as! GymCell
        
        cell.gymTitleLabel.text = gymTitle[indexPath.row]
        
        cell.gymAddress.text = gymAddress[indexPath.row]
        
        cell.imageURL = gymImageURL[indexPath.row]
        
        cell.gymImageView.sd_setImage(with: URL.init(string: gymImageURL[indexPath.row]),
                                      placeholderImage: UIImage(named: "icon_photo"))

        cell.borderView.layer.cornerRadius = 10
        
        cell.borderView.layer.borderWidth = 2
        
        cell.borderView.layer.borderColor = UIColor(red: 33/255,
                                                    green: 150/255,
                                                    blue: 243/255,
                                                    alpha: 1
            ).cgColor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? GymCell {
            
            if let targetViewController = segue.destination as? DifficultyViewController {
                
                Analytics.logEvent("\(cell.gymTitleLabel.text!)", parameters: nil)
                
                targetViewController.gym = cell.gymTitleLabel.text!
                
                targetViewController.currentUser = self.currentUser
                
                if let url = cell.imageURL {
                    
                targetViewController.gymImageURL = url
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.startAnimating(CGSize.init(width: 120, height: 120),message: "downloading")
        
        let databaseRef = Database.database().reference()
        
        if let userID = Auth.auth().currentUser?.uid {
            
            databaseRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let requestData = snapshot.value as? [String: String] {
                    
                    self.currentUser = CurrentUser(name: requestData["name"]!,
                                                   email: requestData["email"]!,
                                                   password: requestData["password"]!,
                                                   uid: snapshot.key
                    )
                    
                    print(self.currentUser!.name)
                    
                }
                
            })
        }
        
        databaseRef.child("gym").observe(.childAdded, with: { (snapshot) in
            
            if let requestData = snapshot.value as? [String:String] {
                
                self.gymTitle.append(requestData["title"]!)
                
                self.gymAddress.append(requestData["address"]!)
                
                self.gymImageURL.append(requestData["imageURL"]!)
                
                self.stopAnimating()
                
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

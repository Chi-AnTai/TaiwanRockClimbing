//
//  DifficultyViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/7/27.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit


class DifficultyViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {
    var gym = ""
    
    let difficultyLevel: [String] = ["V0-V1","V2-V3","V4-V5","V6 Up"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "difficultyCell", for: indexPath) as! DifficultyCell
        
        cell.difficultyLabel.text = difficultyLevel[indexPath.row]
        return cell
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gym)

        // Do any additional setup after loading the view.
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

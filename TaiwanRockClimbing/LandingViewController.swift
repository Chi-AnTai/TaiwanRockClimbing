//
//  LandingViewController.swift
//  TaiwanRockClimbing
//
//  Created by 戴其安 on 2017/8/3.
//  Copyright © 2017年 戴其安. All rights reserved.
//

import UIKit
import Firebase

class LandingViewController: UIViewController {
    
    @IBOutlet weak var loginSegmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func registerAction(_ sender: UISegmentedControl) {
        switch loginSegmentControl.selectedSegmentIndex {
        case 1:
            nameTextField.isHidden = true
            loginButton.setTitle("登入", for: .normal)
        default:
            nameTextField.isHidden = false
            loginButton.setTitle("註冊", for: .normal)
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        switch loginSegmentControl.selectedSegmentIndex {
        case 0:
            if emailTextField.text == "" || nameTextField.text! == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email, password and name", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                
            } else {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    print(user?.uid)
                    
                    if error == nil {
                        print("You have successfully signed up")
                        let databaseRef = Database.database().reference()
                        if let uid = user?.uid {
                            databaseRef.child("Users").child("\(uid)").setValue(["email": self.emailTextField.text!, "password": self.passwordTextField.text!, "name": self.nameTextField.text!])
                        }
                        self.signin()
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        default:
            self.signin()
        }}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: "email")) != nil && (UserDefaults.standard.string(forKey: "password")) != nil {
            if let account = UserDefaults.standard.string(forKey: "email") as? String, let password = UserDefaults.standard.string(forKey: "password") as? String {
                print("here is \(password) and \(account)")
                Auth.auth().signIn(withEmail: account, password: password, completion: { (User, Error) in
                    print("login success")
                    
                    self.presentNextViewcontroller()
                }
                    
                )
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAccount() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print(user?.uid)
            
            if error == nil {
                print("You have successfully signed up")
                let databaseRef = Database.database().reference()
                if let uid = user?.uid {
                    databaseRef.child("Users").child("\(uid)").setValue(["email": self.emailTextField.text!, "password": self.passwordTextField.text!, "name": self.nameTextField.text!])
                }
            }
            
        }
    }
    func signin() {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (User, Error) in
            if Error == nil {
                UserDefaults.standard.setValue(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.setValue(self.passwordTextField.text!, forKey: "password")
                self.presentNextViewcontroller()
            }
            else{
                let alertController = UIAlertController(title: "Error", message: "Login Fail", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
    }
    
    func presentNextViewcontroller() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let target = storyboard.instantiateViewController(withIdentifier: "NavigationController") as UIViewController
        self.present(target, animated: false, completion: nil)
    }
    
    
}

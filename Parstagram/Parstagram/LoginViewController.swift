//
//  LoginViewController.swift
//  Parstagram
//
//  Created by LiYang on 3/25/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let user = PFUser()
        user.username = usernameText.text
        user.password = passwordText.text
        
        user.signUpInBackground { success, error in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
    @IBAction func signInAction(_ sender: Any) {
        let username = usernameText.text!
        let password = passwordText.text!
        
        
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
              } else {
                  print("Error: \(String(describing: error?.localizedDescription))")
              }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

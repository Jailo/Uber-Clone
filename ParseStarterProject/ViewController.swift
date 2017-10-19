/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    var signupMode = true

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupOrLoginButtonLabel: UIButton!
    
    @IBAction func signupOrLoginButton(_ sender: Any) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            
            displayAlert(title: "Error in form", message: "A username and password are required")
            
        } else {
            
            if signupMode {
                
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                user["isDriver"] = isDriver.isOn
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if let error = error as NSError? {
                        
                        var DisplayedErrorMessage = "Something wen't wrong, please try again later"
                        
                        if let parseError = error.userInfo["error"] as? String {
                            
                            DisplayedErrorMessage = String(parseError)
                            
                        }
                        
                        self.displayAlert(title: "Signup Error", message: DisplayedErrorMessage)
                        
                    } else {
                        
                        print("Sign up successful")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
                           
                            if isDriver {
                                
                                self.performSegue(withIdentifier: "showDriverViewController", sender: self)

                                
                            } else { //User is a rider
                                
                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                })
                
            } else { //login Mode
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    if let error = error as NSError? {
                        
                        var DisplayedErrorMessage = "Something wen't wrong, please try again later"
                        
                        if let parseError = error.userInfo["error"] as? String {
                            
                            DisplayedErrorMessage = String(parseError)
                            
                        }
                        
                        self.displayAlert(title: "Signup Error", message: DisplayedErrorMessage)
                        
                    } else {
                        
                        print("Log in successful")
                        
                        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
                            
                            if isDriver {
                                
                                 self.performSegue(withIdentifier: "showDriverViewController", sender: self)
                                
                            } else { //User is a rider
                                
                                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    @IBOutlet weak var isDriver: UISwitch!
    
    @IBOutlet weak var riderLabel: UILabel!
    
    @IBOutlet weak var driverLabel: UILabel!
    
    @IBOutlet weak var riderOrDriverLabel: UILabel!
    
    @IBOutlet weak var switchSignupModeLabel: UIButton!
    
    @IBAction func switchesSignupMode(_ sender: Any) {
        
        if signupMode == true { //Switch to log in mode
            
            signupOrLoginButtonLabel.setTitle("Log in", for: [])
            
            switchSignupModeLabel.setTitle("Switch to Sign up", for: [])
            
            signupMode = false
            
            isDriver.isHidden = true
            
            riderLabel.isHidden = true
            
            driverLabel.isHidden = true
            
            riderOrDriverLabel.isHidden = true
            
        } else { //Switch to sign up mode
            
            signupOrLoginButtonLabel.setTitle("Sign up", for: [])
            
            switchSignupModeLabel.setTitle("Switch to Log in", for: [])
            
            signupMode = true
            
            isDriver.isHidden = false
            
            riderLabel.isHidden = false
            
            driverLabel.isHidden = false
            
            riderOrDriverLabel.isHidden = false
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let isDriver = PFUser.current()?["isDriver"] as? Bool {
            
            if isDriver {
                
                 self.performSegue(withIdentifier: "showDriverViewController", sender: self)
                
            } else { //User is a rider
                
                self.performSegue(withIdentifier: "showRiderViewController", sender: self)
                
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

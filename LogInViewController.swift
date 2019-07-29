//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Najd  on 17/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController  {
    
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  EmailField.delegate = self
     //   PasswordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       enableUC(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func enableUC(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.EmailField.isEnabled = enabled
            self.PasswordField.isEnabled = enabled
            self.LoginButton.isEnabled = enabled
            self.SignUpButton.isEnabled = enabled
            enabled ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        }
}
    
    @IBAction func loginButton(_ sender: Any) {
        let activityIndicator = showActivityIndicator()
        if (EmailField.text?.isEmpty)! || (PasswordField.text?.isEmpty)! {
            Alert ( "Can't log in",  "There is email or password missing")
            activityIndicator.stopAnimating()
        }
        else {
            API.login(username: EmailField.text! , password: PasswordField.text!) { (works, error) in
                    if error != nil {
                    self.Alert("error","try again")
                }
                    else if (error == nil && works == "") {
                        self.Alert("Eror","try again")
                        
                    }

                    else if works == "No response" {
                        self.Alert("Eror","try again")
                
            }
                    else{
                        StudentInformation.password = works
                        self.performSegue(withIdentifier: "tabBar", sender: self)

                }
         
            }}}

    @IBAction func signUp(_ sender: Any) {
        if let URL = URL(string: "https://auth.udacity.com/sign-up"){
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }}
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    
    @objc func keyboardWillShow(_ notification:Notification) {
        if LoginButton.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    }


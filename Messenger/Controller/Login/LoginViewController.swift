//
//  LoginViewController.swift
//  Messenger
//
//  Created by Hanna Jung on 5/6/2564 BE.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        
        loginButton.layer.cornerRadius = 10
        
       fieldDesign(fieldName: emailField)
       fieldDesign(fieldName: passwordField)
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        
        
    }
    
   
    
    
    
    
    @IBAction func RegisterPressed(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: "loginToRegister", sender: self)
    }
    
    
    
    func fieldDesign(fieldName: UITextField) {
        
        fieldName.layer.cornerRadius = 10
        fieldName.returnKeyType = .continue
        fieldName.autocapitalizationType = .none
        fieldName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        fieldName.leftViewMode = .always
        fieldName.layer.borderWidth = 1
        fieldName.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            return alertUserLoginError()
        }
        
        //firebase Login
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (authdata, error) in
            if let e = error {
                print("Error user signing in : \(e)")
            } else if let result = authdata {
                print("User logged in : \(result.user)")
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    func alertUserLoginError()  {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}





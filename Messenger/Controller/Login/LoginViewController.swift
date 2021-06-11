//
//  LoginViewController.swift
//  Messenger
//
//  Created by Hanna Jung on 5/6/2564 BE.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    private let loginButtonFB : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    
    //Google button
        private let googleLoginButton = GIDSignInButton()
    
    
    //Google login Check
    private var loginObserver: NSObjectProtocol?
        

    
//ViewWillAppear
    override func viewWillAppear(_ animated: Bool)  {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true

        
        loginButton.layer.cornerRadius = 10
        
       fieldDesign(fieldName: emailField)
       fieldDesign(fieldName: passwordField)
        
        loginButtonFB.delegate = self
       
    //FB button
        loginButtonFB.center = view.center
        loginButtonFB.frame.origin.y = loginButtonFB.bottom+70
        view.addSubview(loginButtonFB)
        
   //Google button
        googleLoginButton.center = view.center
        googleLoginButton.frame.origin.y = loginButtonFB.bottom+30
        view.addSubview(googleLoginButton)
     
        
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        
        
    }
    

//ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//google

        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name.didLoginNotification, object: nil, queue: .main) { [weak self] _ in
            
            guard let strongself = self else {
                return
            }
            
            strongself.navigationController?.dismiss(animated: true, completion: nil)
            self?.performSegue(withIdentifier: "LoginToTabBar", sender: self)
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        title = "Log In"
        
        
        
    }
    
    
    
    
//google
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    
    
//ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

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
                
               
                self.performSegue(withIdentifier: "LoginToTabBar", sender: self)

                
            } else {
                let alertUserNotFound = UIAlertController(title: "Oops!", message: "User not found", preferredStyle: .alert)
                alertUserNotFound.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertUserNotFound, animated: true)
            }
        }
        
        
    }
    
    
//alert
    
    
    func alertUserLoginError()  {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}






//MARK: - LoginFB

extension LoginViewController : LoginButtonDelegate {
    
    
    
//Log in FB
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: AccessToken.current!.tokenString, version: nil, httpMethod: .get)
        
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String: Any], error == nil else {
                print("fail facebook request")
                return
            }
            
            print("\(result)")
            
            guard let usernameIs = result["name"] as? String, let emailIs = result["email"] as? String else {
                print("fail to get name and email from FB result")
                return
            }
            

            
//            DatabaseManager.shared.UserEmailAlreadyRegistered(with: emailIs) { (exists) -> (Void) in
//                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(username: usernameIs, emailAddress: emailIs))
//                }
//            }
            
           
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            FirebaseAuth.Auth.auth().signIn(with: credential) { (authresult, error) in
                guard authresult != nil, error == nil else {
                    print("FB credential login fail -> \(error!)")
                    return
                }
                
            }
            
            print("successfully loggedin")
            
//            self.performSegue(withIdentifier: "fbToWaitChat", sender: self)
            
//            self.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "LoginToTabBar", sender: self)
            

        }
        
        
        
        
        
//Log out FB
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    
    
}

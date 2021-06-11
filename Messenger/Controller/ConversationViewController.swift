//
//  ViewController.swift
//  Messenger
//
//  Created by Hanna Jung on 5/6/2564 BE.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseDatabase

class ConversationViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.hidesBackButton = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //send data to firebase real-time database
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        validateAuth()
    }
    
    private func validateAuth() {

        if FirebaseAuth.Auth.auth().currentUser == nil && FBSDKLoginKit.AccessToken.current == nil {
            performSegue(withIdentifier: "ConverToLogin" , sender: self)
        }
    }
    
    

    
    

}


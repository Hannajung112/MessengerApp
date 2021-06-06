//
//  ViewController.swift
//  Messenger
//
//  Created by Hanna Jung on 5/6/2564 BE.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        //send data to firebase real-time database
        
        
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "ConverToLogin" , sender: self)
        }
    }

}


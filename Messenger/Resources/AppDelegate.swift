//
//  AppDelegate.swift
//  Messenger
//
//  Created by Hanna Jung on 5/6/2564 BE.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
   

    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()

          
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)

    }
    
    
    
//google sign-in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let e = error {
                print("Failed to signin with google: \(e)")
            }
            return
        }
        
        if let email = user.profile.email, let firstname = user.profile.givenName, let lastname = user.profile.familyName {
            
            DatabaseManager.shared.UserEmailAlreadyRegistered(with: email) { (exists) -> (Void) in
                if !exists {
                    //insert to database
                    
                    DatabaseManager.shared.insertUser(with: ChatAppUser(username: "\(firstname) \(lastname)", emailAddress: email))
                }
            }
        }
        
      
        
        guard let authentication = user.authentication else {
            print("Missing auth object from google user")
            return
        }
        
        
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        
        
        
        FirebaseAuth.Auth.auth().signIn(with: credential) { (authdata, error) in
            guard authdata != nil, error == nil  else {
                print("failed to log in with google credential")
                return
            }
            
            print("Succesfully sign in with google credential")
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        }
    
        
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print("Google user was dicsconnected")
        
    }


}
    








    

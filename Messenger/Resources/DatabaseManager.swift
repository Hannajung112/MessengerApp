//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Hanna Jung on 6/6/2564 BE.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
 
    
    
}




//MARK: - Account Management

extension DatabaseManager {
    
    public func UserEmailAlreadyRegistered(with email:String, completion: @escaping ((Bool) -> (Void))) {
        
        database.child(email).observeSingleEvent(of: .value) { (snapshot) in
            if let foundEmail = snapshot.value as? String {
                print("User already register with this email : \(foundEmail)")
                
                completion(false)
                
            }
            
            completion(true)
        }
    }
    
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "username": user.username
        ])
    }
    
    
}





//Get user information
struct ChatAppUser {
    let username : String
    let emailAddress: String
    //let profilePictureUrl : String
}

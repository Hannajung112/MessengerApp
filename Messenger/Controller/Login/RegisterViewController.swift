//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Hanna Jung on 5/6/2564 BE.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        registerButton.layer.cornerRadius = 10
        
       fieldDesign(fieldName: emailField)
       fieldDesign(fieldName: passwordField)
        
        //implement profile image
        imageView.layer.masksToBounds = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        
        imageView.layer.cornerRadius = imageView.width / 2.0
     

    }
    
   


    @IBAction func ProfilePressed(_ sender: UIButton) {
        
        presentPhotoActionSheet()
        
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
    

  
    @IBAction func registerPagePressed(_ sender: UIButton) {
        
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let username = usernameField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            return alertUserRegisterError()
        }
        
 //firebase Login
        
        DatabaseManager.shared.UserEmailAlreadyRegistered(with: email) { (exists) -> (Void) in
            if exists {
                self.alertUserRegisterError(alertMessage: "This email is already used!")
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { ( authresult, error) in
                if let e = error {
                    print("Error creating user email: \(e)")
                } else {
                    
            //Grab user register data to -> DatabaseManager.swift_file
                    DatabaseManager.shared.insertUser(with: ChatAppUser(username: username, emailAddress: email))
                    
                    
            
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.usernameField.text = ""
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)

                }
            }
        }
        
    }
    
    
    
    
    func alertUserRegisterError( alertMessage: String = "Please enter all information to create a new account.")  {
        let alert = UIAlertController(title: "Woops", message: alertMessage , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}














//MARK: - UIImage Delegate & UINavigationControllers


extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo from gallery", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        
        
        present(actionSheet, animated: true)
    }
    
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true //users can editing their photo
        present(vc, animated: true)
        
    }
    
    func presentPhotoPicker()  {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true //users can editing their photo
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        imageView.image = selectedImage
        
 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

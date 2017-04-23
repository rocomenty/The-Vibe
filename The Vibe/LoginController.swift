//
//  LoginController.swift
//  
//
//  Created by Rocomenty on 4/11/17.
//
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        if (FIRAuth.auth()?.currentUser) != nil {
            self.performSegue(withIdentifier: "toMain", sender: self)
        }
        emailField.delegate = self
        pwdField.delegate = self
    }
    
    func dismissKeyboard() {
        emailField.resignFirstResponder()
        pwdField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if (emailField.text == "" || pwdField.text == "") {
            self.present(showAlert(errorCode: 0, Title: "Oops", Message: "Please enter both email and password!"), animated: true, completion: nil)
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.pwdField.text!, completion: { (user, error) in
                
                self.handleError(error: error, user: user)
                
            })
        }
    }

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if (emailField.text == "" || pwdField.text == "") {
            self.present(showAlert(errorCode: 0, Title: "Oops", Message: "Please enter both email and password!"), animated: true, completion: nil)
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: pwdField.text!, completion: {(user, error) in
                
                self.handleError(error: error, user: user)
                
            })
        }
        
    }
    
    func handleError(error: Error?, user: FIRUser?) {
        
        if error == nil {
            self.emailField.text = ""
            self.pwdField.text = ""
            self.performSegue(withIdentifier: "toMain", sender: self)
        }
        else {
            
            self.present(showAlert(errorCode: 1, Title: "Oops", Message: error!.localizedDescription), animated: true, completion: nil)
            
            
        }
        
    }

}

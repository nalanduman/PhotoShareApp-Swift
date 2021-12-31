//
//  ViewController.swift
//  PhotoShareApp
//
//  Created by Nalan Duman on 26.12.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextLabel: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        if emailTextLabel.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextLabel.text!, password: passwordTextField.text!) { authDataResult, error in
                if error != nil {
                    self.errorMessage(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            self.errorMessage(titleInput: "Hata", messageInput: "Email ve Şifre Giriniz")
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if emailTextLabel.text != "" && passwordTextField.text != "" {
            // kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTextLabel.text!, password: passwordTextField.text!) { authDataResult, error in
                if error != nil {
                    self.errorMessage(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            self.errorMessage(titleInput: "Hata!", messageInput: "Email ve Şifre Giriniz")
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}


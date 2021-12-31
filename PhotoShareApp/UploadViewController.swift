//
//  UploadViewController.swift
//  PhotoShareApp
//
//  Created by Nalan Duman on 30.12.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { storageData, error in
                if error != nil {
                    self.errorMessage(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız, tekrar deneyiniz")
                } else {
                    imageReference.downloadURL { url, error in
                        if error != nil {
                            self.errorMessage(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız, tekrar deneyiniz")
                        } else {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl {
                                let firestoreDatabase = Firestore.firestore()
                                let firestorePost = ["imageUrl": imageUrl, "comment": self.commentTextField.text!, "email": Auth.auth().currentUser!.email, "createdTime": FieldValue.serverTimestamp()] as [String : Any]
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil {
                                        self.errorMessage(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız,tekrar deneyiniz")
                                    } else {
                                        self.commentTextField.text = ""
                                        self.uploadImageView.image = UIImage(systemName: "plus")
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                           
                            }
                        }
                    }
                }
            }
        }
    }
    
    func errorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

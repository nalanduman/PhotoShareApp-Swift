//
//  FeedViewController.swift
//  PhotoShareApp
//
//  Created by Nalan Duman on 30.12.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    /*
    var emailArray = [String]()
    var commentArray =  [String]()
    var imageArray = [String]()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseSenddata()
    }
    
    func firebaseSenddata() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.postArray.removeAll(keepingCapacity: false)
                    /*
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    */
                    for document in snapshot!.documents {
                        if let email = document.get("email") as? String {
                            if let comment = document.get("comment") as? String {
                                if let image = document.get("imageUrl") as? String {
                                    let post = Post(email: email, comment: comment, imageUrl: image)
                                    self.postArray.append(post)
                                }
                            }
                        }
                        /*
                        if let email = document.get("email") as? String {
                            self.emailArray.append(email)
                        }
                        if let comment = document.get("comment") as? String {
                            self.commentArray.append(comment)
                        }
                        if let image = document.get("imageUrl") as? String {
                            self.imageArray.append(image)
                        }
                         */
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
        /*
        return emailArray.count
         */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        cell.emailLabel.text = postArray[indexPath.row].email
        cell.commentLabel.text = postArray[indexPath.row].comment
        cell.feedImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        /*
        cell.emailLabel.text = emailArray[indexPath.row]
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.feedImageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        */
         return cell
    }

}

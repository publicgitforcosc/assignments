//
//  HomeViewController.swift
//  StudyShare
//
//  Created by CGi on 21/08/22.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
    }
        
    func getUserDetails(){
        // https://www.anycodings.com/1questions/4119941/optimizing-get-from-firestore-in-swift
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            User.UID = user!.uid
           
            let userDetails = db.collection("users").whereField("uid", isEqualTo: User.UID)
            userDetails.getDocuments(){ (querySnaphot, err) in
                if let err = err {
                    print("error: \(err)")
                } else{
                    User.username = (userDataDict["username"] as! String)
                }
            }
        } else {
            print("error: authentification error") // debug!
        }
    }
}

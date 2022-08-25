//
//  HomeViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 31/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserDetails()
        // Do any additional setup after loading the view.
    }
    
    /**
            Utilizes the currently logged in users UID to retreive their full info from firebase db
            Stores this information in a class dedicated to holding the users info.
            Retrives and stores firstname, lastname, documentID(firebase reference to this user)
    */
    func setUpUserDetails(){
        
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            User.UID = user!.uid
            let db = Firestore.firestore()
            let userData = db.collection("users").whereField("uid", isEqualTo: User.UID)
            userData.getDocuments(){ (querySnaphot, err) in
                if let err = err {
                    print("Error retrieving user data: \(err)")
                } else{
                    let document = querySnaphot!.documents[0]
                    let userDataDict = document.data()
                    User.firstName = (userDataDict["firstname"] as! String)
                    User.lastName = (userDataDict["lastname"] as! String)
                    User.docID = document.documentID
                }
            }
        } else {
            // Something has gone horribly wrong
        }
    }

}

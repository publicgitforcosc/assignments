//
//  CreateClassViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 19/08/22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase

class CreateClassViewController: UIViewController {


    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var paperCodeField: UITextField!
    @IBOutlet weak var paperDescField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var semesterField: UITextField!
    @IBOutlet weak var institutionField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 1

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createButtonTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            errorLabel.text = error
        } else {
            let name = paperCodeField.text!
            let desc = paperDescField.text!
            let year = Int(yearField.text!)
            let sem = Int(semesterField.text!)
            let instit = institutionField.text!
            let dirName = name + "_" + yearField.text! + "_" + semesterField.text!
            
            
            let db = Firestore.firestore()
            db.collection("classes").addDocument(data: ["Name" : name,
                                                      "Description" : desc,
                                                      "Year" : String(year!),
                                                        "Semester": String(sem!),
                                                        "Institution" : instit,
                                                        "Filepath" : dirName]) { (error) in
                if error != nil{
                    // There was an error
                    self.showError("Could not connect to database, class not created")
                }
            }
            let storerr = initStorage(dirName)
            if storerr != nil{
                showError(storerr!)
            } else{
                
            }
            let userRef = db.collection("users").document(User.docID)
            userRef.updateData(["groups": FieldValue.arrayUnion([dirName])])
            User.groups.append(dirName)
            print("USER GROUPS")
            print(User.groups)
        }
    }
    
    func validateFields() -> String?{
        if !paperCodeField.hasText{
            return "Please fill out name"
        }
        if !paperDescField.hasText{
            return "Please fill out description"
        }
        if !yearField.hasText{
            return "Please fill out year"
        }
        if !semesterField.hasText{
            return "Please fill out semester"
        }
        if !institutionField.hasText{
            return "Please fill out institution"
            // TODO: Validate this a valid institution
        }
        //TODO: Add more validation, prevent duplicates by checking db for existing name+year+sem combo
        let semNum = Int(semesterField.text!) ?? 0
        if semNum != 1 && semNum != 2{
            return "Semester must be 1 or 2"
        }
        let yearNum = Int(yearField.text!) ?? 0
        let currYear = Calendar.current.component(.year, from: Date())
        if yearNum != currYear && yearNum != currYear + 1{
            return "Year must be this year or next year"
        }
        return nil
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func initStorage(_ filePath:String)->String? {
        let data: Data? = "init".data(using: .utf8)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let classStorageLoc = storageRef.child(filePath + "/temp.txt")
        classStorageLoc.putData(data!)
        return nil
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

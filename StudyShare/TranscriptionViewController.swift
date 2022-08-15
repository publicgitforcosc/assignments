//
//  TranscriptionViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 7/08/22.
//

import UIKit

class TranscriptionViewController: UIViewController {

    @IBOutlet weak var transcriptionView: UIView!
    @IBOutlet weak var transcriptionText: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func beginButtonTapped(_ sender: Any) {
        // User has tapped the "Begin Transcription" button
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // User has tapped the save button
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

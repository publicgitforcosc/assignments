//
//  RecordingViewController.swift
//  StudyShare
//
//  Created by CGi on 22/08/22.
//  inspiration & material from koffler - swift & swift documentation
//

import UIKit
import AVKit
import AVFoundation

import MobileCoreServices
import SafariServices

class RecordingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
      
    @IBAction func recordTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false
        {
          return
        }
        
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .camera
        imgPicker.mediaTypes = [kUTTypeMovie as String]
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
       
   
    }
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    // Generic view for containing video, this may not be what we want here
    @IBOutlet weak var videoView: UIView!
    


}

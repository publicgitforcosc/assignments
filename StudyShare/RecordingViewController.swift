//
//  RecordingViewController.swift
//  StudyShare
//
//  Created by CGi on 22/08/22.
//
//  inspiration & some material taken from koffler - swift, rheinwerk
//  & swift documentation, eg. https://developer.apple.com/documentation/uikit/UIImagePickerController
//

import UIKit
import AVKit

import MobileCoreServices
import SafariServices

class RecordingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
     
    @IBAction func recordTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false
        {
            print("camera not available")
          return
        } else {
            record(delegate:self)
        }
    }

    func record(delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .camera
        imgPicker.mediaTypes = [kUTTypeMovie as String]
        imgPicker.delegate = delegate //self
        delegate.present(imgPicker, animated: true, completion: nil)
    }

    // Generic view for containing video, this may not be what we want here
    @IBOutlet weak var videoView: UIView!
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        dismiss(animated: true, completion: nil)

        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String) // dont forget to add a comma when using next line!
// ->       let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL // << what we need.
        else { return }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


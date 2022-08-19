//
//  TranscriptionViewController.swift
//  StudyShare
//
//  - simulator catch for the moment: you need to press several times
//    start/stop transcription before it works
//  - 60seconds apple limit patch does not work in simulator!
//  - line 97 contains the final result to save
//
//  Created by CGi on 12/08/22.
//
import UIKit
import Speech
import AVKit
import UIKit

class TranscriptionViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var transcriptionView: UIView!
    @IBOutlet weak var transcriptionText: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-EN"))
    var recognitionTask         : SFSpeechRecognitionTask?
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    let audioEngine             = AVAudioEngine()

    func setupSpeech() {
        
        self.beginButton?.isEnabled = true
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isButtonEnabled = false

            switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                case .denied:
                    isButtonEnabled = false
                case .notDetermined:
                    isButtonEnabled = false
                case .restricted:
                    isButtonEnabled = false
                @unknown default:
                    fatalError()
            }
            
            OperationQueue.main.addOperation() {
                self.beginButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        if #available(iOS 13, *) { 
            // patch around the 60seconds apple limit, does not work in simulator!
            self.recognitionRequest?.requiresOnDeviceRecognition = true
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            if result != nil {
                self.transcriptionText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //self.transcriptionText.text! << this final to save!
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine encountered an error.")
        }
        self.transcriptionText.text = "Start speaking"
        self.beginButton?.setTitle("Stop", for: .normal)
    }
    
    override func viewDidLoad() {
        self.beginButton?.isEnabled = true
        super.viewDidLoad()
        self.setupSpeech()
    }
    
    @IBAction func beginButtonTapped(_ sender: UIButton) {
        print("button tapped") // debug!
          if audioEngine.isRunning {
             self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
              self.beginButton?.setTitle("Start Transcription", for: .normal)
          } else {
            self.startRecording()
              self.beginButton?.setTitle("Stop Transcription", for: .normal)
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
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


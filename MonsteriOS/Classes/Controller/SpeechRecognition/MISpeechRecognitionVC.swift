//
//  MISpeechRecognitionVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 18/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Speech
import Lottie

enum SpeechRecognizerStatus {
    case Stopped, Recording
}

@available(iOS 10.0, *)
class MISpeechRecognitionVC: UIViewController {
    
    @IBOutlet weak var micImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speechLabel: UILabel!
    
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let animationView = AnimationView()

    var timer: Timer?
    
    var completionHandler: ((VoiceModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animation = Animation.named("speechAnimation")

        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.8
        self.view.addSubview(animationView)
        self.view.bringSubviewToFront(self.micImgView)
        
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false

        animationView.topAnchor.constraint(equalTo: micImgView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: micImgView.bottomAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: micImgView.heightAnchor).isActive = true
        animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        
        // Tap mic to ask me like this
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            OperationQueue.main.addOperation() {
                
                var alertTitle = ""
                var alertMsg = ""
                
                switch authStatus {  //5
                case .authorized:
                    self.startRecording()
                    
                case .denied:
                    alertTitle = "Permission denied"
                    alertMsg = "Please enable speech recognition in Settings"
                    
                case .restricted:
                    alertTitle = "Could not start the speech recognizer"
                    alertMsg = "Check your internect connection and try again"
                    
                case .notDetermined:
                    alertTitle = "Could not start the speech recognizer"
                    alertMsg = "Speech recognition not yet authorized"
                }
                
                if alertTitle != "" {
                    self.showAlert(title: "", message: alertMsg, isErrorOccured: true) {
                       self.dismiss(animated: true, completion: nil)
                    }
//                    self.showPopUpView(title: alertTitle, message: alertMsg, primaryBtnTitle: "OK") { (_) in
//                        self.dismiss(animated: true, completion: nil)
//
//                    }
                    
//                    let vPopup = MIJobPreferencePopup.popup()
//                    vPopup.setViewWithTitle(title: alertTitle, viewDescriptionText:  alertMsg, or: "", primaryBtnTitle: "Ok", secondaryBtnTitle: "")
//                    vPopup.completionHandeler = {
//                        self.dismiss(animated: true, completion: nil)
//
//                    }
//                    vPopup.cancelHandeler = {
//
//                    }
//                    vPopup.addMe(onView: self.view, onCompletion: nil)
//
//
                    
                    
                    
//
//                    let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: { (action) in
//                        self.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.SPEECH_RECOGNITION)
    }
    @IBAction func micAction(_ sender: Any) {
        if audioEngine.isRunning {
            self.stopRecording()
        } else {
            startRecording()
        }
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        if audioEngine.isRunning {
            self.stopRecording()
        }
        self.dismiss(animated: true) {
            if let d = sender as? VoiceModel {
                self.completionHandler?(d)
            }
        }
    }
    
    @objc func timerEnded() {
        if !self.speechLabel.text!.isEmpty {
            self.fetchKeywordsFromAPI()
        } else {
            self.micAction(0)
        }
    }
}



@available(iOS 10.0, *)
extension MISpeechRecognitionVC: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.micImgView.isUserInteractionEnabled = true
        } else {
            self.micImgView.isUserInteractionEnabled = false
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        micImgView.isHidden = false
        animationView.stop()

        self.timer?.invalidate()
        self.timer = nil
        
        self.titleLabel.text = "Tap mic to ask."
    }
    
    func startRecording() {
        self.titleLabel.text = "Speak Now"
        self.speechLabel.text = ""
        
        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(self.timerEnded), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        self.timer = timer
        
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
        micImgView.isHidden = true
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .interruptSpokenAudioAndMixWithOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if let res = result {
                
                self.speechLabel.text = res.bestTranscription.formattedString
                isFinal = res.isFinal
                
                print(res.isFinal)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func fetchKeywordsFromAPI() {
        MIApiManager.voiceSearchAPI(self.speechLabel.text!) { (result, error) in
            
            self.micAction(0)
            
            guard let data = result else { return }
            
            guard data.experience.count + data.locations.count + data.salary.count + data.skills.count > 0 else  {
                self.showAlert(title: nil, message: "Sorry, I didn't get what you said...")
                return
            }
            
            self.closeButtonAction(data)
        }
    }
}

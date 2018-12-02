//
//  inGameRepeatSemanticActivityViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-23.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import Speech
import FirebaseDatabase

struct Answer {
    var value: String = ""
    var isValid: Bool = false
}

class inGameRepeatSemanticActivityViewController: UIViewController, SFSpeechRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    var ref: DatabaseReference!
    
    
    // vc outlets
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var answerInput: UITextField!
    @IBOutlet weak var answerTable: UITableView!
    @IBOutlet weak var answersInputtedOutlet: UILabel!
    @IBOutlet var activityCompletedView: UIView!
    @IBOutlet var microphoneOutlet: UIButton!
    @IBOutlet var microphoneLabel: UILabel!
    @IBOutlet var finalScoreLabel: UILabel!
    // var in charge of answers
    var wordsUsedList: [String]!
    var answerList: [Answer] = []
    var numberOfAnswers: Int = 0
    
    // speech vars
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    @IBAction func doneActivityButton(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // hides keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.answerInput.delegate = self
        
        self.activityCompletedView.isHidden = true
        numberOfAnswers = self.wordsUsedList.count
        self.microphoneLabel.text = "Start Recording"
        self.microphoneOutlet.setImage(UIImage(named: "black-microphone.png"), for: .normal)
        self.answersInputtedOutlet.text = "0/\(numberOfAnswers) answers"
        print(numberOfAnswers)
        microphoneButton.isEnabled = false
        speechRecognizer!.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            var isButtonEnabled = false
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    @IBAction func DismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for : indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for : indexPath) as! SemanitcAnswerTableViewCell
        
        cell.answerView?.text = self.answerList[indexPath.row].value
        
        if self.answerList[indexPath.row].isValid == true {
            cell.answerView?.textColor = UIColor(red: 0/255, green: 170/255, blue: 28/255, alpha: 1.0)
            cell.backgroundColor = UIColor(hue: 0.3222, saturation: 0.1, brightness: 1, alpha: 1.0)
            cell.checkErroView?.image = UIImage(named: "correct.png")
        }else{
            cell.answerView?.textColor = .red
            cell.backgroundColor = UIColor(hue: 0, saturation: 0.09, brightness: 1, alpha: 1.0)
            cell.checkErroView?.image = UIImage(named: "error.png")
        }
        
        return cell
    }
    
    // action sending answer to answer array
    @IBAction func submitAnswer(_ sender: Any) {
        if self.answerInput.text != "" {
            let item = self.answerInput.text!.lowercased().capitalized.trimmingCharacters(in: .whitespaces)
            
            var answer = Answer(value: item, isValid: false)
            
            if let index = wordsUsedList.index(of: item) {
                wordsUsedList.remove(at: index)
                answer.isValid = true
            }
            
            self.answerList.append(answer)
            answerTable.reloadData()
            self.answersInputtedOutlet.text = "\(self.answerList.count)/\(numberOfAnswers) answers"
            self.answerInput.text = ""
            
            if self.answerList.count == numberOfAnswers {
                activityOver()
            }
        }
    }
    
    
    @IBAction func giveUpAction(_ sender: Any) {
        activityOver()
    }
    
    // function terminting game and calculating final score
    func activityOver() {
        textFieldShouldReturn(self.answerInput)
        let finalScore = self.numberOfAnswers-wordsUsedList.count
        print("Final score is \(finalScore)/\(self.numberOfAnswers)")
        self.activityCompletedView.isHidden = false
        self.finalScoreLabel.text = "Final score: \(finalScore)/\(self.numberOfAnswers)"
        
        
        //Post
        ref=Database.database().reference()
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat="dd.MM.yyyy"
        let result = formater.string(from: date)
        
        
        ref?.child("Date2V5").childByAutoId().setValue(result)
        ref?.child("semScoreV5").childByAutoId().setValue(String(finalScore))
        
        
    }
    
    // action controlling the microphone recording button
    @IBAction func microphoneTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            self.microphoneLabel.text = "Start Recording"
            self.microphoneOutlet.setImage(UIImage(named: "black-microphone.png"), for: .normal)
            //            microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            
            self.microphoneLabel.text = "Stop Recording"
            self.microphoneOutlet.setImage(UIImage(named: "red-microphone.png"), for: .normal)
            //            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    // takes recorded speech and converts to text
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                let speech2TextResult = result?.bestTranscription.formattedString
                self.answerInput.text = speech2TextResult
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
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
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
}

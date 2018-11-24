//
//  InGameSemanticViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-23.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import AVFoundation

class InGameSemanticViewController: UIViewController {

    var wordList: [String] = ["Apple", "Motorcycle", "Building", "Toothbrush", "Mirror", "Snow", "Candle", "Rug", "Wax", "Keyboard", "Dog", "Captain", "Computer", "Tile", "Bedroom"]
    var activityList: [String] = []
    weak var timer: Timer?
    var index: Int = 0;
    @IBOutlet weak var pausedPage: UIView!
    
    @IBOutlet weak var activityKeyWord: UILabel!
    
    func timeRefresh(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(InGameSemanticViewController.refreshKeyWordData), userInfo: nil, repeats: true)
    }
    
    // Refreshes label content & uses text to speech
    @objc func refreshKeyWordData(){
        if(index <= 10){
            let keyword = activityList[index]
            let utterance = AVSpeechUtterance(string: keyword)
            let synth = AVSpeechSynthesizer()
        
            activityKeyWord.text = keyword
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)

            index = index + 1;
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pausedPage.isHidden = true;
        activityList = wordList.shuffled()
        print(activityList)
        timeRefresh()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func pauseActivity(_ sender: Any) {
        timer?.invalidate()
        self.pausedPage.isHidden = false;
    }
    
    @IBAction func quitActivity(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

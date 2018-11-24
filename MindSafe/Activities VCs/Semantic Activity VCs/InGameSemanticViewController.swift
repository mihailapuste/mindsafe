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
    var randomizedList: [String] = []
    var wordsUsedList: [String] = []
    weak var timer: Timer?
    var index: Int = 0;
    @IBOutlet weak var pausedPage: UIView!
    
    @IBOutlet weak var pausePlayButton: UIBarButtonItem!
    @IBOutlet weak var activityKeyWord: UILabel!
    
    func timeRefresh(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(InGameSemanticViewController.refreshKeyWordData), userInfo: nil, repeats: true)
    }
    
    // Refreshes label content & uses text to speech
    @objc func refreshKeyWordData(){
        if(index <= 9){
            let keyword = randomizedList[index]
            let utterance = AVSpeechUtterance(string: keyword)
            let synth = AVSpeechSynthesizer()
           
            activityKeyWord.text = keyword
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
            
            wordsUsedList.append(keyword)
            index = index + 1;
        }else{
            timer?.invalidate()
            performSegue(withIdentifier: "RepeatActivity", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? inGameRepeatSemanticActivityViewController{
            print(wordsUsedList)
            vc.wordsUsedList = wordsUsedList
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        index = 0;
        wordsUsedList.removeAll() // clear in case of restarded game
        activityKeyWord.text = "Semantic Activity"
        self.pausedPage.isHidden = true;
        randomizedList = wordList.shuffled()
        timeRefresh()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func restartActivity(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction func pauseActivity(_ sender: Any) {
        timer?.invalidate()
        self.pausedPage.isHidden = false;
    }
    
    @IBAction func quitActivity(_ sender: Any) {
        timer?.invalidate()
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

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

    var wordList: [String] = ["Apple", "Motorcycle", "Building", "Toothbrush", "Mirror", "Snow", "Candle", "Rug", "Wax", "Keyboard", "Dog", "Captain", "Computer", "Tile", "Bedroom", "Car", "Lamp", "Desk", "Plum", "Book", "Switch", "Camera", "Shelf", "Ocean", "Breeze", "Shell", "Tree", "Television", "Couch", "Ball", "Table", "Boat", "Rope", "Canvas", "Brush", "Mountain", "Grass", "Branch", "Bush", "Leaf", "Paper", "Glass", "Rock", "Scissors", "Hand", "Face", "Hair", "Mouth", "Orange", "Fish", "Space", "Frame", "Goggles", "Box", "Bed", "Kayak", "Roof", "Window", "Door", "Chair", "Column", "Row", "Needle","Yarn", "Barn", "Horse", "Chicken", "Cow", "Black", "Yellow", "Green", "White", "Purple", "Pink", "Brown", "Light", "Dark", "Art", "Cold", "Warm", "Hot"]
    var randomizedList: [String] = []
    var wordsUsedList: [String] = []
    weak var timer: Timer?
    var index: Int = 0
    let gameLength: Int = 10 // Number of words the user is prompted with
    @IBOutlet weak var pausedPage: UIView!
    
    @IBOutlet weak var wordCount: UILabel!
    @IBOutlet weak var pausePlayButton: UIBarButtonItem!
    @IBOutlet weak var activityKeyWord: UILabel!
    
    func timeRefresh(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(InGameSemanticViewController.refreshKeyWordData), userInfo: nil, repeats: true)
    }
    
    // Refreshes label content & uses text to speech
    @objc func refreshKeyWordData(){
        if(index < gameLength){
            let keyword = randomizedList[index]
            let utterance = AVSpeechUtterance(string: keyword)
            let synth = AVSpeechSynthesizer()
           
            activityKeyWord.text = keyword
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
            
            wordsUsedList.append(keyword)
            index = index + 1;
            wordCount.text = "\(index)/\(gameLength)"
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
        activityKeyWord.text = " "
        wordCount.text = "0/\(gameLength)"
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
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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

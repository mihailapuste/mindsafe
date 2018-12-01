//
//  SoundManager.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-12-01.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        // determine which sound effect we want to play
        // and set the appropraite file name
        switch effect {
            case .flip:
                soundFileName = "cardflip"
            case .shuffle:
                soundFileName = "shuffle"
            case .match:
                soundFileName = "dingcorrect"
            case .nomatch:
                soundFileName = "dingwrong"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Could not find \(soundFileName) file in bundle.")
            return
        }
        
        // Create a URL obj from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create audio play object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL )
            
            // play the sound
            audioPlayer?.play()
        }
        catch {
            // couldnt create audio player obj, log error
            print("couldnt create audio player obj for sound file \(soundFileName)")
        }
    }
    
}

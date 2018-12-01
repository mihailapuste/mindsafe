//
//  CardModel.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-28.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCard() -> [Card] {
        
        // Declare array to store numbers already generated
        var generatedNumbersArray = [Int]()
        
        // declare array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // randomly generate pairs of cards
        while generatedNumbersArray.count < 10 {
            // get random number
            let randomNumber = arc4random_uniform(26) + 1 // random number from 1-13
           
            // Ensure random number is not duplicated
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                print(randomNumber )
                
                // store number in generatedNumbersArray
                generatedNumbersArray.append(Int(randomNumber))
                
                // create first card
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                // create second card
                let cardtwo = Card()
                cardtwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardtwo)
                
            }
            
        }
        
        // randomize the array
        //generatedCardsArray.shuffle()
        
        // return the array
        return generatedCardsArray
        
    }
}

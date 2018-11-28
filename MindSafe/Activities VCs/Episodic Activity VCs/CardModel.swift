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
        
        // declare array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // randomly generate pairs of cards
        for _ in 1...8 {
            // get random number
            let randomNumber = arc4random_uniform(26) + 1 // random number from 1-13
           
            print(randomNumber )
            // create first card
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardOne)
            
            // create second card
            let cardtwo = Card()
            cardtwo.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardtwo)
            
            // optional: make it so that we only have unique pairs of cards
            
        }
        
        // TODO: randomize the array
        
        
        // return the array
        return generatedCardsArray
        

        
        
        
        
    }
}

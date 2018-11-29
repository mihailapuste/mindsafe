//
//  EpisodicViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-21.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

//test
class EpisodicViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray =  [Card]() // empty card array
    
    var firstFlippedCardIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // call the getCardMethod of the CardModel
        cardArray = model.getCard()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get cardcollectionview cell obj
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // get card we are trying to display
        let card = cardArray[indexPath.row]
        
        // set card in cell obj
        cell.setCard(card)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // get card we are trying to display
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false {
            
            // flip the card
            cell.flip()
            card.isFlipped = true
            
            // determine if it is the first card or second card thats flipped over
            if firstFlippedCardIndex == nil {
                // this is the first card being flipped
                firstFlippedCardIndex = indexPath

            }
            else{
                // this is the second card being flipped
                
                // TODO: Perform the matching logic
            }
        }
        
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the cells from the cells for the two cards revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // get the cards from the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // its a match
            
            // set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
        } else {
            
            // its not a match
            
            // set the statuses of the card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        firstFlippedCardIndex = nil
    }

}

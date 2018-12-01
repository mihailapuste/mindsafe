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
    
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray =  [Card]() // empty card array
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer:Timer?
    var milliseconds: Float = 180 * 1000 // 180 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the getCardMethod of the CardModel
        cardArray = model.getCard()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle) // 19:38
        
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
       
        // check if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // get card we are trying to display
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            // flip the card
            cell.flip()
            
            // play flip sound
            SoundManager.playSound(.flip)
            
            
            card.isFlipped = true
            
            // determine if it is the first card or second card thats flipped over
            if firstFlippedCardIndex == nil {
                // this is the first card being flipped
                firstFlippedCardIndex = indexPath

            }
            else{
                // this is the second card being flipped
                
                // TODO: Perform the matching logic
                checkForMatches(indexPath)
            }
        }
        
    }
    // MARK: - Timer methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1;
        
        // Express in seconds (formatted to 2 dec places)
        let seconds = String(format: "%.2f", milliseconds/1000)
        timerLabel.text = "Time remaining: \(seconds)"
        
        // when timer reaches 0s ( stop timer )
        if milliseconds <= 0 {
            
            // stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // check if there are any cards unmatched
            checkGameEnded()
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
            
            // play flip sound
            SoundManager.playSound(.match)
            
            // set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // check if there are any cards left unmatched
            checkGameEnded()
            
        } else {
            
            // its not a match
            
            // play flip sound
            SoundManager.playSound(.nomatch)
            
            // set the statuses of the card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // tell the collectionview to reload the view of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        // reset the property that tracks the first card flipped
        
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
    
    // Determine if there are any cards unmatched
    var isWon = true
        
    for card in cardArray {
        
        if card.isMatched == false {
            isWon = false
            break
        }
            
    }
        
    // Messaging alert
    var title = ""
    var message = ""
        
    // if not, then the user has one
    if isWon == true {
            
        if milliseconds > 0 {
            timer?.invalidate()
        }
        
        title = "Congradulations!"
        message = "You've won."
            
    }
    else{
    // if there are unmatched cards, check if there is any time left
        
        if milliseconds > 0 {
            return
        }
        
        title = "Game over!"
        message = "You've lost."
        
    }
   
        
    // show won or lost messaging
    showAlert(title, message)
 
    }
    
    func showAlert(_ title: String, _ message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

}

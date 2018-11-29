//
//  CardCollectionViewCell.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-28.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
       
    @IBOutlet var frontImageView: UIImageView!
    
    @IBOutlet var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ card:Card) {
        
        // keeps track of card getting passed in
        self.card = card
        
        if card.isMatched == true {
            // if the card has been matched, make the imageviews invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        } else {
            // if the card hasnt been matched, make imageviews visible
            frontImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // deteremine in card is in flipped up or down state
        
        if card.isFlipped == true {
            
            // make sure frontimageview is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }
        else {
            
            // make sure backimageview is on top
             UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove() {
        // removes both imageviews from being visible
        backImageView.alpha = 0
        
        // TODO: Animate action
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
           
            self.frontImageView.alpha = 0
            
        }, completion: nil)
        
        
    }
}

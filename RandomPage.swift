//
//  SecondViewController.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 04/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//
import UIKit

var navBarTitle:String = "Portieri"
var picked:String = "portieri"
var change:Bool = false
var extracted:[String] = []
var dataNeedToPersist:Bool = false
var playerName:String = ""
var firstLoad:Bool = false
var remains:Int = 100
var available:Bool = false
var sezione:String = ""
var lastPlayer:Player? = nil


// player storage
var previousPlayer:Player? = nil
var nextPlayer:Player? = nil

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}

class RandomPage: TisprCardStackViewController, TisprCardStackViewControllerDelegate {
    
    
    @IBOutlet weak var subview: UIButton!
    
    fileprivate let colors = [UIColor(red: 45.0/255.0, green: 62.0/255.0, blue: 79.0/255.0, alpha: 1.0),
                              UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0),
                              UIColor(red: 141.0/255.0, green: 72.0/255.0, blue: 171.0/255.0, alpha: 1.0),
                              UIColor(red: 241.0/255.0, green: 155.0/255.0, blue: 44.0/255.0, alpha: 1.0),
                              UIColor(red: 234.0/255.0, green: 78.0/255.0, blue: 131.0/255.0, alpha: 1.0),
                              UIColor(red: 80.0/255.0, green: 170.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    ]
    
    fileprivate var countOfCards: Int = 6
    //method to add new card
   
    /*@IBAction func addNewCards(_ sender: AnyObject) {
        countOfCards += 1
        newCardWasAdded()
    }*/
    
    
    override func numberOfCards() -> Int {
        return countOfCards
    }
    
    override func card(_ collectionView: UICollectionView, cardForItemAtIndexPath indexPath: IndexPath) -> TisprCardStackViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath as IndexPath) as! TisprCardStackDemoViewCell
        
        cell.backgroundColor = colors[indexPath.item % colors.count]
        cell.text.text = "Card - \(indexPath.item)"
        
        return cell
        
    }
    
    func cardDidChangeState(_ cardIndex: Int) {
        print("card with index - \(cardIndex) changed position")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set animation speed
        setAnimationSpeed(0.85)
        
        //set size of cards
        let size = CGSize(width: view.bounds.width - 40, height: 2*view.bounds.height/3)
        setCardSize(size)
        
        cardStackDelegate = self
        
        //configuration of stacks
        layout.topStackMaximumSize = 4
        layout.bottomStackMaximumSize = 30
        layout.bottomStackCardHeight = 45
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


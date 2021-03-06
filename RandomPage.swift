//
//  SecondViewController.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 04/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//
import UIKit
import AVFoundation
import AudioToolbox

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
var soundOn:Bool = true

var player: AVAudioPlayer?

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

class RandomPage: UIViewController{
    
    @IBOutlet weak var randomName: UILabel!
    @IBOutlet weak var randomSurname: UILabel!
    @IBOutlet weak var randomTeam: UILabel!
    @IBOutlet weak var randomQuotation: UILabel!
    @IBOutlet weak var assignButton: UIButton!
    
    @IBOutlet weak var wallpaperImage: UIImageView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var cardImage: UIImageView!
    
    // star
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    // slider
    @IBOutlet weak var nextImagePlayer: UIImageView!
    @IBOutlet weak var lastImagePlayer: UIImageView!
    
    var first: Homepage = Homepage(nibName: nil, bundle: nil)
    var role: String = ""
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubview(toBack: wallpaperImage)
        
        if(calculateScreenSize() < 325.0){
            self.star1.isHidden = true
            self.star2.isHidden = true
            self.star3.isHidden = true
            self.star4.isHidden = true
            
            self.randomQuotation.textColor = self.randomTeam.textColor
            self.randomName.textColor = self.randomTeam.textColor
        }
        
        // swipe init
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Wallpaper alpha view
        lastImagePlayer.alpha = 0.5
        nextImagePlayer.alpha = 0.5
        
        self.view.bringSubview(toFront: cardImage)
        self.view.bringSubview(toFront: lastImagePlayer)
        self.view.bringSubview(toFront: nextImagePlayer)
        navBar.title = navBarTitle
        
        click("c")
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                self.star1.image = nil
                self.star2.image = nil
                self.star3.image = nil
                self.star4.image = nil
                self.star5.image = nil
                
                if(remains > 1){
                    // I have to put the left  player, and set actual as next and previous null
                    if(previousPlayer != nil){
                        // Check previous
                        nextPlayer = lastPlayer
                        changeCardPreviousNextWithAnimation(giocatore: nextPlayer!, choose: "next")
                        
                        let tempPlayer:Player = previousPlayer!
                        
                        // Save into lastPlayer information
                        lastPlayer = tempPlayer
                        
                        // Extract next
                        previousPlayer = nil
                        lastImagePlayer.image = UIImage.init(named: "")
                        
                        playerName = tempPlayer.name
                        
                        self.view.bringSubview(toFront: randomName);
                        self.view.bringSubview(toFront: randomQuotation);
                        self.randomTeam.text = tempPlayer.team
                        self.randomQuotation.text = tempPlayer.quotation
                        self.randomName.text = tempPlayer.name
                        self.role = tempPlayer.role
                        
                        self.star1.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star1);
                        let myNumber = Int(tempPlayer.quotation)
                        
                        if(myNumber! > 2){
                            self.star2.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star2);
                        }
                        if(myNumber! > 7){
                            self.star3.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star3);
                        }
                        if(myNumber! > 10){
                            self.star4.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star4);
                        }
                        if(myNumber! > 20){
                            self.star5.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star5);
                        }
                        
                        changeCardWithAnimation(giocatore: tempPlayer)
                        
                    }
                }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.star1.image = nil
                self.star2.image = nil
                self.star3.image = nil
                self.star4.image = nil
                self.star5.image = nil
                
                if(remains > 1){
                    // I have to put the right player, extract new one for next and set actual as previous
                    // Check previous
                    previousPlayer = lastPlayer
                    changeCardPreviousNextWithAnimation(giocatore: previousPlayer!, choose: "previous")
                    
                    let tempPlayer:Player = nextPlayer!
                    
                    // Save into lastPlayer information
                    lastPlayer = nextPlayer
                    
                    // Extract next
                    if(remains > 1){
                        nextPlayer = extractRandomPlayer(actualPlayer: (lastPlayer?.name)!)
                        changeCardPreviousNextWithAnimation(giocatore: nextPlayer!, choose: "next")
                    }else{
                        nextPlayer = nil
                        lastImagePlayer.image = UIImage.init(named: "")
                    }
                    playerName = tempPlayer.name
                    
                    self.view.bringSubview(toFront: randomName);
                    self.view.bringSubview(toFront: randomQuotation);
                    self.randomTeam.text = tempPlayer.team
                    self.randomQuotation.text = tempPlayer.quotation
                    self.randomName.text = tempPlayer.name
                    self.role = tempPlayer.role
                    
                    self.star1.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star1);
                    let myNumber = Int(tempPlayer.quotation)
                    
                    if(myNumber! > 2){
                        self.star2.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star2);
                    }
                    if(myNumber! > 7){
                        self.star3.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star3);
                    }
                    if(myNumber! > 10){
                        self.star4.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star4);
                    }
                    if(myNumber! > 20){
                        self.star5.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star5);
                    }
                    
                    changeCardWithAnimation(giocatore: tempPlayer)
                    
                }
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func assignEvent(_ sender: Any) {
        if(soundOn){
        playSound()
        }
        AudioServicesPlaySystemSound(1519)
        
        // retrieved player touched
        let touched:String! = playerName
        print("Assegned " + touched)
        
        // check from role
        switch self.role {
        case "P":
            sezione = "Portieri"
            if let i = portieri.index(where: { $0.name == touched }) {
                portieri[i].marked = true
                extracted.append(portieri[i].name)
            }
            remains = portieri.filter { $0.marked == false }.count
        case "D":
            sezione = "Difensori"
            if let i = difensori.index(where: { $0.name == touched }) {
                difensori[i].marked = true
                extracted.append(difensori[i].name)
            }
            remains = difensori.filter { $0.marked == false }.count
        case "C":
            sezione = "Centrocampisti"
            if let i = centrocampisti.index(where: { $0.name == touched }) {
                centrocampisti[i].marked = true
                extracted.append(centrocampisti[i].name)
            }
            remains = centrocampisti.filter { $0.marked == false }.count
        case "A":
            sezione = "Attaccanti"
            if let i = attaccanti.index(where: { $0.name == touched }) {
                attaccanti[i].marked = true
                extracted.append(attaccanti[i].name)
            }
            remains = attaccanti.filter { $0.marked == false }.count
        default:
            if let i = players.index(where: { $0.name == touched }) {
                players[i].marked = true
            }
        }
        
        print(players.filter { $0.marked == true }.count)
        
        // Handle finish case. (e.g we have completed the goalkeeper)
        print("It remains to assign for this category [ " + String(remains) + " ] player")
        if(remains == 0){
            available = true
            
            self.star1.image = UIImage(named:"star")
            self.view.bringSubview(toFront: star1);
            let myNumber = 50
            
            if(myNumber>2){
                self.star2.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star2);
            }
            if(myNumber>7){
                self.star3.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star3);
            }
            if(myNumber>10){
                self.star4.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star4);
            }
            if(myNumber>20){
                self.star5.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star5);
            }
            
            self.randomName.text = "Complimenti"
            self.view.bringSubview(toFront: randomName);
            self.view.bringSubview(toFront: randomQuotation);
            
            self.randomTeam.text = "Hai completato la categoria " + sezione
            self.randomTeam.font = UIFont(name: self.randomTeam.font.fontName, size: 19)
            self.randomQuotation.text = ""
            
            self.assignButton.isEnabled = false
            self.skipButton.isEnabled = false
            
            nextImagePlayer.image = UIImage.init(named: "")
            
            UIView.transition(with: cardImage,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.cardImage.image = UIImage.init(named: "completed")
                                self.cardImage.image = cropToBounds(image: self.cardImage.image!, width: 117, height: 117)
                                self.cardImage.layer.borderWidth = 2.5
                                self.cardImage.layer.masksToBounds = false
                                self.cardImage.layer.borderColor = UIColor.white.cgColor
                                self.cardImage.layer.cornerRadius = self.cardImage.frame.width / 2
                                self.cardImage.clipsToBounds = true
                                
            },
                              completion: nil)
            
            
        }else{
            click("me")
        }
    }
    
    func turnNext(tempPlayer:Player){
        playerName = tempPlayer.name
        
        self.view.bringSubview(toFront: randomName);
        self.view.bringSubview(toFront: randomQuotation);
        self.randomTeam.text = tempPlayer.team
        self.randomQuotation.text = tempPlayer.quotation
        self.randomName.text = tempPlayer.name
        self.role = tempPlayer.role
        self.star1.image = UIImage(named:"star")
        self.view.bringSubview(toFront: star1);
        let myNumber = Int(tempPlayer.quotation)
        
        if(myNumber! > 2){
            self.star2.image = UIImage(named:"star")
            self.view.bringSubview(toFront: star2);
        }
        if(myNumber! > 7){
            self.star3.image = UIImage(named:"star")
            self.view.bringSubview(toFront: star3);
        }
        if(myNumber! > 10){
            self.star4.image = UIImage(named:"star")
            self.view.bringSubview(toFront: star4);
        }
        if(myNumber! > 20){
            self.star5.image = UIImage(named:"star")
            self.view.bringSubview(toFront: star5);
        }
        
        changeCardWithAnimation(giocatore: tempPlayer)
    }
    
    
    @IBAction func click(_ sender: Any) {
        AudioServicesPlaySystemSound(1519)
        available = false
        let tabItems = self.tabBarController?.tabBar.items as NSArray!
        
        // In this case we want to modify the badge number of the third tab:
        let tabItem = tabItems?[1] as! UITabBarItem
        
        // Now set the badge of the third tab
        tabItem.badgeValue = String(randomContent.filter{ $0.marked == true }.count)
        
        self.randomName.fadeTransition(0.2)
        self.randomTeam.fadeTransition(0.2)
        self.randomQuotation.fadeTransition(0.2)
        
        self.star1.image = nil
        self.star2.image = nil
        self.star3.image = nil
        self.star4.image = nil
        self.star5.image = nil
        
        print(remains)
        if(nextPlayer != nil){
            if(remains > 1){
                // I have to put the right player, extract new one for next and set actual as previous
                // Check previous
                if(!lastPlayer!.marked){
                    previousPlayer = lastPlayer
                    changeCardPreviousNextWithAnimation(giocatore: previousPlayer!, choose: "previous")
                }else{
                    previousPlayer = nil
                    lastImagePlayer.image = UIImage.init(named: "")
                }
                let tempPlayer:Player = nextPlayer!
                
                // Save into lastPlayer information
                lastPlayer = nextPlayer
                
                // Extract next
                if(remains > 1){
                    nextPlayer = extractRandomPlayer(actualPlayer: (lastPlayer?.name)!)
                    changeCardPreviousNextWithAnimation(giocatore: nextPlayer!, choose: "next")
                }else{
                    nextPlayer = nil
                    lastImagePlayer.image = UIImage.init(named: "")
                }
                playerName = tempPlayer.name
                
                self.view.bringSubview(toFront: randomName);
                self.view.bringSubview(toFront: randomQuotation);
                self.randomTeam.text = tempPlayer.team
                self.randomQuotation.text = tempPlayer.quotation
                self.randomName.text = tempPlayer.name
                self.role = tempPlayer.role
                
                self.star1.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star1);
                let myNumber = Int(tempPlayer.quotation)
                
                if(myNumber! > 2){
                    self.star2.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star2);
                }
                if(myNumber! > 7){
                    self.star3.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star3);
                }
                if(myNumber! > 10){
                    self.star4.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star4);
                }
                if(myNumber! > 20){
                    self.star5.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star5);
                }
                
                changeCardWithAnimation(giocatore: tempPlayer)
                
            }
            else if(remains == 1){
                // I have to put the right player, next nil and set actual as previous
                // Check previous
                if(!lastPlayer!.marked){
                    previousPlayer = lastPlayer
                    changeCardPreviousNextWithAnimation(giocatore: previousPlayer!, choose: "previous")
                }else{
                    previousPlayer = nil
                    lastImagePlayer.image = UIImage.init(named: "")
                }
                let tempPlayer:Player = nextPlayer!
                
                // Save into lastPlayer information
                lastPlayer = nextPlayer
                
                
                nextPlayer = nil
                lastImagePlayer.image = UIImage.init(named: "")
                
                playerName = tempPlayer.name
                
                self.view.bringSubview(toFront: randomName);
                self.view.bringSubview(toFront: randomQuotation);
                self.randomTeam.text = tempPlayer.team
                self.randomQuotation.text = tempPlayer.quotation
                self.randomName.text = tempPlayer.name
                self.role = tempPlayer.role
                
                self.star1.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star1);
                let myNumber = Int(tempPlayer.quotation)
                
                if(myNumber! > 2){
                    self.star2.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star2);
                }
                if(myNumber! > 7){
                    self.star3.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star3);
                }
                if(myNumber! > 10){
                    self.star4.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star4);
                }
                if(myNumber! > 20){
                    self.star5.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star5);
                }
                
                changeCardWithAnimation(giocatore: tempPlayer)
            }
        }else{
            let rem = randomContent.filter { $0.marked == false }.count
            if(rem != 0){
                // Check previous
                if(lastPlayer != nil){
                    previousPlayer = lastPlayer
                    changeCardPreviousNextWithAnimation(giocatore: previousPlayer!, choose: "previous")
                }
                
                var tempPlayer:Player? = extractRandomPlayer(actualPlayer: "")
                if(lastPlayer !=  nil){
                    tempPlayer = extractRandomPlayer(actualPlayer: lastPlayer!.name)
                }
                
                // Save into lastPlayer information
                lastPlayer = tempPlayer
                
                // Extract next
                if(remains > 1){
                    nextPlayer = extractRandomPlayer(actualPlayer: (lastPlayer?.name)!)
                    changeCardPreviousNextWithAnimation(giocatore: nextPlayer!, choose: "next")
                }else{
                    nextPlayer = nil
                    lastImagePlayer.image = UIImage.init(named: "")
                }
                
                playerName = (tempPlayer?.name)!
                
                
                self.view.bringSubview(toFront: randomName);
                self.view.bringSubview(toFront: randomQuotation);
                self.randomTeam.text = tempPlayer?.team
                self.randomQuotation.text = tempPlayer?.quotation
                self.randomName.text = tempPlayer?.name
                self.role = tempPlayer!.role
                
                self.star1.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star1);
                let myNumber = Int(tempPlayer!.quotation)
                
                if(myNumber! > 2){
                    self.star2.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star2);
                }
                if(myNumber! > 7){
                    self.star3.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star3);
                }
                if(myNumber! > 10){
                    self.star4.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star4);
                }
                if(myNumber! > 20){
                    self.star5.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star5);
                }
                
                changeCardWithAnimation(giocatore: tempPlayer!)
            }else{
                available = true
                
                self.star1.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star1);
                let myNumber = 50
                
                if(myNumber>2){
                    self.star2.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star2);
                }
                if(myNumber>7){
                    self.star3.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star3);
                }
                if(myNumber>10){
                    self.star4.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star4);
                }
                if(myNumber>20){
                    self.star5.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star5);
                }
                
                self.randomName.text = "Complimenti"
                self.view.bringSubview(toFront: randomName);
                self.view.bringSubview(toFront: randomQuotation);
                
                self.randomTeam.text = "Hai completato la categoria " + sezione
                self.randomTeam.font = UIFont(name: self.randomTeam.font.fontName, size: 19)
                self.randomQuotation.text = ""
                
                self.assignButton.isEnabled = false
                self.skipButton.isEnabled = false
            }
        }

        
    }
    
    func appear(){
        var tempRole:String = ""
        navBar.title = navBarTitle
        
        if(randomContent.filter { $0.marked == false }.count > 0){
            self.assignButton.isEnabled = true
            self.skipButton.isEnabled = true
            self.randomTeam.font = UIFont(name: self.randomTeam.font.fontName, size: 34)
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems?[1] as! UITabBarItem
            
            // Now set the badge of the third tab
            tabItem.badgeValue = String(randomContent.filter{ $0.marked == true }.count)
        }
        
        switch picked {
        case "portieri":
            randomContent = portieri
            tempRole = "P"
        case "difensori":
            randomContent = difensori
            tempRole = "D"
        case "centrocampisti":
            randomContent = centrocampisti
            tempRole = "C"
        case "attaccanti":
            randomContent = attaccanti
            tempRole = "A"
        case "tutti":
            randomContent = players
            tempRole = "TUTTI"
        default:
            print("default")
        }
        
        if(firstLoad){
            let rem = randomContent.filter { $0.marked == false }.count
            if(rem == 0){
                available = true
                
                self.star1.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star1);
                let myNumber = 50
                
                if(myNumber>2){
                    self.star2.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star2);
                }
                if(myNumber>7){
                    self.star3.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star3);
                }
                if(myNumber>10){
                    self.star4.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star4);
                }
                if(myNumber>20){
                    self.star5.image = UIImage(named:"star")
                    self.view.bringSubview(toFront: star5);
                }
                
                self.randomName.text = "Complimenti"
                self.view.bringSubview(toFront: randomName);
                self.view.bringSubview(toFront: randomQuotation);
                
                self.randomTeam.text = "Hai completato la categoria " + sezione
                self.randomTeam.font = UIFont(name: self.randomTeam.font.fontName, size: 19)
                self.randomQuotation.text = ""
                
                self.assignButton.isEnabled = false
                self.skipButton.isEnabled = false
                
            }else{
                if(lastPlayer?.role != tempRole){
                    lastPlayer = nil
                    previousPlayer = nil
                    nextPlayer = nil
                    
                    lastImagePlayer.image = UIImage.init(named: "")
                }
                
                if(lastPlayer != nil){
                    if(lastPlayer?.marked == false){
                        // Load this player information
                        playerName = lastPlayer!.name
                        
                        self.view.bringSubview(toFront: randomName);
                        self.view.bringSubview(toFront: randomQuotation);
                        self.randomTeam.text = lastPlayer?.team
                        self.randomQuotation.text = lastPlayer?.quotation
                        self.randomName.text = lastPlayer?.name
                        self.role = lastPlayer!.role
                        
                        self.star1.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star1);
                        let myNumber = Int(lastPlayer!.quotation)
                        
                        if(myNumber! > 2){
                            self.star2.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star2);
                        }
                        if(myNumber! > 7){
                            self.star3.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star3);
                        }
                        if(myNumber! > 10){
                            self.star4.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star4);
                        }
                        if(myNumber! > 20){
                            self.star5.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star5);
                        }
                        
                        changeCardWithAnimation(giocatore: lastPlayer!)
                        
                        // Extract next
                        if(remains > 1){
                            nextPlayer = extractRandomPlayer(actualPlayer: (lastPlayer?.name)!)
                            changeCardPreviousNextWithAnimation(giocatore: nextPlayer!, choose: "next")
                        }else{
                            nextPlayer = nil
                            lastImagePlayer.image = UIImage.init(named: "")
                        }
                        
                    }else{
                        // Load new one
                        click("c")
                    }
                }else{
                    click("c")
                }
            }
            
        }else{
            firstLoad=true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear()
    }
    
    func changeCardWithAnimation(giocatore:Player){
        UIView.transition(with: cardImage,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.cardImage.image = giocatore.image
                            self.cardImage.image = cropToBounds(image: self.cardImage.image!, width: 117, height: 117)
                            self.cardImage.layer.borderWidth = 2.5
                            self.cardImage.layer.masksToBounds = false
                            self.cardImage.layer.borderColor = UIColor.white.cgColor
                            self.cardImage.layer.cornerRadius = self.cardImage.frame.width / 2
                            self.cardImage.clipsToBounds = true
                            
        },
                          completion: nil)
    }
    
    func changeCardPreviousNextWithAnimation(giocatore:Player,choose:String){
        if(choose == "next"){
            UIView.transition(with: nextImagePlayer,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.nextImagePlayer.image = giocatore.image
                                self.nextImagePlayer.image = cropToBounds(image: self.nextImagePlayer.image!, width: 117, height: 117)
                                self.nextImagePlayer.layer.borderWidth = 2.5
                                self.nextImagePlayer.layer.masksToBounds = false
                                self.nextImagePlayer.layer.borderColor = UIColor.white.cgColor
                                self.nextImagePlayer.layer.cornerRadius = self.nextImagePlayer.frame.width / 2
                                self.nextImagePlayer.clipsToBounds = true
            },
                              completion: nil)
        }else{
            UIView.transition(with: lastImagePlayer,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.lastImagePlayer.image = giocatore.image
                                self.lastImagePlayer.image = cropToBounds(image: self.lastImagePlayer.image!, width: 117, height: 117)
                                self.lastImagePlayer.layer.borderWidth = 2.5
                                self.lastImagePlayer.layer.masksToBounds = false
                                self.lastImagePlayer.layer.borderColor = UIColor.white.cgColor
                                self.lastImagePlayer.layer.cornerRadius = self.lastImagePlayer.frame.width / 2
                                self.lastImagePlayer.clipsToBounds = true
            },
                              completion: nil)
        }
    }
    
    
    func extractRandomPlayer(actualPlayer:String)->Player{
        let playerstemp:[Player] = randomContent
        let randomIndex = Int(arc4random_uniform(UInt32(playerstemp.count)))
        var tempPlayer:Player = playerstemp[randomIndex]
        
        
        print("I'm checking that " + tempPlayer.name + " is in the list : " + extracted.joined(separator: ", "))
        if(tempPlayer.marked == false && !extracted.contains(tempPlayer.name) && (actualPlayer != tempPlayer.name)){
            return tempPlayer;
        }else{
            print("Is in the list! skip to someone else...")
            return extractRandomPlayer(actualPlayer: actualPlayer)
        }
    }
}

func calculateScreenSize()->Double{
    let screenSize = UIScreen.main.bounds
    let screenWidth:String = String.init(describing: screenSize.width)
    let screenHeight:String = String.init(describing: screenSize.height)
    
    print("Width : " + screenWidth)
    print("Height : " + screenHeight)
    
    return Double(screenSize.width)
}

func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
    
    let contextImage: UIImage = UIImage.init(cgImage: image.cgImage!)
    
    let contextSize: CGSize = contextImage.size
    
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
}



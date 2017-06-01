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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var assignButton: UIButton!

    @IBOutlet weak var skipButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var cardImage: UIImageView!
    
    // star
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var wallpaperView: UIImageView!
    
    var first: Homepage = Homepage(nibName: nil, bundle: nil)
    var role: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubview(toBack: image)
        self.view.sendSubview(toBack: wallpaperView)
        self.view.bringSubview(toFront: cardImage);
        navBar.title = navBarTitle
        
        click("c")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func assignEvent(_ sender: Any) {
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

        }else{
            click("me")
         }
    }
    
    
    @IBAction func click(_ sender: Any) {
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
        
        let tempPlayer:Player = extractRandomPlayer()
        
        // Save into lastPlayer information
        lastPlayer = tempPlayer
        
        playerName = tempPlayer.name
        
        // round and test
        //      self.cardImage.image = UIImage(named: "test_avatar")
        self.cardImage.image = UIImage(named: "no_avatar")
        self.cardImage.image = cropToBounds(image: self.cardImage.image!, width: 117, height: 117)
        self.cardImage.layer.borderWidth = 2.5
        self.cardImage.layer.masksToBounds = false
        self.cardImage.layer.borderColor = UIColor.white.cgColor
        self.cardImage.layer.cornerRadius = self.cardImage.frame.width / 2
        self.cardImage.clipsToBounds = true
        // END round and test
        
            self.view.bringSubview(toFront: randomName);
            self.view.bringSubview(toFront: randomQuotation);
            self.randomTeam.text = tempPlayer.team
            self.randomQuotation.text = tempPlayer.quotation
            self.randomName.text = tempPlayer.name
            self.role = tempPlayer.role
            
            switch tempPlayer.team {
            case "Atalanta":
                //image.image = UIImage(named:"Atalanta")
                changeImageWithAnimation(squadra: "Atalanta")
            case "Cagliari":
                //image.image = UIImage(named:"Cagliari")
                changeImageWithAnimation(squadra: "Cagliari")
            case "Chievo":
                //image.image = UIImage(named:"Chievo")
                changeImageWithAnimation(squadra: "Chievo")
            case "Crotone":
               // image.image = UIImage(named:"Crotone")
                changeImageWithAnimation(squadra: "Crotone")
            case "Empoli":
               // image.image = UIImage(named:"Empoli")
                changeImageWithAnimation(squadra: "Empoli")
            case "Fiorentina":
               // image.image = UIImage(named:"Fiorentina")
                changeImageWithAnimation(squadra: "Fiorentina")
            case "Genoa":
               // image.image = UIImage(named:"Genoa")
                changeImageWithAnimation(squadra: "Genoa")
            case "Inter":
               // image.image = UIImage(named:"Inter")
                changeImageWithAnimation(squadra: "Inter")
            case "Juventus":
               // image.image = UIImage(named:"Juventus")
                changeImageWithAnimation(squadra: "Juventus")
            case "Lazio":
                //image.image = UIImage(named:"Lazio")
                changeImageWithAnimation(squadra: "Lazio")
            case "Milan":
               // image.image = UIImage(named:"Milan")
                changeImageWithAnimation(squadra: "Milan")
            case "Napoli":
               // image.image = UIImage(named:"Napoli")
                changeImageWithAnimation(squadra: "Napoli")
            case "Palermo":
               // image.image = UIImage(named:"Palermo")
                changeImageWithAnimation(squadra: "Palermo")
            case "Roma":
              //  image.image = UIImage(named:"Roma")
                changeImageWithAnimation(squadra: "Roma")
            case "Sampdoria":
                //image.image = UIImage(named:"Sampdoria")
                changeImageWithAnimation(squadra: "Sampdoria")
            case "Sassuolo":
               // image.image = UIImage(named:"Sassuolo")
                changeImageWithAnimation(squadra: "Sassuolo")
            case "Torino":
               // image.image = UIImage(named:"Torino")
                changeImageWithAnimation(squadra: "Torino")
            case "Udinese":
               // image.image = UIImage(named:"Udinese")
                changeImageWithAnimation(squadra: "Udinese")
            default:
               // image.image = UIImage(named: "no_image")
                changeImageWithAnimation(squadra: "no_image")
            }
            
            self.star1.image = UIImage(named:"star")
            self.view.bringSubview(toFront: star1);
            let myNumber = Int(tempPlayer.quotation)
            
            if(myNumber!>2){
                self.star2.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star2);
            }
            if(myNumber!>7){
                self.star3.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star3);
            }
            if(myNumber!>10){
                self.star4.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star4);
            }
            if(myNumber!>20){
                self.star5.image = UIImage(named:"star")
                self.view.bringSubview(toFront: star5);
            }
       
        changeCardWithAnimation(giocatore: tempPlayer)
    }
    
    func appear(){
        var tempRole:String = ""
        navBar.title = navBarTitle
        
        if(randomContent.filter { $0.marked == false }.count > 0){
            self.assignButton.isEnabled = true
            self.skipButton.isEnabled = true
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
                }
                
                if(lastPlayer != nil){
                    if(lastPlayer?.marked == false){
                        // Load this player information
                        playerName = lastPlayer!.name
                        
                        // round and test
                        //      self.cardImage.image = UIImage(named: "test_avatar")
                        self.cardImage.image = UIImage(named: "no_avatar")
                        self.cardImage.image = cropToBounds(image: self.cardImage.image!, width: 117, height: 117)
                        self.cardImage.layer.borderWidth = 2.5
                        self.cardImage.layer.masksToBounds = false
                        self.cardImage.layer.borderColor = UIColor.white.cgColor
                        self.cardImage.layer.cornerRadius = self.cardImage.frame.width / 2
                        self.cardImage.clipsToBounds = true
                        // END round and test
                        
                        self.view.bringSubview(toFront: randomName);
                        self.view.bringSubview(toFront: randomQuotation);
                        self.randomTeam.text = lastPlayer?.team
                        self.randomQuotation.text = lastPlayer?.quotation
                        self.randomName.text = lastPlayer?.name
                        self.role = lastPlayer!.role
                        
                        switch lastPlayer!.team {
                        case "Atalanta":
                            //image.image = UIImage(named:"Atalanta")
                            changeImageWithAnimation(squadra: "Atalanta")
                        case "Cagliari":
                            //image.image = UIImage(named:"Cagliari")
                            changeImageWithAnimation(squadra: "Cagliari")
                        case "Chievo":
                            //image.image = UIImage(named:"Chievo")
                            changeImageWithAnimation(squadra: "Chievo")
                        case "Crotone":
                            // image.image = UIImage(named:"Crotone")
                            changeImageWithAnimation(squadra: "Crotone")
                        case "Empoli":
                            // image.image = UIImage(named:"Empoli")
                            changeImageWithAnimation(squadra: "Empoli")
                        case "Fiorentina":
                            // image.image = UIImage(named:"Fiorentina")
                            changeImageWithAnimation(squadra: "Fiorentina")
                        case "Genoa":
                            // image.image = UIImage(named:"Genoa")
                            changeImageWithAnimation(squadra: "Genoa")
                        case "Inter":
                            // image.image = UIImage(named:"Inter")
                            changeImageWithAnimation(squadra: "Inter")
                        case "Juventus":
                            // image.image = UIImage(named:"Juventus")
                            changeImageWithAnimation(squadra: "Juventus")
                        case "Lazio":
                            //image.image = UIImage(named:"Lazio")
                            changeImageWithAnimation(squadra: "Lazio")
                        case "Milan":
                            // image.image = UIImage(named:"Milan")
                            changeImageWithAnimation(squadra: "Milan")
                        case "Napoli":
                            // image.image = UIImage(named:"Napoli")
                            changeImageWithAnimation(squadra: "Napoli")
                        case "Palermo":
                            // image.image = UIImage(named:"Palermo")
                            changeImageWithAnimation(squadra: "Palermo")
                        case "Roma":
                            //  image.image = UIImage(named:"Roma")
                            changeImageWithAnimation(squadra: "Roma")
                        case "Sampdoria":
                            //image.image = UIImage(named:"Sampdoria")
                            changeImageWithAnimation(squadra: "Sampdoria")
                        case "Sassuolo":
                            // image.image = UIImage(named:"Sassuolo")
                            changeImageWithAnimation(squadra: "Sassuolo")
                        case "Torino":
                            // image.image = UIImage(named:"Torino")
                            changeImageWithAnimation(squadra: "Torino")
                        case "Udinese":
                            // image.image = UIImage(named:"Udinese")
                            changeImageWithAnimation(squadra: "Udinese")
                        default:
                            // image.image = UIImage(named: "no_image")
                            changeImageWithAnimation(squadra: "no_image")
                        }
                        
                        self.star1.image = UIImage(named:"star")
                        self.view.bringSubview(toFront: star1);
                        let myNumber = Int(lastPlayer!.quotation)
                        
                        if(myNumber!>2){
                            self.star2.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star2);
                        }
                        if(myNumber!>7){
                            self.star3.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star3);
                        }
                        if(myNumber!>10){
                            self.star4.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star4);
                        }
                        if(myNumber!>20){
                            self.star5.image = UIImage(named:"star")
                            self.view.bringSubview(toFront: star5);
                        }
                        
                        changeCardWithAnimation(giocatore: lastPlayer!)
                        
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
    
    func changeImageWithAnimation(squadra:String){
        UIView.transition(with: image,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.image.image = UIImage(named:squadra) },
                          completion: nil)
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
                            self.cardImage.clipsToBounds = true},
                          completion: nil)
    }
    
    func extractRandomPlayer()->Player{
        let playerstemp:[Player] = randomContent
        let randomIndex = Int(arc4random_uniform(UInt32(playerstemp.count)))
        let tempPlayer:Player = playerstemp[randomIndex]
        
        
        print("I'm checking that " + tempPlayer.name + " is in the list : " + extracted.joined(separator: ", "))
        if(tempPlayer.marked == false && !extracted.contains(tempPlayer.name)){
            return tempPlayer;
        }else{
            print("Is in the list! skip to someone else...")
            return extractRandomPlayer()
        }
    }
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



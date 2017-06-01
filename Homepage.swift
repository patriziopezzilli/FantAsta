//
//  FirstViewController.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 04/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Foundation
import SystemConfiguration
import MessageUI

var players:[Player] = []
var portieri:[Player] = []
var difensori:[Player] = []
var centrocampisti:[Player] = []
var attaccanti:[Player] = []
var randomContent:[Player] = []

var portieriCount:Int = 0;
var difensoriCount:Int = 0;
var centrocampistiCount:Int = 0;
var attaccantiCount:Int = 0;

var dateDataLoad:String = ""

extension Date {
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}

class Homepage: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var loadDataButton: UIButton!
    
    let pickerDataSource = ["Portieri", "Difensori", "Centrocampisti", "Attaccanti"];
    
    var dates:[String] = []
    var adBannerView: GADBannerView?
    var interstitial: GADInterstitial?
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var loadDatiButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var resetDatiButton: UIButton!
    @IBOutlet weak var fgButton: UIButton!
    @IBOutlet weak var signalButton: UIButton!
    @IBOutlet weak var wallpaperImage: UIImageView!
    
    @IBOutlet weak var labelUpdate: UILabel!
    
    let mockImage = UIImage(named: "no_avatar")
    
    @IBAction func loadData(_ sender: Any) {
        print("Loading data..")
        
        // Load data section (now offline, next online)
        var myCSVContents = Array<Dictionary<String, String>>()
        
        /*   Initialize goalkeeper    */
        
        CSVScanner.runFunctionOnRowsFromFile(data: "default", theColumnNames: ["title", "body", "category"], withFileName: "portieri", withFunction: {
            
            (aRow:Dictionary<String, String>) in
            
            myCSVContents.append(aRow)
            
        })
        
        for entry in myCSVContents {
            // parse string from role and getting values.
            let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
            let goalKeeperTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: mockImage!)
            portieri.append(goalKeeperTemp)
            portieriCount += 1
        }
        portieri.sort { $0.name < $1.name }
        
        var myCSVContents_2 = Array<Dictionary<String, String>>()
        
        /*   Initialize defenders    */
        CSVScanner.runFunctionOnRowsFromFile(data: "default", theColumnNames: ["title", "body", "category"], withFileName: "difensori", withFunction: {
            
            (aRow:Dictionary<String, String>) in
            
            myCSVContents_2.append(aRow)
            
        })
        
        for entry in myCSVContents_2 {
            // parse string from role and getting values.
            let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
            let defenderTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: mockImage!)
            difensori.append(defenderTemp)
            difensoriCount += 1
        }
        difensori.sort { $0.name < $1.name }
        var myCSVContents_3 = Array<Dictionary<String, String>>()
        
        /*   Initialize middlefielders    */
        CSVScanner.runFunctionOnRowsFromFile(data: "default", theColumnNames: ["title", "body", "category"], withFileName: "centrocampisti", withFunction: {
            
            (aRow:Dictionary<String, String>) in
            
            myCSVContents_3.append(aRow)
            
        })
        
        for entry in myCSVContents_3 {
            // parse string from role and getting values.
            let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
            let middlefielderTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: mockImage!)
            centrocampisti.append(middlefielderTemp)
            centrocampistiCount += 1
        }
        centrocampisti.sort { $0.name < $1.name }
        var myCSVContents_4 = Array<Dictionary<String, String>>()
        
        /*   Initialize striker    */
        CSVScanner.runFunctionOnRowsFromFile(data: "default", theColumnNames: ["title", "body", "category"], withFileName: "attaccanti", withFunction: {
            
            (aRow:Dictionary<String, String>) in
            
            myCSVContents_4.append(aRow)
            
        })
        
        for entry in myCSVContents_4 {
            // parse string from role and getting values.
            let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
            let attTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: mockImage!)
            attaccanti.append(attTemp)
            attaccantiCount += 1
        }
        attaccanti.sort { $0.name < $1.name }
        
        players.append(contentsOf: portieri)
        players.append(contentsOf: difensori)
        players.append(contentsOf: centrocampisti)
        players.append(contentsOf: attaccanti)
        
        
        // enable second and third tab until click on button
        let tabItems = self.tabBarController?.tabBar.items as NSArray!
        let generatore = tabItems?[1] as! UITabBarItem
        let listaQuot = tabItems?[2] as! UITabBarItem
        
        if(portieri.count > 0){
            
            // Download player images
            print("Starting downloading player images..")
            downloadPlayerImageOnStartUp()
            
            self.fgButton.imageView?.image = UIImage(named: "fgPaper-loaded")
            
            randomContent = portieri
            reloadBadge()
            
            generatore.isEnabled = true
            listaQuot.isEnabled = true
            
            // Disable button
            self.loadDataButton.isEnabled = false
            self.loadDataButton.setTitle("Dati caricati", for: .normal)
            self.loadDataButton.backgroundColor = UIColor(red:0.0,green:128/255.0,blue:0.0,alpha:1.0)
            self.resetDatiButton.isEnabled = true
            
            // Override main slate image
          //  changeImageWithAnimation(imagename: "lavagna_success")
            self.view.sendSubview(toBack: fgButton)
            self.view.bringSubview(toFront: adBannerView!)
            
            
            self.view.sendSubview(toBack: wallpaperImage)
            // Date today
            let date:Date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            dateDataLoad = formatter.string(from: date)
        
            print("Data loaded on: " + dateDataLoad)
            labelUpdate.text = "Quotazioni aggiornate al " + dateDataLoad
          //  dateDataLoad = "10-03-2017"
            enrichDatesToCheck(previousDate: dateDataLoad)
            let update:String = checkIfUpdateIsAvailable()
            print(update)
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.signalButton.
        self.resetDatiButton.isEnabled = false
        self.resetDatiButton.layer.cornerRadius = 16
        self.loadDataButton.layer.cornerRadius = 16
        
        // check is about true
        if isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
            let refreshAlert = UIAlertController(title: "Connessione internet non disponibile", message: "Quest'applicazione necessita di una connessione dati. Perfavore controlla e riprova.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Impostazioni rete dati", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }))
            
            let refreshAction = UIAlertAction(title: "Riprova", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                if isConnectedToNetwork() == true
                {
                    print("Riprova OK")
                }else{
                    DispatchQueue.main.async {
                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                }
            }
            
            refreshAlert.addAction(refreshAction)
            
            DispatchQueue.main.async {
                self.present(refreshAlert, animated: true, completion: nil)
            }

        }
        
        interstitial = createAndLoadInterstitial()
        print(portieri)
        
        // Load banner
        adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView?.adUnitID = "ca-app-pub-0789574217127140/6699778913"
        adBannerView?.delegate = self
        adBannerView?.rootViewController = self
        adBannerView?.load(GADRequest())
        adBannerView?.frame = self.bannerView.frame;
        
        if(portieri.count > 0){
            
            // Download player images
            print("Starting downloading player images..")
            downloadPlayerImageOnStartUp()
            randomContent = portieri
            print(randomContent)
            
            self.fgButton.imageView?.image = UIImage(named: "fgPaper-loaded")
            
            // Disable button
            self.resetDatiButton.isEnabled = true
            self.loadDataButton.isEnabled = false
            self.fgButton.isEnabled = false
            self.loadDataButton.setTitle("Dati caricati", for: .normal)
            self.loadDataButton.backgroundColor = UIColor(red:0.0,green:128/255.0,blue:0.0,alpha:1.0)
            
            // Override main slate image
           // changeImageWithAnimation(imagename: "lavagna_success")
            self.view.sendSubview(toBack: fgButton)
            self.view.bringSubview(toFront: adBannerView!)
            self.view.sendSubview(toBack: wallpaperImage)
            
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems?[1] as! UITabBarItem
            
            // Now set the badge of the third tab
            tabItem.badgeValue = String(randomContent.filter{ $0.marked == true }.count)
            
            self.labelUpdate.text = "Quotazioni aggiornate al " + dateDataLoad
            // TODO : HERE YOU HAVE TO CHECK UPDATE!!!
            enrichDatesToCheck(previousDate: dateDataLoad)
            let update:String = checkIfUpdateIsAvailable()
            
            if(update != ""){
                
                let alert = UIAlertController(title: "E' disponibile un aggiornamento!", message: "L'aggiornameno fa riferimento al " + update, preferredStyle: UIAlertControllerStyle.alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Aggiorna", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    // reset all data
                    portieri = []
                    difensori = []
                    centrocampisti = []
                    attaccanti = []
                    players = []
                    
                    print("Loading data..")
                    // Load data section (now offline, next online)
                    var myCSVContents = Array<Dictionary<String, String>>()
                    
                    /*   Initialize goalkeeper    */
                    
                    CSVScanner.runFunctionOnRowsFromFile(data: update, theColumnNames: ["title", "body", "category"], withFileName: "portieri", withFunction: {
                        
                        (aRow:Dictionary<String, String>) in
                        
                        myCSVContents.append(aRow)
                        
                    })
                    
                    for entry in myCSVContents {
                        // parse string from role and getting values.
                        let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
                        let goalKeeperTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: self.mockImage!)
                        portieri.append(goalKeeperTemp)
                        portieriCount += 1
                    }
                    portieri.sort { $0.name < $1.name }
                    
                    var myCSVContents_2 = Array<Dictionary<String, String>>()
                    
                    /*   Initialize defenders    */
                    CSVScanner.runFunctionOnRowsFromFile(data: update, theColumnNames: ["title", "body", "category"], withFileName: "difensori", withFunction: {
                        
                        (aRow:Dictionary<String, String>) in
                        
                        myCSVContents_2.append(aRow)
                        
                    })
                    
                    for entry in myCSVContents_2 {
                        // parse string from role and getting values.
                        let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
                        let defenderTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: self.mockImage!)
                        difensori.append(defenderTemp)
                        difensoriCount += 1
                    }
                    difensori.sort { $0.name < $1.name }
                    var myCSVContents_3 = Array<Dictionary<String, String>>()
                    
                    /*   Initialize middlefielders    */
                    CSVScanner.runFunctionOnRowsFromFile(data: update, theColumnNames: ["title", "body", "category"], withFileName: "centrocampisti", withFunction: {
                        
                        (aRow:Dictionary<String, String>) in
                        
                        myCSVContents_3.append(aRow)
                        
                    })
                    
                    for entry in myCSVContents_3 {
                        // parse string from role and getting values.
                        let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
                        let middlefielderTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: self.mockImage!)
                        centrocampisti.append(middlefielderTemp)
                        centrocampistiCount += 1
                    }
                    centrocampisti.sort { $0.name < $1.name }
                    var myCSVContents_4 = Array<Dictionary<String, String>>()
                    
                    /*   Initialize striker    */
                    CSVScanner.runFunctionOnRowsFromFile(data: update, theColumnNames: ["title", "body", "category"], withFileName: "attaccanti", withFunction: {
                        
                        (aRow:Dictionary<String, String>) in
                        
                        myCSVContents_4.append(aRow)
                        
                    })
                    
                    for entry in myCSVContents_4 {
                        // parse string from role and getting values.
                        let playerVariables = entry["title"]!.characters.split{$0 == ";"}.map(String.init)
                        let attTemp = Player(name: playerVariables[2],team: playerVariables[3],quotation:playerVariables[4],role:playerVariables[1], marked: false, img: self.mockImage!)
                        attaccanti.append(attTemp)
                        attaccantiCount += 1
                    }
                    attaccanti.sort { $0.name < $1.name }
                    
                    players.append(contentsOf: portieri)
                    players.append(contentsOf: difensori)
                    players.append(contentsOf: centrocampisti)
                    players.append(contentsOf: attaccanti)
                    
                    self.labelUpdate.text = "Quotazioni aggiornate al " + update
                    
                    // self.view.sendSubview(toBack: self.lavagnaOkimage)
                    //   self.changeImageWithAnimation(imagename: "")
                    
                    // Download player images
                    print("Starting downloading player images..")
                    self.downloadPlayerImageOnStartUp()
                    randomContent = portieri
                    print(randomContent)
                }
                let cancelAction = UIAlertAction(title: "Annulla", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }

                
            }
        }else{
            // Disable second and third tab until click on button
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let generatore = tabItems?[1] as! UITabBarItem
            let listaQuot = tabItems?[2] as! UITabBarItem
            generatore.isEnabled = false
            listaQuot.isEnabled = false
        }
        
        // Disable button
        self.loadDataButton.isEnabled = false
        
        self.view.bringSubview(toFront: adBannerView!)
        self.view.sendSubview(toBack: wallpaperImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        print("Banner loaded successfully")
        self.bannerView.addSubview(adBannerView!)
        
    }
    
    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("Fail to receive ads")
        print(error)
    }
    
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-0789574217127140/1562425314")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial!) {
        print("Fail to receive interstitial")
    }
 
    @IBAction func fgClicked(_ sender: Any) {
        // Disable button
        self.loadDataButton.isEnabled = true
       self.fgButton.isEnabled = false
        
    }
    
    @IBAction func resetData(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sei sicuro di voler eliminare tutti i dati?", message: "Perderai tutte le quotazioni e gli assegnamenti effettuati fino ad ora.", preferredStyle: UIAlertControllerStyle.alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Si, sono sicuro", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            self.labelUpdate.text = ""
            
            // reset all data
            portieri = []
            difensori = []
            centrocampisti = []
            attaccanti = []
            extracted = []
            lastPlayer = nil
            
            
            self.fgButton.imageView?.image = UIImage(named: "fgPaper")
            
            // Reload badge again
            self.reloadBadge()
            
            // Disable second and third tab until click on button
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let generatore = tabItems?[1] as! UITabBarItem
            let listaQuot = tabItems?[2] as! UITabBarItem
            generatore.isEnabled = false
            listaQuot.isEnabled = false
            
            self.resetDatiButton.isEnabled = false
            self.fgButton.isEnabled = true
            
            self.loadDataButton.setTitle("Carica dati", for: .normal)
            self.loadDataButton.backgroundColor = UIColor.gray
            
           // self.view.sendSubview(toBack: self.lavagnaOkimage)
         //   self.changeImageWithAnimation(imagename: "")
            
        }
        let cancelAction = UIAlertAction(title: "No, annulla", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            }
    }
    
    
    // TODO: see better this point
    @IBAction func sendBug(_ sender: Any) {
        print("sending mail...")
        
        let url = URL(string: "mailto:patriziopezzilli@gmail.com?subject=Segnalazione%20FantAsta&body=Il%20problema%20riscontrato%20è%20stato:")
        //UIApplication.shared.open(url!)
         sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["patriziopezzilli@gmail.com"])
            mail.setSubject("Segnalazione FantAsta")
            mail.setMessageBody("<p>Il problema riscontrato è il seguente: </p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func enrichDatesToCheck(previousDate:String){
        // Date today
        let date:Date = Date()
        
        // Build formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        // Build previous date
        var dateBefore:Date = formatter.date(from: previousDate)!
        
        repeat {
            dateBefore = dateBefore.tomorrow!
            dates.append(formatter.string(from: dateBefore))
        } while (dateBefore < date)
        
        print(dates)
    }
    
    func checkIfUpdateIsAvailable() -> String {
        let encodingError:NSError? = nil
        var encoding:String.Encoding = String.Encoding.utf8
        
        var newdate:String = ""
        for string in dates {
            let url = NSURL(string: "http://fantastadata.altervista.org/"+string+"/portieri.csv")
            let fileObject = try? String(contentsOf:url as! URL, usedEncoding:&encoding)
            if(fileObject != nil){
                newdate = string
            }
        }
        print("Update avaiable ON: " + newdate)
        if(newdate != ""){return newdate}
    
        return ""
    }

    func checkDataAvaiable() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let last:Date = formatter.date(from: dateDataLoad)!
        let today:Date = Date()
        
        if(last != today){
            repeat {
                // your logic
            } while last<today
        }
        
        return false
    }
    
    func reloadBadge(){
        let tabItems = self.tabBarController?.tabBar.items as NSArray!
        
        // In this case we want to modify the badge number of the third tab:
        let tabItem = tabItems?[1] as! UITabBarItem
        
        // Now set the badge of the third tab
        tabItem.badgeValue = String(randomContent.filter{ $0.marked == true }.count)
    }
    
    func downloadPlayerImageOnStartUp(){
        DispatchQueue.global().async{
        
            let alert = UIAlertController(title: nil, message: "Caricamento dati", preferredStyle: .alert)
        
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            
            self.present(alert, animated: true, completion: nil)
            
        // Portieri
        for portiere in portieri {
            self.setImageToThePlayer(player: portiere, alert: alert)
        }
        
            // Difensori
        for difensore in difensori {
            self.setImageToThePlayer(player: difensore, alert: alert)
        }
        
            // Centrocampisti
        for centrocampista in centrocampisti {
            self.setImageToThePlayer(player: centrocampista, alert: alert)
        }
        
            // Attaccanti
        for attaccante in attaccanti {
            self.setImageToThePlayer(player: attaccante, alert: alert)
        }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setImageToThePlayer(player:Player, alert:UIAlertController){
        if(((UIImage(named: player.name.replacingOccurrences(of: " ", with: "-")))) != nil){
            let imagePlayer:UIImage = UIImage(named: player.name.replacingOccurrences(of: " ", with: "-"))!
            print(player.name + " has image")
            player.setImage(toSet: imagePlayer)
        }
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    /* Only Working for WIFI
     let isReachable = flags == .reachable
     let needsConnection = flags == .connectionRequired
     
     return isReachable && !needsConnection
     */
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

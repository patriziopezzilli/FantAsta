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
import AudioToolbox

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
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var loadDatiButton: UIButton!
    
    @IBOutlet weak var fgButton: UIButton!
    @IBOutlet weak var signalButton: UIButton!
    @IBOutlet weak var wallpaperImage: UIImageView!
    
    let mockImage = UIImage(named: "no_avatar")
    
    @IBAction func loadData(_ sender: Any) {
        AudioServicesPlaySystemSound(1519)
        if(loadDataButton.currentImage == UIImage.init(named: "carica_dati")){
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
                loadDataButton.setImage(UIImage.init(named: "reset_dati"),for:.normal)
                
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
                navBarTitle.title = dateDataLoad
                //  dateDataLoad = "10-03-2017"
                enrichDatesToCheck(previousDate: dateDataLoad)
                let update:String = checkIfUpdateIsAvailable()
                print(update)
                
                markDataLoaded()
            }
        }else if(loadDataButton.currentImage == UIImage.init(named: "reset_dati")){
            let alert = UIAlertController(title: "Sei sicuro di voler eliminare tutti i dati?", message: "Perderai tutte le quotazioni e gli assegnamenti effettuati fino ad ora.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Si, sono sicuro", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                
                self.navBarTitle.title = "FantAsta"
                
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
                
                self.loadDataButton.setImage(UIImage.init(named: "carica_dati"),for:.normal)
                self.loadDataButton.isEnabled = false
                self.fgButton.isEnabled = true
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
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mark visited app
        appOpened()
        
        if(calculateScreenSize() < 325.0){
            self.bannerView.isHidden = true
            self.view.bringSubview(toFront: fgButton!)
        }
        
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
            self.loadDataButton.imageView?.image = UIImage.init(named: "reset_dati")
            
            // Override main slate image
           // changeImageWithAnimation(imagename: "lavagna_success")
            self.view.sendSubview(toBack: fgButton)
            self.view.bringSubview(toFront: adBannerView!)
            self.view.sendSubview(toBack: wallpaperImage)
            
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems?[1] as! UITabBarItem
            
            // Now set the badge of the third tab
            tabItem.badgeValue = String(randomContent.filter{ $0.marked == true }.count)
            
            navBarTitle.title = dateDataLoad
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
                    
                    self.navBarTitle.title = update
                    
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
        do{
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
        } catch {
            print("error getting xml string")
        }
    }
    
    func setImageToThePlayer(player:Player, alert:UIAlertController){
        if(((UIImage(named: player.name.replacingOccurrences(of: " ", with: "-")))) != nil){
            let imagePlayer:UIImage = UIImage(named: player.name.replacingOccurrences(of: " ", with: "-"))!
            print(player.name + " has image")
            player.setImage(toSet: imagePlayer)
        }else{
            let imagePlayer:UIImage = UIImage(named: "no_avatar")!
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

func appOpened() {
    
    let url: URL = URL(string: "http://fantastadata.altervista.org/script/visitatori_service.php")!
    let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    
    let task = defaultSession.dataTask(with: url) { (data, response, error) in
        
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
        }
        
    }
    
    task.resume()
}

func markDataLoaded() {
    
    let url: URL = URL(string: "http://fantastadata.altervista.org/script/visitatori_utilizzatori_service.php")!
    let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    
    let task = defaultSession.dataTask(with: url) { (data, response, error) in
        
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
        }
        
    }
    
    task.resume()
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

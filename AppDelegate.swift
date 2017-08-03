//
//  AppDelegate.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 04/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//



// FantAsta 2.0

import UIKit

let kUserDefault = UserDefaults.standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if (isKeyPresentInUserDefaults(key: "portieri") && isKeyPresentInUserDefaults(key: "difensori") && isKeyPresentInUserDefaults(key: "centrocampisti")
            && isKeyPresentInUserDefaults(key: "attaccanti") && isKeyPresentInUserDefaults(key: "dataSettings")){
            
            print("Data are present..")
            // first initilize
            portieri.removeAll()
            difensori.removeAll()
            centrocampisti.removeAll()
            attaccanti.removeAll()
            
            // Retrieve data
            portieri = retrieveItems(name: "portieri")
            difensori = retrieveItems(name: "difensori")
            centrocampisti = retrieveItems(name: "centrocampisti")
            attaccanti = retrieveItems(name: "attaccanti")
            
            // Retrieve settings
            dataNeedToPersist = (kUserDefault.object(forKey: "dataSettings") as? Bool)!
            dateDataLoad = (kUserDefault.object(forKey: "data") as? String)!
        }else{
            print("Data are not present..")
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "Homepage") as! Homepage
        self.window?.rootViewController = secondVC
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if(dataNeedToPersist){
            print("Saving data...")
            
            if (isKeyPresentInUserDefaults(key: "portieri") && isKeyPresentInUserDefaults(key: "difensori") && isKeyPresentInUserDefaults(key: "centrocampisti")
                && isKeyPresentInUserDefaults(key: "attaccanti") && isKeyPresentInUserDefaults(key: "data")){
                
                kUserDefault.removeObject(forKey:"portieri")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"difensori")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"centrocampisti")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"attaccanti")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"dataSettings")
                kUserDefault.synchronize()
            }
            
            insertItems(name: "portieri", lista: portieri)
            
            insertItems(name: "difensori", lista: difensori)
            
            insertItems(name: "centrocampisti", lista: centrocampisti)
            
            insertItems(name: "attaccanti", lista: attaccanti)
            
            kUserDefault.set(dataNeedToPersist, forKey: "dataSettings")
            
            kUserDefault.set(dateDataLoad, forKey: "data")
            
            kUserDefault.synchronize()
        }else{
            kUserDefault.removeObject(forKey:"portieri")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"difensori")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"centrocampisti")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"attaccanti")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"dataSettings")
            kUserDefault.synchronize()
            
            kUserDefault.set(dataNeedToPersist, forKey: "dataSettings")
            
            kUserDefault.set(dateDataLoad, forKey: "data")
            
            kUserDefault.synchronize()
        }

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
                    print("Internet Connection Available!")
                }else{
                    DispatchQueue.main.async {
                        self.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
                    }
                }
            }
            
            refreshAlert.addAction(refreshAction)
            
            
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
            }
            
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if(dataNeedToPersist){
            print("Saving data...")
            
            if (isKeyPresentInUserDefaults(key: "portieri") && isKeyPresentInUserDefaults(key: "difensori") && isKeyPresentInUserDefaults(key: "centrocampisti")
                && isKeyPresentInUserDefaults(key: "attaccanti") && isKeyPresentInUserDefaults(key: "data")){
                
                kUserDefault.removeObject(forKey:"portieri")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"difensori")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"centrocampisti")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"attaccanti")
                kUserDefault.synchronize()
                
                kUserDefault.removeObject(forKey:"dataSettings")
                kUserDefault.synchronize()
            }
            
            insertItems(name: "portieri", lista: portieri)
            
            insertItems(name: "difensori", lista: difensori)
            
            insertItems(name: "centrocampisti", lista: centrocampisti)
            
            insertItems(name: "attaccanti", lista: attaccanti)
            
            kUserDefault.set(dataNeedToPersist, forKey: "dataSettings")
            
            kUserDefault.set(dateDataLoad, forKey: "data")
            
            kUserDefault.synchronize()
        }else{
            kUserDefault.removeObject(forKey:"portieri")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"difensori")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"centrocampisti")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"attaccanti")
            kUserDefault.synchronize()
            
            kUserDefault.removeObject(forKey:"dataSettings")
            kUserDefault.synchronize()
            
            kUserDefault.set(dataNeedToPersist, forKey: "dataSettings")
            
            kUserDefault.set(dateDataLoad, forKey: "data")
            
            kUserDefault.synchronize()
        }
        
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    func insertItems(name:String, lista:[Player])
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: lista)
        kUserDefault.set(data, forKey: name)
        
        kUserDefault.synchronize()
    }
    
    func retrieveItems(name:String)->[Player]
    {
        if let data = kUserDefault.object(forKey: name) as? NSData {
            let _mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Player]
            return _mySavedList
        }
        return []
    }
}


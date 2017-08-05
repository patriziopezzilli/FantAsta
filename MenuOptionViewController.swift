//
//  MenuOptionViewController.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 09/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//

import UIKit
import AudioToolbox

class MenuOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resetMenuView: UITableView!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var viewCustom: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var soundButton: UIButton!
    
    var content:[String] = ["Portieri","Difensori","Centrocampisti","Attaccanti","Tutti"]
    
    var first: Homepage = Homepage(nibName: nil, bundle: nil)
    var second: RandomPage = RandomPage(nibName: nil, bundle: nil)
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"

    @IBAction func touchSoundButton(_ sender: Any) {
        if(soundOn){
            print("Set audio off..")
            AudioServicesPlaySystemSound(1519)
            soundOn = false
            soundButton.setImage(UIImage.init(named: "sound_off"), for: .normal)
        }else{
            print("Set audio on..")
            AudioServicesPlaySystemSound(1519)
            soundOn = true
            soundButton.setImage(UIImage.init(named: "sound_on"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.layer.cornerRadius = 10
        self.tableView.layer.masksToBounds = true
        self.resetMenuView.layer.cornerRadius = 10
        self.resetMenuView.layer.masksToBounds = true
        self.viewCustom.layer.cornerRadius = 10
        self.viewCustom.layer.masksToBounds = true
        
        self.view.sendSubview(toBack: viewCustom)
        
        self.switch.isOn = dataNeedToPersist
        self.switch.setOn(dataNeedToPersist, animated: false)
        
        self.tableView.estimatedRowHeight = 170;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.resetMenuView.estimatedRowHeight = 170;
        self.resetMenuView.rowHeight = UITableViewAutomaticDimension;
        // Register the table view cell class and its reuse id
        self.resetMenuView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        self.resetMenuView.delegate = self
        self.resetMenuView.dataSource = self
        
        if(soundOn){
            soundButton.setImage(UIImage.init(named: "sound_on"), for: .normal)
        }else{
            soundButton.setImage(UIImage.init(named: "sound_off"), for: .normal)
        }
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return 4
    }
    
    @IBAction func touchTotalRandomize(_ sender: Any) {
        print("Total randomize..")
        
        randomContent = players
        navBarTitle = "Tutti"
        picked = "tutti"
        
        dismissWithCheck()
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.content[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        if(tableView == self.tableView){
            print("Role table view controller")
            switch (indexPath.row) {
            case 0:
                randomContent = portieri
                navBarTitle = "Portieri"
                picked = "portieri"
            case 1:
                randomContent = difensori
                navBarTitle = "Difensori"
                picked = "difensori"
            case 2:
                randomContent = centrocampisti
                navBarTitle = "Centrocampisti"
                picked = "centrocampisti"
            case 3:
                randomContent = attaccanti
                navBarTitle = "Attaccanti"
                picked = "attaccanti"
            default:
                print("default")
            }
            
            dismissWithCheck()
        }
        else if(tableView == self.resetMenuView){
            print("Reset table view controller")
            switch (indexPath.row) {
            case 0:
                print("Resetting Goalkeeper...")
                for object in portieri as! [Player] {
                    object.marked = false
                }
                dismissWithCheck()
            case 1:
                print("Resetting Defenders...")
                for object in difensori as! [Player] {
                    object.marked = false
                }
                dismissWithCheck()
            case 2:
                print("Resetting Middlefielders...")
                for object in centrocampisti as! [Player] {
                    object.marked = false
                }
                dismissWithCheck()
            case 3:
                print("Resetting Strikers...")
                for object in attaccanti as! [Player] {
                    object.marked = false
                }
                dismissWithCheck()
            default:
                print("default")
            }

        }
    }

    // Exit function
    @IBAction func exitFromModal(_ sender: Any) {
        print("Come back to Random page...")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchON(_ sender: Any) {
        print("switch set..")
        self.switch.isOn = true
        dataNeedToPersist = true
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        print("switch set to " + String(self.switch.isOn) + "..")
        self.switch.isOn = self.switch.isOn
        self.switch.setOn(self.switch.isOn, animated: false)
        dataNeedToPersist = self.switch.isOn
    }
    
    @IBAction func resetAssign(_ sender: Any) {
        print("Resetting All Players...")
        // Reset portieri
        for object in portieri as! [Player] {
            object.marked = false
        }
        // Reset difensori
        for object in difensori as! [Player] {
            object.marked = false
        }
        // Reset centrocampisti
        for object in centrocampisti as! [Player] {
            object.marked = false
        }
        // Reset attaccanti
        for object in attaccanti as! [Player] {
            object.marked = false
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func dismissWithCheck(){
        if(randomContent.filter{ $0.marked == false }.count == 0){
            // Alert User that this category is already done
            
            let alert = UIAlertController(title: "Hai completato già la categoria " + navBarTitle, message: "Premi \"Ok\" e riprova cliccando un'altra categoria.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAct = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            
            alert.addAction(okAct)
            
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }

    }
    
}

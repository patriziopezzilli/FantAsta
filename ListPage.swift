//
//  ThirdViewController.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 04/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//

import UIKit

class ListPage: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    var first: Homepage = Homepage(nibName: nil, bundle: nil)
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    var content:[Player] = []
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.tableView.estimatedRowHeight = 170;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        self.content = portieri
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return first
            .pickerDataSource.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return first.pickerDataSource[row]
    }
    
    /*
     let titleData = pickerData[row]
     let myTitle =  NSAttributedString(String: titleData, 
     attributes: [NSFontAttributeName: UIFont(name: "Georgia", size = 15.0)!, 
     NSForegroundColorAttributeName: UIColor(red:0.0,green:128/255.0,blue:0.0,alpha:1.0)])
     return myTitle
    */
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color = (row == pickerView.selectedRow(inComponent: component) ? UIColor(red:0.0,green:128/255.0,blue:0.0,alpha:1.0) : UIColor.black)
        return NSAttributedString(string: first.pickerDataSource[row], attributes: [NSForegroundColorAttributeName: color])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch first.pickerDataSource[row] {
        case "Portieri":
            self.content = portieri
            tableView.reloadData()
            pickerView.reloadAllComponents()
        case "Difensori":
            self.content = difensori
            tableView.reloadData()
            pickerView.reloadAllComponents()
        case "Centrocampisti":
            self.content = centrocampisti
            tableView.reloadData()
            pickerView.reloadAllComponents()
        case "Attaccanti":
            self.content = attaccanti
            tableView.reloadData()
            pickerView.reloadAllComponents()
        default:
            self.content = portieri
            tableView.reloadData()
            pickerView.reloadAllComponents()
        }
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return content.count
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell = UITableViewCell(style: UITableViewCellStyle.value1,
                               reuseIdentifier: cellReuseIdentifier)
        
        cell.textLabel?.text = self.content[indexPath.row].name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
    //    cell.textLabel?.font = UIFont(name:"Marker Felt", size: 20)
        
        cell.detailTextLabel?.text = self.content[indexPath.row].quotation
        
        if(self.content[indexPath.row].marked==true){
            cell.backgroundColor = UIColor(red:0.0,green:128/255.0,blue:0.0,alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell = UITableViewCell(style: UITableViewCellStyle.value1,
                               reuseIdentifier: cellReuseIdentifier)
        
        if(content[indexPath.row].marked == true){
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.gray
            
            // check from role
            switch content[indexPath.row].role {
            case "P":
                print(portieri[indexPath.row].name + "  deassigned")
                portieri[indexPath.row].marked = false
                tableView.reloadData()
                deleteFromExtracted(element: portieri[indexPath.row].name)
                reloadBadge()
            case "D":
                print(difensori[indexPath.row].name + "  deassigned")
                difensori[indexPath.row].marked = false
                tableView.reloadData()
                deleteFromExtracted(element: difensori[indexPath.row].name)
                reloadBadge()
            case "C":
                print(centrocampisti[indexPath.row].name + "  deassigned")
                centrocampisti[indexPath.row].marked = false
                tableView.reloadData()
                deleteFromExtracted(element: centrocampisti[indexPath.row].name)
                reloadBadge()
            case "A":
                print(attaccanti[indexPath.row].name + "  deassigned")
                attaccanti[indexPath.row].marked = false
                tableView.reloadData()
                deleteFromExtracted(element: attaccanti[indexPath.row].name)
                reloadBadge()
            default:
                players[indexPath.row].marked = false
            }
        }else{
           cell.backgroundColor = UIColor(red:0.0,green:128/255.0,blue:0.0,alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
            
            // check from role
            switch content[indexPath.row].role {
            case "P":
                print(portieri[indexPath.row].name + "  assigned")
                portieri[indexPath.row].marked = true
                tableView.reloadData()
                addToExtracted(element: portieri[indexPath.row].name)
                reloadBadge()
            case "D":
                print(difensori[indexPath.row].name + "  assigned")
                difensori[indexPath.row].marked = true
                tableView.reloadData()
                addToExtracted(element: difensori[indexPath.row].name)
                reloadBadge()
            case "C":
                print(centrocampisti[indexPath.row].name + "  assigned")
                centrocampisti[indexPath.row].marked = true
                tableView.reloadData()
                addToExtracted(element: centrocampisti[indexPath.row].name)
                reloadBadge()
            case "A":
                print(attaccanti[indexPath.row].name + "  assigned")
                attaccanti[indexPath.row].marked = true
                tableView.reloadData()
                addToExtracted(element: attaccanti[indexPath.row].name)
                reloadBadge()
            default:
                    players[indexPath.row].marked = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
     }
    
    func reloadBadge(){
        let tabItems = self.tabBarController?.tabBar.items as NSArray!
        
        // In this case we want to modify the badge number of the third tab:
        let tabItem = tabItems?[1] as! UITabBarItem
        
        // Now set the badge of the third tab
        tabItem.badgeValue = String(randomContent.filter{ $0.marked == true }.count)
    }
    
    func deleteFromExtracted(element: String){
        extracted = extracted.filter(){$0 != element}
    }

    func addToExtracted(element: String){
        extracted.append(element)
    }
}

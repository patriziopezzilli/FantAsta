//
//  Player.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 04/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//

import UIKit
import Foundation

class Player :NSObject, NSCoding{
    
    var name: String
    var team : String
    var quotation : String
    var role : String
    var marked : Bool = false
    var image : UIImage?
    
    init(name: String,team: String,quotation: String,role:String, marked:Bool, img:UIImage) {
        self.name = name
        self.team = team
        self.quotation = quotation
        self.role = role
        self.marked = marked
        self.image = img
    }
    
    init(name: String,team: String,quotation: String,role:String, marked:Bool) {
        self.name = name
        self.team = team
        self.quotation = quotation
        self.role = role
        self.marked = marked
        self.image = UIImage(named: "")
    }
    
    func markPlayer(){
        self.marked=true
    }
    
    func setImage(toSet:UIImage){
        self.image = toSet
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let name = decoder.decodeObject(forKey: "name") as? String
            let team = decoder.decodeObject(forKey: "team") as? String
            let quotation = decoder.decodeObject(forKey: "quotation") as? String
            let role = decoder.decodeObject(forKey: "role") as? String
            let marked = decoder.decodeObject(forKey: "marked") as? Bool ?? decoder.decodeBool(forKey: "marked")
        
        
        self.init(
            name: name!,
            team: team!,
            quotation: quotation!,
            role: role!,
            marked: marked
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.team, forKey: "team")
        coder.encode(self.quotation, forKey: "quotation")
        coder.encode(self.role, forKey: "role")
        coder.encode(self.marked, forKey: "marked")
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.team, forKey: "team")
        aCoder.encode(self.quotation, forKey: "quotation")
        aCoder.encode(self.role, forKey: "role")
        aCoder.encode(self.marked, forKey: "marked")
    }
}

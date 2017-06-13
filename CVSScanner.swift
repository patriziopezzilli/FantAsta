//
//  CVSScanner.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 07/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//
import Foundation
import UIKit

class CSVScanner {
    
    class func debug(string:String){
        
        print("CSVScanner: \(string)")
    }
    
    class func runFunctionOnRowsFromFile(data:String, theColumnNames:Array<String>, withFileName theFileName:String, withFunction theFunction:(Dictionary<String, String>)->()) {
        
            let encodingError:NSError? = nil
            var encoding:String.Encoding = String.Encoding.utf8
            let url = NSURL(string: "http://fantastadata.altervista.org/data/"+data+"/"+theFileName+".csv")
         //   try! String(contentsOf:messageURL as! URL, usedEncoding:&encoding)
           // if let fileObject = try? String(contentsOfFile: strBundle, encoding: String.Encoding.utf8){
            if let fileObject = try? String(contentsOf:url as! URL, usedEncoding:&encoding)
{               print("Loading " + theFileName + "...")
                
                var fileObjectCleaned = fileObject.replacingOccurrences(of: "\r", with: "\n")
                
                fileObjectCleaned = (fileObjectCleaned as NSString).replacingOccurrences(of: "\n\n", with: "\n")
                
                let objectArray = fileObjectCleaned.components(separatedBy:"\n")
                
                for anObjectRow in objectArray {
                    
                    let objectColumns = anObjectRow.components(separatedBy:",")
                    
                    var aDictionaryEntry = Dictionary<String, String>()
                    
                    var columnIndex = 0
                    
                    for anObjectColumn in objectColumns {
                        
                        aDictionaryEntry[theColumnNames[columnIndex]] = anObjectColumn.replacingOccurrences(of: "\"", with: "", options: String.CompareOptions.caseInsensitive, range: nil)
                        
                        columnIndex += 1
                    }
                    
                    if aDictionaryEntry.count>1{
                        theFunction(aDictionaryEntry)
                    }else{
                    }
                }
        }else{
            var first: Homepage = Homepage(nibName: nil, bundle: nil)
            CSVScanner.debug(string: "Unable to get path to csv file: \(theFileName).csv")
                let refreshAlert = UIAlertController(title: "Download dati fallito", message: "Download non portato a termine a causa di un errore di rete.", preferredStyle: UIAlertControllerStyle.alert)
                
                let refreshAction = UIAlertAction(title: "Riprova", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    // do action
                    first.loadData("any")
                    }
                
                refreshAlert.addAction(refreshAction)
                
                refreshAlert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                    
                }))
                
                DispatchQueue.main.async {
                    first.present(refreshAlert, animated: true, completion: nil)
                }

        }
    }
}

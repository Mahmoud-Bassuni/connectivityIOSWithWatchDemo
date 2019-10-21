//
//  InterfaceController.swift
//  connectivityDemo WatchKit Extension
//
//  Created by Nada Gamal on 10/20/19.
//  Copyright © 2019 Sarmady. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController , WCSessionDelegate {

    @IBOutlet var lbl1: WKInterfaceLabel!
     var wcSession : WCSession!
     @IBOutlet var tblViewProp: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    var data : [String] = []
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
        let message = ["hello" : [:]]
        if(WCSession.default.isReachable){
            wcSession.sendMessage(message,
                                  replyHandler: {
                                    (data) in
                                    var loadedData = data["Data"]
                                    let person = NSKeyedUnarchiver.unarchiveObject(with: loadedData! as! Data) as! [String]
                                    self.data = person
                                    self.tblViewProp.setNumberOfRows(person.count, withRowType: "firstRow")
                                    for(index,prog) in self.data.enumerated()
                                    {
                                        let row = self.tblViewProp.rowController(at: index) as! firstRow
                                        row.lblProp.setText(prog)
                                        
                                    }
                                    print(data)
            } ,
                                  errorHandler:  {
                                    (error) in
                                    
                                    print(error.localizedDescription)
                                    
            }
            )
        }
        
        
    }
    
    override func didDeactivate() {
       
        
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        let text = message["message"] as! String
//        lbl1.setText(text)
//        var replyValue = Dictionary<String ,AnyObject>()
//        replyValue["status"] = "Done" as AnyObject
//        replyHandler(replyValue)
                var replyValue = Dictionary<String ,AnyObject>()
                let loadData = message["Data"]
                let person = NSKeyedUnarchiver.unarchiveObject(with: loadData as! Data ) as? [String]
                data = person!
                replyValue["status"] = "Done" as AnyObject
                replyHandler(replyValue)
        
        
    }

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        // Code.
        
    }

}

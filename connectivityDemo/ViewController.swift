//
//  ViewController.swift
//  connectivityDemo
//
//  Created by Nada Gamal on 10/20/19.
//  Copyright © 2019 Sarmady. All rights reserved.
//

import UIKit
import WatchConnectivity
class ViewController: UIViewController , WCSessionDelegate {
    
    var wcSession : WCSession! = nil
    var data = ["data1","data2","data3","data4","data5","data6","data7","data8"];
    var lastMessgae : CFAbsoluteTime = 0
    
    func send(_ messgae : Data)
    {
        let currentTime = CFAbsoluteTimeGetCurrent()
        if  lastMessgae + 0.5 > currentTime
        {
            return
        }
      //  if (WCSession.default.isReachable){
            let message = ["Data" : messgae]
           // wcSession.sendMessage(message, replyHandler: nil, errorHandler: nil)
        
        wcSession.sendMessage(message,
                              replyHandler: {
                                (data) in
                                DispatchQueue.main.async {
                                    self.alert(title: "alert", message: data["status"] as! String)
                                }
                                print(data)
        } ,
                              errorHandler:  {
                                (error) in
                                DispatchQueue.main.async {
                                    self.alert(title: "alert", message: error.localizedDescription)
                                }
                                print(error.localizedDescription)
                                
        }
        )
        
       // }
        lastMessgae = CFAbsoluteTimeGetCurrent()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var lbl1: UITextField!
    
    @IBAction func btnAction(_ sender: Any) {
        let txt = lbl1.text!
        let message = ["message":txt]
        wcSession.sendMessage(message,
                              replyHandler: {
                                (data) in
                                DispatchQueue.main.async {
                                self.alert(title: "alert", message: data["status"] as! String)
                                }
                                print(data)
        } ,
                              errorHandler:  {
                                (error) in
                                  DispatchQueue.main.async {
                                self.alert(title: "alert", message: error.localizedDescription)
                                }
                                print(error.localizedDescription)
                                
        }
        )
        
    }
    
    @IBAction func loadDataTable (_ sender : Any)
    {
         let loadedData = NSKeyedArchiver.archivedData(withRootObject: data)
           send(loadedData)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: WCSession Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
        alert(title: "alert", message:"activationDidCompleteWith")
        // Code
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        alert(title: "alert", message: "sessionDidBecomeInactive")
        // Code
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        alert(title: "alert", message: "sessionDidDeactivate")
        // Code
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String , AnyObject>()
        if(message["hello"] != nil){
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: data)
            replyValues["Data"] = archiveData as AnyObject
            replyHandler(replyValues)
        }
    }
    
    
}

extension UIViewController {
    func alert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
}
}

//
//  detailedViewController.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/20/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class detailedViewController: UIViewController {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventOrganizer: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    
    var detailedData :NSDictionary = [:]
    var ref: FIRDatabaseReference?
    var eTitle: String = ""
    var eOrganizer:String = ""
    var eTime: String = ""
    var eDescription: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            eventTitle.text = eTitle
        eventOrganizer.text = eOrganizer
        eventTime.text = eTime
        eventDescription.text = eDescription
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("event title is \(eTitle)")
    
        
        fetchDetailed(eventTitle: eTitle, eventOrganizer: eOrganizer)
        
        
        
    }
    
    func fetchDetailed(eventTitle:String,eventOrganizer:String){
        
        
        print("fetch detailed data called")
        
        self.detailedData = [:]
        
        ref = FIRDatabase.database().reference()
        
        
        
        
        
        
        self.ref?.child("Activities").child(eventTitle).observeSingleEvent(of: .value, with: {(snapshot) in
            
            // get user value
            
            
            print("ref handle detailed data assingmnet called")
            
            var dic = snapshot.value! as! NSDictionary
            
            self.detailedData = dic
            print(self.detailedData)
            self.eventDescription.text = self.detailedData["description"] as! String
            self.eventTime.text = self.detailedData["time"] as! String
            
            
            
        })
        
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

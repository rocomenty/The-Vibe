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
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventOrganizer: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    var activityList :[Activities] = []
    var refHandle: UInt!
    var detailedData :NSDictionary = [:]
    var ref: FIRDatabaseReference?
    var eTitle: String = ""
    var eOrganizer:String = ""
    var eTime: String = ""
    var eDescription: String = ""
    var activityDic : Dictionary<String, Activities> = [:]
     var theEvent : Activities = Activities()
    var theRandomId : String = ""
    var theAttendee : [String] = []
    var isRegistered : Bool = false
    
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
        ref = FIRDatabase.database().reference()
        print("event title is \(eTitle)")
        
        fetchActivities()
        //   fetchDetailed(eventTitle: eTitle, eventOrganizer: eOrganizer)
        
        
        
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
    
       // print("eid is \(theRandomId) and the event title is \(theEvent.title)")
        
        if (isRegistered){
         let index =   theEvent.attendee.index(of:  (FIRAuth.auth()?.currentUser?.email)!)
            theEvent.attendee.remove(at: index!)
            self.ref?.child("Activities").child(theRandomId).setValue(formatActivityData(theActivity: theEvent)) { (error, ref) in
                print("success unregistering event !!!!!!!!!!!") //FIXME
                self.registerButton.setTitle("Register", for: .normal)
                self.isRegistered = false
                //alert success or failure
            }
            
            
            
        }
        else{
   
     
            
            theEvent.attendee.append(   (FIRAuth.auth()?.currentUser?.email)!)
            self.ref?.child("Activities").child(theRandomId).setValue(formatActivityData(theActivity: theEvent)) { (error, ref) in
                print("success registering event !!!!!!!!!!!") //FIXME
                //alert success or failure
            }
        }
        
    }
    
    func fetchActivities() {
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            
            let dic = snapshot.value! as! NSDictionary
            
            
            for (eid, eDetail) in dic {
                
                let eventID = eid as! String
                let dicAct = eDetail as! NSDictionary
                let activityFetched = Activities()
                activityFetched.description = dicAct["description"]! as! String
                activityFetched.title = dicAct["title"]! as! String
                activityFetched.organizer = dicAct["organizer"]! as! String
                activityFetched.startTime = stringToDate(dateString: dicAct["time"]! as! String)
                
                
                if let attendeeOnline = dicAct["attendee"]{
                    
                    print(attendeeOnline)
                   activityFetched.attendee = attendeeOnline as! [String]
                    
                }
           
                self.activityDic[eventID] = activityFetched
                
                
                if (activityFetched.organizer==self.eOrganizer && activityFetched.title==self.eTitle ){
                    
                    
                
                    self.theRandomId = eventID
                    
                }
             
            }
            
    
            
           
            
            for event in self.activityDic.values {
                if ( event.organizer == self.eOrganizer && event.title == self.eTitle){
                    self.theEvent = event
                    let attendee = self.theEvent.attendee
                    
                    if (attendee.contains((FIRAuth.auth()?.currentUser?.email)!)){
                        self.registerButton.setTitle("Unregister", for: .normal)
                        self.isRegistered = true
                        
                    }
                    
                }
                
            }
            
            
            
            self.eventDescription.text = self.theEvent.description
            self.eventTime.text = dateToString(date: self.theEvent.startTime)
        
            
        })
    }
    
    

    
}

//
//  editViewController.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/22/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class editViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
   
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var attendeeField: UITextView!
    
    @IBOutlet weak var descriptionField: UITextView!
    
     var ref: FIRDatabaseReference?
    var refHandle: UInt!
    
    // here are some variables to store stuff passed from meviewcontroller 
    
    
    var theRandomID : String = ""
    var eTitle : String = ""
    var eOrganizer : String = ""
    var theEvent : Activities = Activities()
    
     var activityDic : Dictionary<String, Activities> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref = FIRDatabase.database().reference()
        fetchActivities()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // FIXME something to notice:  the submit button is linked three times to different view, don't know wht
    @IBAction func submitPressed(_ sender: Any) {
        
     
            print ("editing right now ")
            
            if (titleField.text != nil){
                theEvent.title = titleField.text!
                
                 theEvent.organizer = (FIRAuth.auth()!.currentUser!.email)!
                
                if let description = descriptionField.text {
                    theEvent.description = description
                    
                }
                //FIXME
//                if let location = clLocation {
//                    theEvent.location = location
//                }
                
                
                if (isValidActivity(theActivity: theEvent)) {
                    print("Adding to database")
                    self.ref?.child("Activities").child(theRandomID).setValue(formatActivityData(theActivity: theEvent)) { (error, ref) in
                        print("success adding event !!!!!!!!!!!") //FIXME
                        //alert success or failure
                        //self.performSegue(withIdentifier: "addEventToMain", sender: self)
                    }
                }
                
            }
            
            
            
            
            
            
        
        
    }

    func fetchActivities() {
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            
            let dic = snapshot.value! as! NSDictionary
            print("currently fetching activities in detailed view")
            
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
                    
                    
                    
                    self.theRandomID = eventID
                    
                }
                
            }
            
            
            
            
            
            for event in self.activityDic.values {
                if ( event.organizer == self.eOrganizer && event.title == self.eTitle){
                    self.theEvent = event
                    let attendee = self.theEvent.attendee
                    
                    if (attendee.contains((FIRAuth.auth()?.currentUser?.email)!)){
                       // self.registerButton.setTitle("Unregister", for: .normal)
                      //  self.isRegistered = true
                        
                    }
                    
                }
                
            }
            
            self.titleField.text = self.theEvent.title
            self.typeLabel.text = activityTypeToString(at: self.theEvent.type)
            
            self.descriptionField.text = self.theEvent.description
            self.timeLabel.text = dateToString(date: self.theEvent.startTime)
            
            
        })
        
    }
    
    
}

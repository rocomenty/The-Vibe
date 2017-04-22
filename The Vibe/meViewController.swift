//
//  CommunityController.swift
//  The Vibe
//
//  Created by Rocomenty on 4/11/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class meViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var theSegmentControl: UISegmentedControl!
     var signedActivityList :[Activities] = []
    var ownActivityList :[Activities] = []
    
    var currentActivity : [Activities] = []
 
    var theEvent : Activities = Activities()
    var theRandomId : String = ""
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
        ref = FIRDatabase.database().reference()
        fetchActivities()
       
    }
    
    @IBAction func changedSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentActivity = signedActivityList
        case 1:
          currentActivity = ownActivityList
            print("own activity list is \(ownActivityList)")
        default:
            break
        }
        self.theTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        setUpNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = getOrange()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = currentActivity[indexPath.row].title
        
        cell.detailTextLabel?.text = activityTypeToString(at: currentActivity[indexPath.row].type)
      
        
        return cell
    }
    
    var indexSelected = 0
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        indexSelected = indexPath.row
        let currentSegment = theSegmentControl.selectedSegmentIndex
        
       
        
        if (currentSegment == 0){
            // now I am participant of event, so I need to move from meview to detail view to view details of event 
            
            self.performSegue(withIdentifier: "meToDetail", sender: nil)

        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "meToDetail"{
            
            print("prepare for segue com to detail called")
            // print("index is \(indexSelected)")
            
            if let detailedVC = segue.destination as? detailedViewController{
                
                
                detailedVC.eTitle = self.signedActivityList[indexSelected].title
                detailedVC.eOrganizer = self.signedActivityList[indexSelected].organizer
                
                
                
            }
            
            
        }
    }
    
    
    
    
    func fetchActivities() {
        self.ownActivityList = []
        self.signedActivityList = []
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
                    
               activityFetched.attendee = attendeeOnline as! [String]
                    
                }
                
                // this is the total activity dic
                
             //   self.activityDic[eventID] = activityFetched
               /// print("act feched is \(activityFetched.attendee) and the email current is \((FIRAuth.auth()?.currentUser?.email)!)")
                if (activityFetched.organizer == (FIRAuth.auth()?.currentUser?.email)! )
                {
                    // ok now I am the organizer of the event 
                    print ("haha i own this act")
                    self.ownActivityList.append(activityFetched)
                    
                    
                    
                    
                }
                 if (activityFetched.attendee.contains((FIRAuth.auth()?.currentUser?.email)!))
                {
                   // now I am an attendee of the event 
               
                    
                    self.signedActivityList.append(activityFetched)
                }
                
                else{
                    
                    
                    // now the event is neither owned by me, nor contains me as a participant
                }
                self.currentActivity = self.signedActivityList
                 print(self.currentActivity)
                self.theTableView.reloadData()
               
            }
            
            
        })
        
            
    }


        

    
}

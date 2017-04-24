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
import UserNotifications


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
    
    //notification time picker
    var datePicker: UIDatePicker!
    var cancelButton: UIButton!
    var pickerSubmitButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
        ref = FIRDatabase.database().reference()
        fetchActivities()
        setUpDatePicker()
       
    }
    
    @IBAction func changedSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentActivity = signedActivityList
        case 1:
            currentActivity = ownActivityList
        default:
            break
        }
        self.theTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setUpNavigationBar() {
//        self.navigationController?.navigationBar.barTintColor = getOrange()
//        
//    }
    
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
        else{
            self.performSegue(withIdentifier: "meToEdit", sender: nil)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    //adapted from https://www.youtube.com/watch?v=T0xzTbXhOvE
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let notificationAction = UITableViewRowAction(style: .normal, title: "Set Notification", handler: { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            let event = self.currentActivity[indexPath.row]
            self.presentNotificationPicker(event: event)
        })
        notificationAction.backgroundColor = getOrange()
        return [notificationAction]
    }
    
    func presentNotificationPicker(event: Activities) {
        datePicker.date = event.startTime
        presentDatePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "meToDetail"{
            
            print("prepare for segue com to detail called")
      
            
            if let detailedVC = segue.destination as? detailedViewController{
                
                
                detailedVC.eTitle = self.signedActivityList[indexSelected].title
                detailedVC.eOrganizer = self.signedActivityList[indexSelected].organizer
                
            }
        }
        else if segue.identifier == "meToEdit"{
            
            print("prepare for segue me to edit called")

            if let editVC = segue.destination as? editViewController{
                // Here prepopulate the field in editview
              editVC.eTitle =  self.ownActivityList[indexSelected].title
              editVC.eOrganizer = self.ownActivityList[indexSelected].organizer
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
                
                _ = eid as! String
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
                
                switch self.theSegmentControl.selectedSegmentIndex {
                case 0:
                    self.currentActivity = self.signedActivityList
                case 1:
                    self.currentActivity = self.ownActivityList
                default:
                    break
                }
                self.theTableView.reloadData()
               
            }
            
            
        })
        
            
    }
    
    func dateDidChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    func setUpDatePicker() {
        datePicker = UIDatePicker()
        cancelButton = UIButton()
        pickerSubmitButton = UIButton()
        datePicker.frame = CGRect(x: 0, y: 400, width: self.view.frame.width, height: 200)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = getOrange()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.tintColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateDidChanged), for: .valueChanged)
        
        cancelButton.frame = CGRect(x: self.view.frame.maxX-100, y: 350, width: 100, height: 30)
        cancelButton.backgroundColor = getOrange()
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelDatePicker), for: .touchUpInside)
        
        pickerSubmitButton.frame = CGRect(x: 0, y: 350, width: 100, height: 30)
        pickerSubmitButton.backgroundColor = getOrange()
        pickerSubmitButton.setTitleColor(UIColor.white, for: .normal)
        pickerSubmitButton.setTitle("Set Notification", for: .normal)
        pickerSubmitButton.addTarget(self, action: #selector(self.submitDatePicker), for: .touchUpInside)

    }
    
    func cancelDatePicker() {
        datePicker.removeFromSuperview()
        pickerSubmitButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
    func submitDatePicker() {
        
    }
    
    func presentDatePicker() {
        self.view.addSubview(datePicker)
        self.view.addSubview(pickerSubmitButton)
        self.view.addSubview(cancelButton)
    }

    //adapted from https://www.hackingwithswift.com/read/21/2/scheduling-notifications-unusernotificationcenter-and-unnotificationrequest
    func scheduleLocal(event: Activities) {
        print("setting notifications")
      //  let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "An Event is happening soon!"
        content.body = event.title + " by " + event.organizer
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        
        dateComponents.hour = calendar.component(.hour, from: event.startTime)
        dateComponents.minute = calendar.component(.minute, from: event.startTime)
        
//        let trigger2 = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: <#T##Bool#>)
        
//        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
//        center.add(request)
    }
    
}

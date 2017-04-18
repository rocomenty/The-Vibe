//
//  AddEventController.swift
//  The Vibe
//
//  Created by Rocomenty on 4/11/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit

class AddEventController: UIViewController {

    var ref: FIRDatabaseReference?
    var theActivity: Activities?
    
    var datePicker: UIDatePicker!
    var cancelButton: UIButton!
    var pickerSubmitButton: UIButton!
    var location: MKPlacemark?
    var clLocation: CLLocation?
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theActivity = Activities() //default init
        setUpDatePicker()
        ref = FIRDatabase.database().reference()
        
        setUpLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setUpLabels() {
        //type
        typeLabel.text = theActivity?.activityToString()
        
        //locations
        if location != nil {
            locationLabel.text = parseAddress(selectedItem: location!)
        }
        else if clLocation != nil {
            locationLabel.text = cllocationToString(location: clLocation!.coordinate)
        }
        else {
            locationLabel.text = "Please Pick a location"
        }
        //time
        startTimeLabel.text = dateToString(date: (theActivity?.startTime)!)
        
        
        
    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        //adapted from http://stackoverflow.com/questions/38042028/how-to-add-actions-to-uialertcontroller-and-get-result-of-actions-swift
        let alert = UIAlertController(title: "Please pick an event type", message: "", preferredStyle: .actionSheet)
        for i in ["Academic", "Student Organization", "Personal"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: getEventType))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func getEventType(action: UIAlertAction) {
        theActivity?.type = stringToActivityType(str: action.title!)
        typeLabel.text = action.title
    }
    
    @IBAction func pickStartTimePressed(_ sender: UIButton) {
        presentDatePicker()
    }
    
    func presentDatePicker() {
        self.view.addSubview(datePicker)
        self.view.addSubview(pickerSubmitButton)
        self.view.addSubview(cancelButton)
    }
    
    func dateDidChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    func cancelDatePicker() {
        datePicker.removeFromSuperview()
        pickerSubmitButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
    }
    
    func submitDatePicker() {
        theActivity?.startTime = datePicker.date
        startTimeLabel.text = dateToString(date: datePicker.date)
        cancelDatePicker()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let activity = theActivity {
            print("adding to data")
            if (titleInput.text != nil) {
                theActivity?.title = titleInput.text!
                theActivity?.organizer = (FIRAuth.auth()!.currentUser!.email)!
                if let description = descriptionInput.text {
                    theActivity?.description = description
                }
                
                if let location = clLocation {
                    theActivity?.location = location.coordinate
                }
                else if let location = location {
                    theActivity?.location = location.coordinate
                }
                if (isValidActivity(theActivity: activity)) {
                    print("Adding to database")
                    self.ref?.child("Activities").childByAutoId().setValue(formatActivityData(theActivity: activity)) { (error, ref) in
                        
                        //alert success or failure
                        
                    }
                }
            }
            else {
                //alert title
            }
        }
    }
    
    func handleError(error: Error?) {
        if (error == nil) {
            //promt success, clear fields and segue
        }
        else {
            //promt failure
        }
    }
    
    func setUpDatePicker() {
        datePicker = UIDatePicker()
        cancelButton = UIButton()
        pickerSubmitButton = UIButton()
        datePicker.frame = CGRect(x: 0, y: 400, width: self.view.frame.width, height: 200)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = self.submitButton.backgroundColor
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.tintColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(self.dateDidChanged), for: .valueChanged)
        
        cancelButton.frame = CGRect(x: self.view.frame.maxX-100, y: 350, width: 100, height: 30)
        cancelButton.backgroundColor = self.submitButton.backgroundColor
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelDatePicker), for: .touchUpInside)
        
        pickerSubmitButton.frame = CGRect(x: 0, y: 350, width: 100, height: 30)
        pickerSubmitButton.backgroundColor = self.submitButton.backgroundColor
        pickerSubmitButton.setTitleColor(UIColor.white, for: .normal)
        pickerSubmitButton.setTitle("Submit", for: .normal)
        pickerSubmitButton.addTarget(self, action: #selector(self.submitDatePicker), for: .touchUpInside)
    }

}

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

class AddEventController: UIViewController {

    var ref: FIRDatabaseReference?
    var theActivity: Activities?
    
    var datePicker: UIDatePicker!
    var cancelButton: UIButton!
    var pickerSubmitButton: UIButton!
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theActivity = Activities() //default init
        setUpDatePicker()
        ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickStartTimePressed(_ sender: UIButton) {
        presentDatePicker()
    }
    
    func presentDatePicker() {
        self.view.addSubview(datePicker)
        self.view.addSubview(pickerSubmitButton)
        self.view.addSubview(cancelButton)
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
        cancelDatePicker()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let activity = theActivity {
            print("adding to data")
            if (titleInput.text != nil && typeInput.text != nil) {
                theActivity?.title = titleInput.text!
                theActivity?.type = typeInput.text!
                if let description = descriptionInput.text {
                    theActivity?.description = description
                }
                if (isValidActivity(theActivity: activity)) {
                    print("Adding to database")
                    self.ref?.child("Activities").childByAutoId().setValue(formatActivityData(theActivity: activity, organizer: FIRAuth.auth()?.currentUser)) { (error, ref) in
                        
                        
                        
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        
    }
    
    func handleError(error: Error?) {
        if (error == nil) {
            //promt success, clear fields and segue
        }
        else {
            //promt failure
        }
    }

}

////
////  createActivity.swift
////  The Vibe
////
////  Created by Shuailin Lyu on 4/8/17.
////  Copyright © 2017 Shuailin Lyu. All rights reserved.
////
//
//import UIKit
//
//class createActivity: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
//   
//    var event :Activities!
//    
//    
//    
//    @IBOutlet weak var organizerName: UITextField!
//    @IBOutlet weak var eventDescription: UITextView!
//    @IBOutlet weak var eventTitle: UITextField!
//    @IBOutlet weak var startTime: UIDatePicker!
//    @IBOutlet weak var endTime: UIDatePicker!
//    
//    @IBOutlet weak var eventLocation: UITextField!
//    @IBOutlet weak var eventType: UIPickerView!
//    var type = ""
//    var pickerData: [String] = [String]()
//    var activity : Activities!
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        pickerData = ["Personal", "Academic", "Group"]
//        eventType.dataSource = self
//        eventType.delegate = self
//               
//    }
//    //start time
//    /*
//    @IBAction func datePicked(_ sender: Any) {
//        
//        
//        
//        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: (sender as AnyObject).date)
//        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
//            print("\(day) \(month) \(year)")
//        }
//        
//        
//        
//        
//        
//        
//    }*/
//    // when the submit button is pressed 
//    // trying to create a activity object 
//
//    
//    @IBAction func submitEvent(_ sender: Any) {
//        // Since Date can only store Greenwich time, we are forced to store start time and end time as strings for now
//        let local = NSTimeZone.init(abbreviation:"CST")
//        NSTimeZone.default = local as TimeZone!
//        startTime.timeZone = TimeZone.ReferenceType.default
//        endTime.timeZone = TimeZone.ReferenceType.default
//
//       // print(startTime.date)   //DELETE ME
//        
//        if (startTime.date>endTime.date){
//            err(msg: "start date cannot be after end date ")
//        }
//       
//         let localStartTime = getLocalizedTime(targetDate: startTime.date)
//        let localEndTime = getLocalizedTime(targetDate: endTime.date)
//        
//     
//        
//        event = Activities(type: type, name: eventTitle.text!, organizer: organizerName.text!, eventLocation: eventLocation.text!, startDate: localStartTime, endDate: localEndTime, details: eventDescription.text!)
//        
//        
//        print(event)   //DELETE ME
// 
//        
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//      
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerData.count;
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
//    
//    
//    
//    func pickerView(_ pickerView: UIPickerView,
//                    didSelectRow row: Int,
//                    inComponent component: Int)
//    {
//        
//        if (row == 0 ){
//       type = "Personal"
//       
//        }
//        else if (row == 1){
//       type = "Academic"
//            
//                  }
//            
//        else{
//            
//            
//           type = "Group"
//        }
//        
//        
//        
//    }
//    
//    func getLocalizedTime(targetDate : Date)-> String{
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.ReferenceType.default
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let strDate = formatter.string(from: targetDate)
//       return strDate
//        
//    }
//    
//    func err( msg : String){
//        
//        /// need to add alert controlelr
//        
//        print (msg)
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

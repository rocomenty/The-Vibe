//
//  functions.swift
//  
//
//  Created by Rocomenty on 4/11/17.
//
//

import Foundation
import UIKit
import MapKit
import FirebaseAuth

func showAlert(errorCode: Int, Title: String, Message: String) -> UIAlertController {
    let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    return alertController
}

func isValidActivity(theActivity: Activities) -> Bool {
    return !theActivity.title.isEmpty && !theActivity.type.isEmpty && !theActivity.organizer.isEmpty

}

func formatActivityData(theActivity: Activities, organizer: FIRUser?) -> [String:String] {
    
    return ["title":theActivity.title, "type":theActivity.type, "organizer": organizer!.email!, "location": cllocationToString(location: theActivity.location), "time": dateToString(date: theActivity.startTime), "description" : theActivity.description]
}

func cllocationToString(location: CLLocationCoordinate2D) -> String {
    return String(location.longitude) + "," + String(location.latitude);
}

func dateToString(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "mm/dd/yyyy hh:mm"
    return dateFormatter.string(from: date)
}

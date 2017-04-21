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
    return !theActivity.title.isEmpty && !theActivity.organizer.isEmpty

}

func formatActivityData(theActivity: Activities) -> [String:Any] {
    
    return ["title":theActivity.title, "type":theActivity.activityToString(), "organizer": theActivity.organizer, "longitude": String(theActivity.location.longitude), "latitude": String(theActivity.location.latitude), "time": dateToString(date: theActivity.startTime), "description" : theActivity.description, "date": [".sv": "timestamp"]]
}

func stringToActivityType(str: String) -> Activities.ActivityType {
    if str == "Academic" {
        return Activities.ActivityType.Academic
    }
    else if str == "Student Organization" {
        return Activities.ActivityType.StudentOrganization
    }
    else {
        return Activities.ActivityType.Personal
    }
}

func cllocationToString(location: CLLocationCoordinate2D) -> String {
    return String(location.longitude) + ", " + String(location.latitude);
}

func dateToString(date: Date) -> String {
    let dateFormatter: DateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    return dateFormatter.string(from: date)
}

func getOrange() -> UIColor {
    return UIColor(red:0.97, green:0.71, blue:0.36, alpha:1.0)
}

func parseAddress(selectedItem:MKPlacemark) -> String {
    // put a space between "4" and "Melrose Place"
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    // put a comma between street and city/state
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    // put a space between "Washington" and "DC"
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
        format:"%@%@%@%@%@%@%@",
        // street number
        selectedItem.subThoroughfare ?? "",
        firstSpace,
        // street name
        selectedItem.thoroughfare ?? "",
        comma,
        // city
        selectedItem.locality ?? "",
        secondSpace,
        // state
        selectedItem.administrativeArea ?? ""
    )
    return addressLine
}

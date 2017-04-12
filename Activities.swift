//
//  Activities.swift
//  The Vibe
//
//  Created by Shuailin Lyu on 4/7/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import Foundation
import MapKit



class Activities{
    
    
    var title: String
    var type: String
    var organizer: String
    
    var location: CLLocationCoordinate2D
    var startTime : Date
    var description: String
   
    
    init() {
        self.title = "Hello"
        self.type = "World"
        self.organizer = "cheng.luo@wustl.edu"
        self.location = CLLocationCoordinate2D()
        self.startTime = Date()
        self.description = "No description"
    }
}



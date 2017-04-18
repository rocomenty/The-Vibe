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


class CommunityController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var addEventButton: UIButton!
    var activities: [Activities] = []
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref = FIRDatabase.database().reference()
        fetchActivities()
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
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = activities[indexPath.row].title
        cell.detailTextLabel?.text = activities[indexPath.row].organizer
        
        return cell
    }
    
    func fetchActivities() {
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            print("fetching ")
            
            
        })
    }

}

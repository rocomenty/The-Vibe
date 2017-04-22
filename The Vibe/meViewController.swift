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
    
    var data: [[String]] = []
    var ownActivities: [[String]] = [] //0 position is title, 1 is type
    var signedUpActivities: [[String]] = [] //0 position is title, 1 is type
    
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
        ref = FIRDatabase.database().reference()
        fetchActivities()
        data = signedUpActivities
        self.theTableView.reloadData()
    }
    
    @IBAction func changedSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            data = signedUpActivities
        case 1:
            data = ownActivities
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = data[indexPath.row][0]
        cell.detailTextLabel?.text = data[indexPath.row][1]
      
        
        return cell
    }
    
    func fetchActivities() {
        
        
        self.signedUpActivities = []
        self.ownActivities = []
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            print("fetching ")
            let dic = snapshot.value! as! NSDictionary
            
            let dicValue  = dic.allValues as NSArray
            
            for singleActivity in dicValue{
                let activity = singleActivity as! NSDictionary
                
                if (activity["organizer"] as? String == FIRAuth.auth()?.currentUser?.email) {
                    
                    let test1 = activity["title"] as! String
                    
                    let test2 = activity["type"] as! String
                    
                    let test3 = [test1, test2]
                    
                    self.ownActivities.append(test3)
                    //self.ownActivities.append([activity["title"], activity["type"]] as! [String])
                }
                
                if let participants = activity["attendee"] as? [String] {
                    for participant in participants {
                        if participant == FIRAuth.auth()?.currentUser?.email {
                            let test1 = activity["title"] as! String
                            
                            let test2 = activity["type"] as! String
                            
                            let test3 = [test1, test2]
                            self.signedUpActivities.append(test3)

                           // self.signedUpActivities.append([activity["title"], activity["type"]] as! [String])
                        }
                    }
                }
            }
        })
    }
    
}

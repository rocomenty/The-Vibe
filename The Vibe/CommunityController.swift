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
    var activities: [String] = []
    var organizer: [String] = []
    var detailedData :NSDictionary = [:]
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    var activityArr : [Activities] = []
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
                 ref = FIRDatabase.database().reference()
        fetchActivities()
        print("now the size is \(activityArr.count)")
        self.theTableView.reloadData()
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
     

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = getOrange()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
       
        cell.textLabel?.text = activityArr[indexPath.row].title
        
        cell.detailTextLabel?.text = activityArr[indexPath.row].organizer
        
        return cell
    }
    
    
    
 
    
    var indexSelected = 0
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
  
     indexSelected = indexPath.row

    self.performSegue(withIdentifier: "communityToDetail", sender: nil)
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
 
        if segue.identifier == "communityToDetail"{
            
            print("prepare for segue com to detail called")
            print("index is \(indexSelected)")
            
            if let detailedVC = segue.destination as? detailedViewController{

                
                detailedVC.eTitle = self.activities[indexSelected]
                detailedVC.eOrganizer = self.organizer[indexSelected]
                
                
                
            }

            
        }
    }
    

    
    func fetchActivities() {
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            print("fetchact activated")
            var dic = snapshot.value! as! NSDictionary
            var array = dic.allValues as! NSArray
            
            
            
            
            
            for singleAct in array {
                var dicAct = singleAct as! Dictionary<String, String>
                
                var activityFetched = Activities()
                activityFetched.description = dicAct["description"]!
                activityFetched.title = dicAct["title"]!
                activityFetched.organizer = dicAct["organizer"]!
                activityFetched.startTime = stringToDate(dateString: dicAct["time"]!)
                
                
                self.activityArr.append(activityFetched)
                
                
                
                
            }
            
      
            
               self.theTableView.reloadData()
            
            
            
            
        })
    }
    

}

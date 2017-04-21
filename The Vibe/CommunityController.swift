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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
                 ref = FIRDatabase.database().reference()
        fetchActivities()
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
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
       
        cell.textLabel?.text = activities[indexPath.row]
        cell.detailTextLabel?.text = organizer[indexPath.row]
        
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
      self.activities = []
        self.organizer = []
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            print("fetching ")
            var dic = snapshot.value! as! NSDictionary

            var dicValue  = dic.allValues as! NSArray
           
            for singleActivity in dicValue{
                var test3 = singleActivity as! NSDictionary
             
            
          self.activities.append(test3["title"] as! String)
              self.organizer.append(test3["organizer"] as! String)
                
      
                
    
            }
            
            self.theTableView.reloadData()
        })
    }

}

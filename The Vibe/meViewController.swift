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


class meViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var theTableView: UITableView!
    @IBOutlet weak var addEventButton: UIButton!
    var activities: [String] = []
   
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       setupTableView()
        theTableView.dataSource = self
        theTableView.delegate = self
        ref = FIRDatabase.database().reference()
        fetchActivities()
        self.theTableView.reloadData()
        
        
    }
    
    private func setupTableView() {
        
        theTableView = UITableView(frame: view.frame.offsetBy(dx: 0, dy: 20))
         theTableView.dataSource = self
         theTableView.delegate = self
         theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(theTableView)
        
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
      
        
        return cell
    }
    
    func fetchActivities() {
        self.activities = []
              refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            print("fetching ")
            var dic = snapshot.value! as! NSDictionary
            
            var dicValue  = dic.allValues as! NSArray
            
            for singleActivity in dicValue{
                var test3 = singleActivity as! NSDictionary
                var activityTest = Activities()
                
                self.activities.append(test3["title"] as! String)
              
                
                
                
                
            }
            
            self.theTableView.reloadData()
        })
    }
    
}

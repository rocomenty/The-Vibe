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
    var activities: [String] = []
    var activityArr: [Activities] = []
    
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
        
        cell.textLabel?.text = activityArr[indexPath.row].title
        
        
        return cell
    }
    
    func fetchActivities() {
        activityArr = []
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            let dic = snapshot.value! as! NSDictionary
            let array = dic.allValues as NSArray
            
            
            
            
            
            for singleAct in array {
                var dicAct = singleAct as! NSDictionary
                
                let activityFetched = Activities()
                activityFetched.description = dicAct["description"]! as! String
                activityFetched.title = dicAct["title"]! as! String
                activityFetched.organizer = dicAct["organizer"]! as! String
                activityFetched.startTime = stringToDate(dateString: dicAct["time"]! as! String)
                
                
                self.activityArr.append(activityFetched)
                
                
                
                
            }
            
            
            
            self.theTableView.reloadData()
            
            
            
            
        })
    }
    
    
}

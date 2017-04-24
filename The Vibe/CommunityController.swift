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
     let searchIndicator =   UIActivityIndicatorView()
    var detailedData :NSDictionary = [:]
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    var activityArr : [Activities] = []
    
    var peekview = peekViewController()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
        ref = FIRDatabase.database().reference()
        setUpIndicator()
         DispatchQueue.global(qos: .userInitiated).async {
            self.searchIndicator.startAnimating()
        self.fetchActivities()
            DispatchQueue.main.async {

        self.theTableView.reloadData()
                 self.searchIndicator.stopAnimating()
            }
        }
        
          registerForPreviewing(with: self, sourceView: theTableView)
        
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
    
    func setUpIndicator(){
        
       
        searchIndicator.color = .black
        searchIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchIndicator.center = self.view.center
        searchIndicator.hidesWhenStopped = true
        self.view.addSubview(searchIndicator)
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
                
                
                detailedVC.eTitle = self.activityArr[indexSelected].title
                detailedVC.eOrganizer = self.activityArr[indexSelected].organizer
            }
        }
    }
    
    
    
    func fetchActivities() {
        activityArr = []
        
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            let dic = snapshot.value! as! NSDictionary
            let array = dic.allValues as NSArray
            
            for singleAct in array {
                let dicAct = singleAct as! NSDictionary
                
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


extension CommunityController : UIViewControllerPreviewingDelegate{
     func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = theTableView.indexPathForRow(at: location) else {return nil}
        
        print("3dpressed !!!!!!!!!111")
        guard let cell = theTableView.cellForRow(at: indexPath) else {return nil}
       previewingContext.sourceRect = cell.frame
        let description = activityArr[indexPath.row].description
        self.peekview.peekText?.text = description
        
        
        let preferedWidth = self.view.frame.width - 50.0
        self.peekview.preferredContentSize = CGSize(width: preferedWidth, height: preferedWidth)
        
        return self.peekview

        
        
        
        
    
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(self.peekview, sender: self)
    }
    
    
}

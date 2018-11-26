//
//  EpChartData.swift
//  MindSafe
//
//  Created by Bob on 2018-11-25.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//


import UIKit
import Charts
import FirebaseDatabase




class EpChartDataViewController:
    
UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var ref: DatabaseReference!
    var handler:DatabaseHandle!
    //Initialized empty arrays for chart axis
    var months:[String] = []
    var epScore:[Double] = []
    
    var cellData:[String] = []
    
    var taskA = false
    var taskB = false


    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = cellData[indexPath.row]
        
       
        
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    
    
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // action updating chart from firebase
    @IBAction func updateChart(_ sender: Any) {
        self.myTableView.reloadData()
    }

    
    // setting database in viewcontroller
    func setDatabase(){
        //reference to database
        //myGroup.enter()
        ref=Database.database().reference()
        
        //Pushback values from database when event occurs
        ref.child("Date1V5").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                self.months.append(rest.value as! String)
                
            }
           self.taskA = true
           self.checkResult()
          
        })
        
        //Pushback values from database when event occurs
        ref.child("epScoreV5").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                self.epScore.append(Double(rest.value as! String)!)
                
            }
           self.taskB = true
            self.checkResult()
           
        })
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setDatabase()
        
    
    }
    
    func setCellData(){
        for i in 0..<self.months.count{
            cellData.append("DATE: "+months[i]+"    SCORE: "+String(epScore[i]))
            
        }
    }
    
    
    func checkResult(){
        if taskA && taskB {
            setCellData()
            self.myTableView.reloadData()
            
        }
    }
    
}


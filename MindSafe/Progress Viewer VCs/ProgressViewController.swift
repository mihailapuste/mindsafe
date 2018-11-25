//
//  ProgressViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-14.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
//  Worked on by Bob Liu


import UIKit
import Charts
import FirebaseDatabase

class ProgressViewController:

UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var handler:DatabaseHandle!
    var handler2:DatabaseHandle!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var LineChartView: LineChartView!
    
  
    
    @IBOutlet weak var myTextField1: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // action saving dummy data
    @IBAction func savBut1(_ sender: Any) {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat="dd.MM.yyyy"
        let result = formater.string(from: date)
        
        //When textfield is entered with a number
        if myTextField1.text != ""
        {
            ref?.child("Date1").childByAutoId().setValue(result)
            
            //months.append(result)
            ref?.child("epScore").childByAutoId().setValue(myTextField1.text)
            
            var myDouble = Double(myTextField1.text!)
            
            epScore.append(myDouble!)
            
            myDouble = myDouble!+5.0
            
            ref?.child("semScore").childByAutoId().setValue(String(myDouble!))
            
            //semScore.append(myDouble!)
            
            myTextField1.text = ""
            
            
        }
    }
    
    // action updating chart from firebase
    @IBAction func updateChart(_ sender: Any) {
        self.viewDidLoad()
        self.viewWillAppear(true)
        self.months.removeAll()
        self.epScore.removeAll()
        self.semScore.removeAll()
    }
    
    
    //Update button to refresh the chart view
  
    
  
    
    //Initialized empty arrays for chart axis
    var months:[String] = []
    var epScore:[Double] = []
    var semScore:[Double] = []
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    // setting database in viewcontroller
    func setDatabase(){
        //reference to database
        ref=Database.database().reference()
        
        //Pushback values from database when event occurs
        ref.child("Date1").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                
                self.months.append(rest.value as! String)            }
        })
        
        //Pushback values from database when event occurs
        ref.child("epScore").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                
                self.epScore.append(Double(rest.value as! String)!)            }
        })
        
       
        //Pushback values from database when event occurs
        ref.child("semScore").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                self.semScore.append(Double(rest.value as! String)!)
            }
        })
        
    }
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.myTextField1.delegate = self
        setDatabase()
        
        
        
        
        /* ref.child("Date1").observeSingleEvent(of: .value, with: { (snapshot) in
         for child in snapshot.children {
         let snap = child as! DataSnapshot
         //let key = snap.key
         let value = snap.value
         //print("key = \(key)  value = \(value!)")
         self.months.append(value as! String)
         }
         })
         */
        
        
        LineChartView.delegate = self as? ChartViewDelegate
        LineChartView.noDataText = "Waiting for Data."
        LineChartView.chartDescription?.text = ""
        
        //Delay to wait for database to finish appending arrays
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            
            //legend design
            let legend = self.LineChartView.legend
            legend.enabled = true
            legend.yOffset = 8.0;
            legend.xOffset = 15.0;
            legend.yEntrySpace = 0.0;
            legend.horizontalAlignment = .right
            legend.verticalAlignment = .top
            legend.orientation = .vertical
            legend.drawInside = true
            
            
            //X-axis design
            let xaxis = self.LineChartView.xAxis
            xaxis.valueFormatter = self.axisFormatDelegate
            //xaxis.drawGridLinesEnabled = true
            xaxis.labelPosition = .bottom
            xaxis.centerAxisLabelsEnabled = false
            xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
            xaxis.granularity = 1
            xaxis.labelRotationAngle=CGFloat(-80.0)
            
            let leftAxisFormatter = NumberFormatter()
            leftAxisFormatter.maximumFractionDigits = 1
            
            //Y-axis design
            let yaxis = self.LineChartView.leftAxis
            yaxis.spaceTop = 0.30
            yaxis.axisMinimum = 0
            yaxis.axisMaximum = 100
            yaxis.drawGridLinesEnabled = false
            
            self.LineChartView.rightAxis.enabled = true
            let yaxisRight = self.LineChartView.rightAxis
            yaxisRight.spaceTop = 0.30
            yaxisRight.axisMinimum = 0
            yaxisRight.axisMaximum = 100
            
            
            self.setChart()
        }
        //setChart()
        
        
        
    }
    
    //Setting up chart data insertion
    func setChart() {
        
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        
        //Inserting chart values
        for i in 0..<self.months.count {
            
            let dataEntry = ChartDataEntry(x: Double(i) , y:self.self.epScore[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = ChartDataEntry(x: Double(i) , y: self.self.semScore[i])
            dataEntries1.append(dataEntry1)
            
            
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Episodic")
        let chartDataSet1 = LineChartDataSet(values: dataEntries1, label: "Semantic")
        
        let dataSets: [LineChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        
        let chartData = LineChartData(dataSets: dataSets)
        
        //Alert chart, data has been changed
        LineChartView.notifyDataSetChanged()
        LineChartView.data = chartData
        
        //background color
        LineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        LineChartView.animate(xAxisDuration: CATransaction.animationDuration(), yAxisDuration:CATransaction.animationDuration(), easingOption: .linear)
        
        
        
        
    }
    

}

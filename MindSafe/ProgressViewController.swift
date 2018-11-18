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

UIViewController {
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var handler:DatabaseHandle!
    var handler2:DatabaseHandle!
    
   
    
    @IBOutlet weak var LineChartView: LineChartView!
    
    @IBOutlet weak var myTextField1: UITextField!
    
    
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
    
    //Update button to refresh the chart view
    @IBAction func updateChart(_ sender: Any) {
        self.viewDidLoad()
        self.viewWillAppear(true)
        self.months.removeAll()
        self.epScore.removeAll()
        self.semScore.removeAll()
        
    }
    
    //Initialized empty arrays for chart axis
    var months:[String] = []
    var epScore:[Double] = []
    var semScore:[Double] = []
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        LineChartView.noDataText = "You need to provide data for the chart."
        LineChartView.chartDescription?.text = ""
        
        
        //legend design
        let legend = LineChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        //X-axis design
        let xaxis = LineChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        //xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1
        xaxis.labelRotationAngle=CGFloat(-80.0)

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        //Y-axis design
        let yaxis = LineChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.axisMaximum = 100
        yaxis.drawGridLinesEnabled = false
        
        LineChartView.rightAxis.enabled = true
        let yaxisRight = LineChartView.rightAxis
        yaxisRight.spaceTop = 0.35
        yaxisRight.axisMinimum = 0
        yaxisRight.axisMaximum = 100
        
        setChart()
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
        LineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    
}
}

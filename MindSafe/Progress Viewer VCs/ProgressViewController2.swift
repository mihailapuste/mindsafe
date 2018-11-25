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
import CoreData
import FirebaseDatabase

class ProgressViewController2:

UIViewController, UITextFieldDelegate {
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //var reminders: [Reminders] = [] //reminders.count
    
    var ref: DatabaseReference!
    var handler:DatabaseHandle!
    var remDates:[String] = []
    var missRem:[Double] = []
    var taskA = false
    var taskB = false
    

    
    @IBOutlet weak var LineChartView: LineChartView!
    
    
//
//    @IBOutlet weak var myTextField1: UITextField!
//
    
    @IBOutlet weak var myTextField2: UITextField!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
 
    
    @IBAction func savButt(_ sender: Any) {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat="dd.MM.yyyy"
        let result = formater.string(from: date)
    
//        When textfield is entered with a number
        if myTextField2.text != ""
        {
            ref?.child("remDatesV5").childByAutoId().setValue(result)
            ref?.child("missRemV5").childByAutoId().setValue(myTextField2.text)
            myTextField2.text = ""

        }
    }

    
    
    @IBAction func updateChart(_ sender: Any) {
        self.taskA = false
        self.taskB = false
        self.remDates.removeAll()
        self.missRem.removeAll()
        self.viewDidLoad()
        self.viewWillAppear(true)
        
    }
    
    
    
 
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    func setDatabase(){
        //reference to database
        ref=Database.database().reference()
        
        //Pushback values from database when event occurs
        ref.child("remDatesV5").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                
                self.remDates.append(rest.value as! String)
                
            }
            self.taskA = true
            self.checkResult()
        })
        
        //Pushback values from database when event occurs
        ref.child("missRemV5").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                
                self.missRem.append(Double(rest.value as! String)!)
                
            }
            self.taskB = true
            self.checkResult()
        }
        )
    }

    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.myTextField2.delegate = self
        setDatabase()
        
        
        LineChartView.delegate = self as? ChartViewDelegate
        LineChartView.noDataText = "Waiting for Data."
        LineChartView.chartDescription?.text = ""

//        Delay to wait for database to finish appending arrays

        
    
    
        
    }
    
    func setDesign()
    {
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
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.remDates)
        xaxis.granularity = 1
        xaxis.labelRotationAngle=CGFloat(-80.0)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 0
        
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
        yaxisRight.axisMaximum = 100    }
    
    //Setting up chart data insertion
    func setChart() {
        
        var dataEntries: [ChartDataEntry] = []
       
        
        //Inserting chart values
        for i in 0..<self.remDates.count {
            
            let dataEntry = ChartDataEntry(x: Double(i) , y:self.self.missRem[i])
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Total Notification Ignored")
       
        
        let dataSets: [LineChartDataSet] = [chartDataSet]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        
        let chartData = LineChartData(dataSets: dataSets)
        
        //Alert chart, data has been changed
        LineChartView.notifyDataSetChanged()
        LineChartView.data = chartData
        //Scrollable Chart View
        LineChartView.setVisibleXRangeMaximum(4)
        LineChartView.moveViewToX(Double(remDates.count - 5))
        
        //background color
        LineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        LineChartView.animate(xAxisDuration: CATransaction.animationDuration(), yAxisDuration:CATransaction.animationDuration(), easingOption: .linear)
        
        
        
    }
    
    func checkResult(){
        if taskA && taskB{
            setDesign()
            setChart()
        }
    }
}

//
//  Episodic.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-14.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
//  Worked on by Bob Liu


import UIKit
import Charts
import FirebaseDatabase

class EpisodicProgViewController:

UIViewController, UITextFieldDelegate {

    
    var ref: DatabaseReference!
    var handler:DatabaseHandle!
    //Initialized empty arrays for chart axis
    var months:[String] = []
    var epScore:[Double] = []
    var semScore:[Double] = []
    var taskA = false
    var taskB = false
   
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var LineChartView: LineChartView!
    

    @IBOutlet weak var myTextField1: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // action send email when button pressed
    @IBAction func savBut1(_ sender: Any) {
        if myTextField1.text != ""
        {
          emailImage()
          myTextField1.text = ""
            
        }
        
        //let date = Date()
        //let formater = DateFormatter()
        //formater.dateFormat="dd.MM.yyyy"
        //let result = formater.string(from: date)
        
        //When textfield is entered with a number
        //if myTextField1.text != ""
        //{
         //   ref?.child("Date1V5").childByAutoId().setValue(result)
          //  ref?.child("epScoreV5").childByAutoId().setValue(myTextField1.text)
         //   myTextField1.text = ""
        //}
    }
    
    
    
    
    
    
    // action updating chart from firebase
    @IBAction func updateChart(_ sender: Any) {
        self.taskA=false
        self.taskB=false
        self.months.removeAll()
        self.epScore.removeAll()
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    
    //Update button to refresh the chart view
    weak var axisFormatDelegate: IAxisValueFormatter?
    
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
        self.myTextField1.delegate = self
        
        
        //call database setup
        self.setDatabase()
       
    
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
        
        self.LineChartView.delegate = self as? ChartViewDelegate
        self.LineChartView.noDataText = "Waiting for Data."
        self.LineChartView.chartDescription?.text = ""
        
        
    }
    
    
    func setDesign(){
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
        
    }
    
    //Setting up chart data insertion
    func setChart() {
        
        var dataEntries: [ChartDataEntry] = []
        
        //Inserting chart values
        for i in 0..<self.months.count {
            let dataEntry = ChartDataEntry(x: Double(i) , y:self.self.epScore[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Episodic")
        
        let dataSets: [LineChartDataSet] = [chartDataSet]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let chartData = LineChartData(dataSets: dataSets)
        
        //Alert chart, data has been changed
        LineChartView.notifyDataSetChanged()
        LineChartView.data = chartData
        
        //Scrollable ChartView
        if(months.count > 4){
        LineChartView.setVisibleXRangeMaximum(4)
        LineChartView.moveViewToX(Double(months.count - 5))
        }
        
        //background color
        LineChartView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        //chart animation
        LineChartView.animate(xAxisDuration: CATransaction.animationDuration(), yAxisDuration:CATransaction.animationDuration(), easingOption: .linear)
        
    }
    
    //Email capabilities
    func emailImage(){
//        let image = self.LineChartView.getChartImage(transparent: false)
//        
//        let smtpSession = MCOSMTPSession()
//        smtpSession.hostname = "smtp.gmail.com"
//        smtpSession.username = "mindsafe14@gmail.com"
//        smtpSession.password = "mgroup14"
//        smtpSession.port = 465
//        smtpSession.authType = MCOAuthType.saslPlain
//        smtpSession.connectionType = MCOConnectionType.TLS
//        smtpSession.connectionLogger = {(connectionID, type, data) in
//            if data != nil {
//                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
//                    NSLog("Connectionlogger: \(string)")
//                }
//            }
//        }
//        
//        let builder = MCOMessageBuilder()
//        builder.header.to = [MCOAddress(displayName: "Caretaker", mailbox: myTextField1.text)]
//        builder.header.from = MCOAddress(displayName: "MINDSAFEAPP", mailbox: "mindsafe14@gmail.com")
//        builder.header.subject = "IMAGE SENT"
//        builder.htmlBody = "IMAGE SEND TEST!"
//        
//        
//        var dataImage: NSData?
//        dataImage = UIImageJPEGRepresentation(image!, 0.6)! as NSData
//        let attachment = MCOAttachment()
//        attachment.mimeType =  "image/jpg"
//        attachment.filename = "EpisodicScoreChart.jpg"
//        attachment.data = dataImage! as Data
//        builder.addAttachment(attachment)
//        
//        let rfc822Data = builder.data()
//        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
//        sendOperation?.start { (error) -> Void in
//            if (error != nil) {
//                NSLog("Error sending email: \(String(describing: error))")
//            } else {
//                NSLog("Successfully sent email!")
//            }
//        }
    }
    
    //waiting for database retrieval to complete
    func checkResult(){
        if taskA && taskB {
            setDesign()
            setChart()
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
            //})
        }
    }
}

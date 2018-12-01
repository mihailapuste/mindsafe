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
import Accelerate
import CoreData

class EpisodicProgViewController:
    
UIViewController, UITextFieldDelegate {
    
    var contacts: [Contacts] = [];
    
    var ref: DatabaseReference!
    var handler:DatabaseHandle!
    //Initialized empty arrays for chart axis
    var months:[String] = []
    var epScore:[Double] = []
    var taskA = false
    var taskB = false
    
    
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var LineChartView: LineChartView!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // action send email when button pressed
    @IBAction func savBut1(_ sender: Any) {
      
        emailAllContacts()
     
        
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
        getData() // gets contacts
      
        
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
        yaxis.axisMaximum = 120
        yaxis.drawGridLinesEnabled = false
        
        self.LineChartView.rightAxis.enabled = true
        let yaxisRight = self.LineChartView.rightAxis
        yaxisRight.spaceTop = 0.30
        yaxisRight.axisMinimum = 0
        yaxisRight.axisMaximum = 120
        
        
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
        //chartDataSet.axisDependency=LineChartView.rightAxis.axisDependency
        
        let dataSets: [LineChartDataSet] = [chartDataSet]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let chartData = LineChartData(dataSets: dataSets)
        
        //Alert chart, data has been changed
        LineChartView.notifyDataSetChanged()
        LineChartView.data = chartData
        
        //Scrollable ChartView
        if(months.count > 10){
            LineChartView.setVisibleXRangeMaximum(9)
            LineChartView.moveViewToX(Double(months.count - 10))
            print(months.count)
        }
        
        //background color
        LineChartView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        //chart animation
        LineChartView.animate(xAxisDuration: CATransaction.animationDuration(), yAxisDuration:CATransaction.animationDuration(), easingOption: .linear)
        
    }
    
    
    //func data analysis
    func calcData(){
        var dataHigh = 0.0
        var dataLow = 0.0
        var dataTotal = 0.0
        var dataAvg = 0.0
        var dataMedian = 0.0
        dataLow = epScore.min()!
        dataHigh = epScore.max()!
        
        for i in 0..<self.epScore.count{
            dataTotal = dataTotal + epScore[i]
        }
        
        dataAvg = dataTotal/Double(epScore.count)
        
        //Highest Score
        let High = ChartLimitLine(limit: dataHigh, label: "Max")
        High.lineColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        LineChartView.rightAxis.addLimitLine(High)
        //High.lineDashLengths = [5.0]
        
        //Lowest Score
        let Low = ChartLimitLine(limit: dataLow, label: "Min")
        Low.lineColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        LineChartView.rightAxis.addLimitLine(Low)
        Low.lineDashLengths = [5.0]
        
        //Average Score
        let Avg = ChartLimitLine(limit: dataAvg, label: "Avg")
        Avg.lineColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
        LineChartView.rightAxis.addLimitLine(Avg)
        Avg.lineDashLengths = [5.0]
        
        
        //Median Score
        let sorted = epScore.sorted()
        if sorted.count % 2 == 0{
            dataMedian = (sorted[(sorted.count/2)]+sorted[((sorted.count/2)-1)])/2
        }
        else {
            dataMedian = (sorted[(sorted.count-1)/2])
        }
        let Median = ChartLimitLine(limit: dataMedian, label: "Median")
        Median.lineColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        LineChartView.rightAxis.addLimitLine(Median)
        Median.lineDashLengths = [5.0]
        
        var mn = 0.0
        var sddev = 0.0
        vDSP_normalizeD(epScore, 1, nil, 1, &mn, &sddev, vDSP_Length(epScore.count))
        sddev *= sqrt(Double(epScore.count)/Double(epScore.count-1))
        
        //standard Deviation
        let stdDev = ChartLimitLine(limit: sddev, label: "Std Deviation")
        stdDev.lineColor = UIColor(red: 200/255, green: 50/255, blue: 200/255, alpha: 1)
        LineChartView.rightAxis.addLimitLine(stdDev)
        stdDev.lineDashLengths = [5.0]
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Emailing functions
    
    func emailAllContacts(){
        let firstName = UserDefaults.standard.object(forKey: "firstName") as! String
        let lastName = UserDefaults.standard.object(forKey: "lastName") as! String
        
        if firstName == "" {
            showAlert(title: "No name!", message: "Set user first name in personal information.")
            return
        }
        
        
        if lastName == "" {
            showAlert(title: "No name!", message: "Set user last name in personal information.")
            return
        }
        
        
        let subject = "Episodic Activity Progress from \(firstName) \(lastName)"
        let body = "Here are my latest activity scores!"
        for contact in contacts {
            let name = "\(contact.firstName!) \(contact.lastName!)"
            let email = contact.contactEmail!
            print("email to \(contact.firstName!) \(contact.lastName!) - \(contact.contactEmail!)")
            emailImage(displayName: name, toEmail: email, subject: subject, body: body)
        }
        
    }
    
    // Retrieves comtacts from coredata
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext;
        
        do
        {
            contacts = try context.fetch(Contacts.fetchRequest())
        }
        catch
        {
            print("fetch failed!")
        }
        
    }
    
    //Email capabilities
    func emailImage(displayName: String, toEmail: String, subject: String, body: String){
                let image = self.LineChartView.getChartImage(transparent: false)
        
                let smtpSession = MCOSMTPSession()
                smtpSession.hostname = "smtp.gmail.com"
                smtpSession.username = "mindsafe14@gmail.com"
                smtpSession.password = "mgroup14"
                smtpSession.port = 465
                smtpSession.authType = MCOAuthType.saslPlain
                smtpSession.connectionType = MCOConnectionType.TLS
                smtpSession.connectionLogger = {(connectionID, type, data) in
                    if data != nil {
                        if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            NSLog("Connectionlogger: \(string)")
                        }
                    }
                }
        
                let builder = MCOMessageBuilder()
                builder.header.to = [MCOAddress(displayName: displayName, mailbox: toEmail)]
                builder.header.from = MCOAddress(displayName: "MINDSAFEAPP", mailbox: "mindsafe14@gmail.com")
                builder.header.subject = subject
                builder.htmlBody = body
        
        
                var dataImage: NSData?
                dataImage = UIImageJPEGRepresentation(image!, 0.6)! as NSData
                let attachment = MCOAttachment()
                attachment.mimeType =  "image/jpg"
                attachment.filename = "EpisodicScoreChart.jpg"
                attachment.data = dataImage! as Data
                builder.addAttachment(attachment)
        
                let rfc822Data = builder.data()
                let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
                sendOperation?.start { (error) -> Void in
                    if (error != nil) {
                        NSLog("Error sending email: \(String(describing: error))")
                    } else {
                        NSLog("Successfully sent email!")
                    }
                }
    }
    
    //waiting for database retrieval to complete
    func checkResult(){
        if taskA && taskB {
            setDesign()
            if(epScore.count > 0){
                calcData()
                setChart()
            }
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            
            //})
        }
        
    }
}

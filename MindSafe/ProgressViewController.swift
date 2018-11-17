

import UIKit
import Charts
import FirebaseDatabase

class ProgressViewController:

UIViewController {
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var handler:DatabaseHandle!
    var handler2:DatabaseHandle!
    
    var array:[String] = []
    
    
    @IBOutlet weak var LineChartView: LineChartView!
    
    @IBOutlet weak var myTextField1: UITextField!
    
    
    @IBAction func savBut1(_ sender: Any) {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat="dd.MM.yyyy"
        let result = formater.string(from: date)
        
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
    
    
    @IBAction func updateChart(_ sender: Any) {
        self.viewDidLoad()
        self.viewWillAppear(true)
        self.months.removeAll()
        self.epScore.removeAll()
        self.semScore.removeAll()
        
    }
    
    var months:[String] = []
    //var months = ["1.11.2018", "2.11.2018", "3.11.2018", "4.11.2018", "5.11.2018"]
    
    var epScore:[Double] = []
    var semScore:[Double] = []
    //var epScore = [20.0, 4.0, 6.0, 3.0, 12.0]
    //var semScore = [10.0, 14.0, 60.0, 13.0, 2.0]
    weak var axisFormatDelegate: IAxisValueFormatter?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
         ref=Database.database().reference()
        
        
        ref.child("Date1").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
            
            self.months.append(rest.value as! String)            }
        })
        
        
        ref.child("epScore").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                print(rest.value!)
                
            self.epScore.append(Double(rest.value as! String)!)            }
        })
        
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
        
        ref.child("epScore").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                //let key = snap.key
                let value = snap.value
                //print("key = \(key)  value = \(value!)")
                self.epScore.append(Double(value as! String)!)
            }
        })
        
        ref.child("semScore").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                //let key = snap.key
                let value = snap.value
                //print("key = \(key)  value = \(value!)")
                self.semScore.append(Double(value as! String)!)
            }
        })
        
        
        */
        
        /*ref2=Database.database().reference()
        handler = ref?.child("Date1").observe(.childAdded, with: {(snapshot) in
            if let data = snapshot.value as? String
            {
                self.months.append(data)
               
                
            }
        })
        
        handler2 = ref2?.child("epScore").observe(.childAdded, with: {(snapshot) in
            if let data1 = snapshot.value as? Double
            {
                self.epScore.append(data1)
                self.viewDidLoad()
                self.viewWillAppear(true)
            }
        })
        
        */
        
        
        
        
        
        //ref.child("Date1").observe(.value, with: { snapshot in
          //  if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
           //     for value in snapshots {
                    //print("Child: ", value)
            //    }
           // }
            
       // })
        


        LineChartView.delegate = self as? ChartViewDelegate
        LineChartView.noDataText = "You need to provide data for the chart."
        LineChartView.chartDescription?.text = ""
        
        
        //legend
        let legend = LineChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        
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
    
    func setChart() {
        LineChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        
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
        
        
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        
        
    
        LineChartView.notifyDataSetChanged()
        
        LineChartView.data = chartData
        
    
        
        
        //background color
        LineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
        LineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    
}
}

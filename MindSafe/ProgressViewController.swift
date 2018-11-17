

import UIKit
import Charts
import FirebaseDatabase

class ProgressViewController:

UIViewController {
    
   
    @IBOutlet weak var LineChartView: LineChartView!
    
 
    
    let months = ["2018-11-1", "2018-11-2", "2018-11-3", "2018-11-4", "2018-11-5"]
    let epScore = [20.0, 4.0, 6.0, 3.0, 12.0]
    let semScore = [10.0, 14.0, 60.0, 13.0, 2.0]
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
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



import UIKit
import Charts

class ProgressViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.noDataText = "No data to display"
        // Do any additional setup after loading the view, typically from a nib.
    }


}


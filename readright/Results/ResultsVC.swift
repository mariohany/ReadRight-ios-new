//
//  ResultsVC.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import Foundation
import UIKit


let THERAPY_PAGINATION_COUNT = 10
let VISUAL_PAGINATION_COUNT = 12

class ResultsVC: UIViewController {
    
    let HISTORY_THERAPY_VIEW = 4
    let HISTORY_READING_VIEW = 3
    let HISTORY_FIELD_VIEW = 2
    let HISTORY_NEGLECT_VIEW = 1
    let HISTORY_DESKTOP_VIEW = 0
    @IBOutlet weak var HistoryFieldTableResults: UITableView!
    @IBOutlet weak var HistoryTherapyTableResults: UITableView!
    @IBOutlet weak var SegmentNavigation: UISegmentedControl!
    @IBOutlet weak var ChartView: CustomView!
    @IBOutlet weak var TherapyHistoryView: CustomView!
    @IBOutlet weak var FieldHistoryView: CustomView!
    @IBOutlet weak var TherapyTotalDurationLabel: UILabel!
    @IBOutlet weak var chartYLabel: UILabel!
    @IBOutlet weak var VisualFieldResultContainer: UIView!
    @IBOutlet weak var VisualFieldDateLabel: UILabel!
    var visualFieldResultCanvas: FieldResultView = .fromNib()
    var chart: SimpleBarChart = SimpleBarChart()
    var values: [CGFloat] = []
    var texts: [String] = []
    var xLabels: [String] = []
    var barColors: [UIColor] = [UIColor(red: 119/255.0, green: 156/255.0, blue: 89/255.0, alpha: 1)]
    var currentBarColor: Int = 0
    let viewModel = ResultsViewModel()
    var visualFieldsResult:[NetworkModels.HistoryItem] = []
    var therapyHistoryList: [NetworkModels.HistoryItem] = []
    var therapyCurrentFrom:Int = 0
    var therapyCurrentTo:Int = 0
    var visualCurrentFrom:Int = 0
    var visualCurrentTo:Int = 0
    var isTherapyFull = false
    var isTherapyLoaded = false
    var isVisualFull = false
    var isVisualLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeResults()
        observeLoading()
        observeError()
        
        self.HistoryTherapyTableResults.delegate = self
        self.HistoryTherapyTableResults.dataSource = self
        
        self.HistoryFieldTableResults.delegate = self
        self.HistoryFieldTableResults.dataSource = self
        
        self.VisualFieldResultContainer.layer.borderColor = CGColor(red: 00, green: 00, blue: 00, alpha: 1)
        self.VisualFieldResultContainer.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "النتائج"
        self.navigationController?.navigationBar.topItem?.title = "النتائج"
        
        isTherapyFull = false
        isTherapyLoaded = false

        isVisualFull = false
        isVisualLoaded = false
        
        handleSelectedView()
    }
    
    func observeResults() {
        viewModel.searchResult.asObservable().subscribe { res in
            if let res = res.element, let list = res {
                if(list.count == 0){
                    Helpers.handleErrorMessages(message: Constants.HISTORY_EMPTY)
                }
                self.chart.removeFromSuperview()
                let values = list.map {CGFloat($0.reactionTime ?? 0)}
                let texts = list.map{String(describing: $0.reactionTime!)}
                let labels = list.map{Helpers.convertDate($0.date)}
                
                self.loadChartBarWithValues(value: values, text: texts, labels: labels, incrementalValue: self.getIncrementalStepFromArray(array: values), containerView: self.ChartView)
                self.chart.reloadData()
            }
        }
        
        viewModel.readingResult.asObservable().subscribe { res in
            if let res = res.element, let list = res {
                if(list.count == 0){
                    Helpers.handleErrorMessages(message: Constants.HISTORY_EMPTY)
                }
                self.chart.removeFromSuperview()
                let values = list.map {CGFloat($0.readingSpeed ?? 0)}
                let texts = list.map{String(describing: $0.readingSpeed!)}
                let labels = list.map{Helpers.convertDate($0.createdAt)}
                
                self.loadChartBarWithValues(value: values, text: texts, labels: labels, incrementalValue: self.getIncrementalStepFromArray(array: values), containerView: self.ChartView)
                
                self.chart.reloadData()
            }
        }
        
        viewModel.neglectResult.asObservable().subscribe { res in
            if let res = res.element, let list = res {
                if(list.count == 0){
                    Helpers.handleErrorMessages(message: Constants.HISTORY_EMPTY)
                }
                self.chart.removeFromSuperview()
                self.loadChartBarWithValues(value: list.map { $0.Score ?? 0.0 }, text: list.map{ String(describing: $0.Score) }, labels: list.map{ $0.date ?? "" }, incrementalValue: self.getIncrementalStepFromArray(array: list.map { $0.Score ?? 0.0 }), containerView: self.ChartView)
                self.chart.reloadData()
            }
        }
        
        viewModel.therapyResult.asObservable().subscribe { result in
            if let res = result.element {
                if let list = res?.History {
                    if (list.count > 0) {
                        self.isTherapyLoaded = false
                    } else {
                        self.isTherapyLoaded = true
                        self.isTherapyFull = true
                        if(self.therapyCurrentFrom == 0){
                            Helpers.handleErrorMessages(message: Constants.HISTORY_EMPTY)
                        }
                    }
                    
                    self.therapyHistoryList = list
                    self.TherapyTotalDurationLabel.text = String(describing: res?.TherapySpentTime)
                    self.HistoryTherapyTableResults.reloadData()
                }
            }
        }
        
        viewModel.visualResult.asObservable().subscribe { res in
            if let res = res.element, let list = res {
                if (list.count > 0) {
                    self.isVisualLoaded = false
                } else {
                    self.isVisualLoaded = true
                    self.isVisualFull = true
                    if(self.visualCurrentFrom == 0){
                        Helpers.handleErrorMessages(message: Constants.HISTORY_EMPTY)
                    }
                }
                
                self.visualFieldsResult = list
                self.HistoryFieldTableResults.reloadData()
                if(list.count > 0){
                    let selectedCellIndexPath = IndexPath(row: 0, section: 0)
                    self.HistoryFieldTableResults.selectRow(at: selectedCellIndexPath, animated: true, scrollPosition: .none)
                }
            }
        }
    }
    
    func observeLoading() {
        viewModel.isLoading.asObservable().subscribe { status in
            if let state = status.element, state == true{
                self.view.showActivityView()
            }else {
                self.view.hideActivityView()
            }
        }
    }
    
    func observeError() {
        viewModel.error.asObservable().subscribe { status in
            if let error = status.element, !error.isEmpty {
                Helpers.handleErrorMessages(message: error)
            }
            print(status)
        }
    }
    
    @IBAction func ChangeTab(_ sender: UISegmentedControl) {
        handleSelectedView()
    }
    
    private func handleSelectedView(){
        let selectedSegment = self.SegmentNavigation.selectedSegmentIndex
        if (selectedSegment == HISTORY_DESKTOP_VIEW) {
            self.FieldHistoryView.isHidden = true
            self.TherapyHistoryView.isHidden = true
            self.ChartView.isHidden = false
            self.chartYLabel.text = "وقت رد الفعل"
            viewModel.getSearchTaskHistory()
        }
        else if (selectedSegment == HISTORY_NEGLECT_VIEW) {
            self.FieldHistoryView.isHidden = true
            self.TherapyHistoryView.isHidden = true
            self.ChartView.isHidden = false
            self.chartYLabel.text = "النتيجة (٪)"
            viewModel.getNeglectFieldHistory()
        }
        else if (selectedSegment == HISTORY_FIELD_VIEW) {
            self.ChartView.isHidden = true
            self.TherapyHistoryView.isHidden = true
            self.FieldHistoryView.isHidden = false
            visualFieldsResult = []
            visualCurrentFrom = 0
            visualCurrentTo = VISUAL_PAGINATION_COUNT - 1
            viewModel.visualFrom = visualCurrentFrom
            viewModel.visualTo = visualCurrentTo
            viewModel.getVisualFieldHistory()
        }
        else if (selectedSegment == HISTORY_READING_VIEW) {
            self.FieldHistoryView.isHidden = true
            self.TherapyHistoryView.isHidden = true
            self.ChartView.isHidden = false
            self.chartYLabel.text = "كلمة في الدقيقة"
            viewModel.getReadingHistory()
        }
        else if (selectedSegment == HISTORY_THERAPY_VIEW) {
            self.ChartView.isHidden = true
            self.FieldHistoryView.isHidden = true
            self.TherapyHistoryView.isHidden = false
            therapyHistoryList = []
            therapyCurrentFrom = 0
            therapyCurrentTo = THERAPY_PAGINATION_COUNT - 1
            viewModel.therapyFrom = therapyCurrentFrom
            viewModel.therapyTo = therapyCurrentTo
            viewModel.getTherapyHistory()
        }
    }
    
    private func loadMoreTherapyHistory() {
        isTherapyLoaded = true
        therapyCurrentFrom = therapyCurrentTo + 1
        therapyCurrentTo = therapyCurrentFrom + THERAPY_PAGINATION_COUNT - 1
        viewModel.therapyFrom = therapyCurrentFrom
        viewModel.therapyTo = therapyCurrentTo
        viewModel.getTherapyHistory()
    }

    private func loadMoreVisualHistory() {
        isVisualLoaded = true
        visualCurrentFrom = visualCurrentTo + 1
        visualCurrentTo = visualCurrentFrom + VISUAL_PAGINATION_COUNT - 1
        viewModel.visualFrom = visualCurrentFrom
        viewModel.visualTo = visualCurrentTo
        viewModel.getVisualFieldHistory()
    }
}

extension ResultsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedSegment = self.SegmentNavigation.selectedSegmentIndex
        if(tableView == self.HistoryTherapyTableResults && selectedSegment == HISTORY_THERAPY_VIEW ) {
            return therapyHistoryList.count
        } else if(tableView == self.HistoryFieldTableResults  && selectedSegment == HISTORY_FIELD_VIEW ) {
            return visualFieldsResult.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedSegment = self.SegmentNavigation.selectedSegmentIndex
        var cell:UITableViewCell = UITableViewCell()
        switch (selectedSegment) {
            case HISTORY_THERAPY_VIEW: //Therapy results
            do {
                cell = TherapyHistoryCell.init(style: .default, reuseIdentifier: "TherapyHistoryCell")
                (cell as? TherapyHistoryCell)?.HistoryDate.text =  therapyHistoryList[indexPath.row].date
                (cell as? TherapyHistoryCell)?.HistoryTime.text =  therapyHistoryList[indexPath.row].TherapyTime
                (cell as? TherapyHistoryCell)?.HistoryTitle.text = therapyHistoryList[indexPath.row].Title
//                if (!isTherapyFull && indexPath.row >= therapyHistoryList.count-2 && !isTherapyLoaded) {
//                    loadMoreTherapyHistory()
//                }
                break
            }
            case HISTORY_FIELD_VIEW: //Field Test results
            do {
                cell = FieldHistoryCell.init(style: .default, reuseIdentifier: "FieldHistoryCell")
                (cell as? FieldHistoryCell)?.FieldDate?.text = Helpers.convertDate(visualFieldsResult[indexPath.row].date)
                let bgView: UIView = UIView()
                bgView.backgroundColor = UIColor(red: 221.0/255.0, green: 134.0/255.0, blue: 89.0/255.0, alpha: 1)
                (cell as? FieldHistoryCell)?.selectedBackgroundView = bgView
//                if (!isVisualFull && indexPath.row >= visualFieldsResult.count-2 && !isVisualLoaded) {
//                    loadMoreVisualHistory()
//                }
                break
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSegment = self.SegmentNavigation.selectedSegmentIndex
        if(selectedSegment == HISTORY_FIELD_VIEW){
            visualFieldResultCanvas = .fromNib()
            let dotesValues = visualFieldsResult[indexPath.row].NodeHits
            visualFieldResultCanvas.renderResultViewWithAlldots(results: dotesValues ?? [])
            visualFieldResultCanvas.removeFromSuperview()
            self.VisualFieldResultContainer.addSubview(visualFieldResultCanvas)
            self.VisualFieldDateLabel.text = visualFieldsResult[indexPath.row].date
        }
    }
}

extension ResultsVC: SimpleBarChartDataSource, SimpleBarChartDelegate {
    
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        return UInt(values.count)
    }
    
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: UInt) -> CGFloat {
        return values[Int(index)]
    }
    
    func barChart(_ barChart: SimpleBarChart!, textForBarAt index: UInt) -> String! {
        return texts[Int(index)]
    }
    
    func barChart(_ barChart: SimpleBarChart!, colorForBarAt index: UInt) -> UIColor! {
        return barColors[Int(currentBarColor)]
    }
    
    func barChart(_ barChart: SimpleBarChart!, xLabelForBarAt index: UInt) -> String! {
        return xLabels[Int(index)]
    }
    
    
    private func loadChartBarWithValues(value:[CGFloat], text:[String], labels:[String], incrementalValue:Int, containerView:UIView){
        values = value
        texts = text
        xLabels = labels
        barColors = [UIColor(red: 119/255.0, green: 156/255.0, blue: 89/255.0, alpha: 1)]
        currentBarColor = 0
        
        let chartFrame = CGRect(x: 30.0, y: 60.0, width: 950.0, height: 470.0)
        chart = SimpleBarChart(frame: chartFrame)
        //_chart.center                     = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        chart.delegate = self
        chart.dataSource = self
        chart.barShadowOffset = CGSize(width: 2.0, height: 1.0)
        chart.animationDuration = 1.0
//        chart.barShadowColor = UIColor(ciColor: .gray)
        chart.barShadowAlpha = 0.0
        chart.barShadowRadius = 1.0
        chart.barWidth = 60.0
        
        chart.xLabelType = SimpleBarChartXLabelTypeHorizontal
        chart.incrementValue = incrementalValue
        chart.barTextType = SimpleBarChartBarTextTypeTop
        chart.barTextColor = UIColor(ciColor: .white)
        chart.gridColor = UIColor(ciColor: .gray)
        
        containerView.addSubview(chart)
    }
    
    func getIncrementalStepFromArray(array: [CGFloat]) -> Int {
        let max: Int = Int(array.max() ?? 0.0)
        return round_up_to_max_pow10(n: max)
    }
    
    func round_up_to_max_pow10(n:Int) -> Int {
        var tmp = n
        var i:Float = 0
        tmp/=10
        while (tmp > 0) {
            i+=1
            tmp/=10
        }
        let step:Int = Int(pow(10,i) / 2)
        return (step != 0) ? step : 1
    }
}

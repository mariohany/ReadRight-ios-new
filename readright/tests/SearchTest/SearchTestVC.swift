//
//  SearchTestVC.swift
//  readright
//
//  Created by user225703 on 7/17/22.
//

import Foundation

let TRIAL_FOR_LEAVING = 3
let NUMBER_OF_TARGETS = 16

class SearchTestVC: UIViewController {
    @IBOutlet weak private var CanvasView: UIView!
    @IBOutlet weak private var Timelabel: UILabel!
    @IBOutlet weak private var RoundNumber: UILabel!
    @IBOutlet weak private var AverageRTLabel: UILabel!
    @IBOutlet weak private var PassedRoundsLabel: UILabel!
    @IBOutlet weak private var ResultView: CustomView!
    @IBOutlet weak private var TestView: CustomView!
    
    var currentCanvasView:SearchCanvasView = .fromNib()
    var currentTargetTag:Int = 6
    var targetsDirections:[Int] = Array(repeating: 0, count: NUMBER_OF_TARGETS)
    var targetsDirectionsBackup:[Int] = Array(repeating: 0, count: NUMBER_OF_TARGETS)
    var directionsResult:[Int] = Array(repeating: 0, count: NUMBER_OF_TARGETS+1)
    var result:[Float] = Array(repeating: 0, count: NUMBER_OF_TARGETS+1)
    var currentRound:Int = 1
    var practicalRound:Int = 0
    var isFinished:Bool = false
    let viewModel: SearchTestViewModel = SearchTestViewModel()
    var updatingTimer:Timer?
    var totalTime:Int = 60 //intially is 1 min (60s)
    var unAttended:Int = 0
    var passedRounds:Int = 0
    var testDuration:Float = 0
    var stopWatch:Date?
    var stopWatchForWholeTest:Date?
    
    var leftTrial:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeSuccess()
        observeLoading()
        observeError()
        let backImage = UIImage(named:"TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image:backImage, style:.plain, target:self, action:#selector(customBackBtn))
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.TestView.isHidden = false
        self.ResultView.isHidden = true
        
        currentCanvasView.parent = self
        currentCanvasView.numberOfTargets = NUMBER_OF_TARGETS
        self.CanvasView.addSubview(currentCanvasView)
        
        self.RoundNumber.text =  Helpers.arabicCharacter(englishNumber: currentRound)
        
        let x = arc4random_uniform(2)
        leftTrial = x == 1

        seedRandomLeftOrRight()
        let alert = CustomAlertView(title:"الهدف الخاص بك هو: ", messageImage:UIImage(named:SearchTestHelper.getItemName(currentTargetTag))!, buttonTitle:"أنا مستعد", delegate:self, tag:0)
        alert?.show()
        
        currentCanvasView.randamizeItems(leftTrial!, currentTargetTag)
    }
    
    func observeSuccess(){
        viewModel.result.subscribe { status in
            if let msg = status.element, msg != ""{
                self.isFinished = true
                self.showResults()
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
            if let error = status.element, error != "" {
                Helpers.handleErrorMessages(message: error)
            }
            print(status)
        }
    }
    
    func popToTestsController(){
        if let destinationViewController = self.navigationController?.viewControllers.filter({$0 is ReadingVC}).first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }
    
    @objc func customBackBtn(){
        if(isFinished == true){
            self.popToTestsController()
        }else{
            let alert = CustomAlertView(title:"هل تريد إلغاء الاختبار ؟", buttonOKTitle:"نعم، إلغي الاختبار", buttonCancelTitle:"عودة للاختبار", delegate:self, tag:3)
            alert?.show()
        }
    }


    func getNextTarget(){
        repeat {
            currentTargetTag = Int(arc4random_uniform(UInt32(NUMBER_OF_TARGETS)))
        }while (targetsDirections[currentTargetTag] == 0)
    }

    @objc func doNextRound(){
        currentRound+=1
        updatingTimer?.invalidate()
        
        if(currentRound > 17){
            testDuration = -1 * Float(stopWatchForWholeTest!.timeIntervalSinceNow)
            self.handleViewModel()
        }else{
            self.Timelabel.text = "01:00"
            totalTime = 60
            self.getNextTarget()
            
            self.RoundNumber.text =  Helpers.arabicCharacter(englishNumber: currentRound)
            
            let alert = CustomAlertView(title:"الهدف الخاص بك هو: ", messageImage:UIImage(named:SearchTestHelper.getItemName(currentTargetTag))!, buttonTitle:"أنا مستعد", delegate:self, tag:0)
            alert?.show()
            
            let isLeft:Bool = targetsDirections[currentTargetTag] == -1 ? false : true
            currentCanvasView.randamizeItems(isLeft, currentTargetTag)
            targetsDirections[currentTargetTag] = 0
        }
        
    }


    func handleViewModel(){
        var itemTimes:[Double] = Array.init(repeating: 0.0, count: NUMBER_OF_TARGETS + 1)
        
        for i in 0 ..< NUMBER_OF_TARGETS {
            let item = result[i].myRound()
            itemTimes[i] = item
        }
        viewModel.vst_score = passedRounds + practicalRound
        
        let duration = testDuration.myRound()
        viewModel.vst_duration = duration
        
        viewModel.submitResult(directionsResult, itemTimes)
    }

    func showResults(){
        //to the result
        self.TestView.isHidden = true
        self.ResultView.isHidden = false
        
        self.PassedRoundsLabel.text = String(format:"%d",passedRounds + practicalRound)
        self.AverageRTLabel.text = String(format:"%.2f", averageRT())
    }


    func averageRT()->Float{
        var averageRT:Float = 0.0
        for i in 0 ..< NUMBER_OF_TARGETS {
            averageRT = averageRT + result[i]
        }
        averageRT = averageRT / Float((passedRounds - practicalRound))
        return averageRT
    }

    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار البحث النظري"
    }
    
    
    @objc func updateTimeLabel(_ timer:Timer) {
        totalTime-=1
        
        self.Timelabel.text = String(format: "%02d:%02d", totalTime/60, totalTime % 60)
        if(totalTime == 0){
            //hanlde finish of test
            updatingTimer?.invalidate()
            updatingTimer = nil
            
            unAttended+=1
            if(unAttended >= TRIAL_FOR_LEAVING){
                updatingTimer?.invalidate()
                self.popToTestsController()
            }
            
            directionsResult[currentRound - 1] = targetsDirectionsBackup[currentTargetTag]
            self.doNextRound()
        }
        
        
    }

    func seedRandomLeftOrRight() {
        var index:Int = 0
        //Generate right randoms
        while (index < NUMBER_OF_TARGETS/2){
            let tempTag = Int(arc4random_uniform(UInt32(NUMBER_OF_TARGETS)))
            if(targetsDirections[tempTag] == 0){
                targetsDirections[tempTag] = -1 // right positions
                targetsDirectionsBackup[tempTag] = -1
                index+=1
            }
        }
        
        //Generatre left randoms
        while (index < NUMBER_OF_TARGETS){
            let tempTag = Int(arc4random_uniform(UInt32(NUMBER_OF_TARGETS)))
            if(targetsDirections[tempTag] == 0){
                targetsDirections[tempTag] = 1 // left positions
                targetsDirectionsBackup[tempTag] = 1
                index+=1
            }
        }
    }

    func doItAllRight(){
        targetsDirections[0] = -1
        targetsDirections[1] = -1
        targetsDirections[2] = -1
        targetsDirections[3] = -1
        targetsDirections[4] = -1
        targetsDirections[5] = -1
        targetsDirections[6] = -1
        targetsDirections[7] = -1
        targetsDirections[8] = -1
        targetsDirections[9] = -1
        targetsDirections[10] = -1
        targetsDirections[11] = -1
        targetsDirections[12] = -1
        targetsDirections[13] = -1
        targetsDirections[14] = -1
        targetsDirections[15] = -1
    }

    @IBAction private func FinishedBtn() {
        self.popToTestsController()
    }
}

extension SearchTestVC : CustomAlertViewDelegate {
    func didSelectButtonAtIndex(tag: Int, index: Int) {
        switch (tag) {
            case 0: // Showing target alert
                if (index == 0) {
                    updatingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(updateTimeLabel), userInfo: nil, repeats: true)
                    stopWatch = Date()
                    if(currentRound == 1){
                        stopWatchForWholeTest = Date()
                    }
                }
                break
                
            case   3: // Existing alert
                if (index == 0) {
                    //back to tests dashboard
                    updatingTimer?.invalidate()
                    self.popToTestsController()
                }
                break
        default:
            break
        }
    }
}

extension SearchTestVC: SearchCanvasViewDelegate {
    func didSelectItemWithTag(_ tag: Int) {
        if(currentTargetTag == tag){
            if(!currentCanvasView.isSelectetTarget(tag)){
                if(currentRound == 1){
                    directionsResult[0] = leftTrial == true ? 1: -1
                }else{
                    directionsResult[currentRound - 1] = targetsDirectionsBackup[currentTargetTag]
                }
                result[currentRound - 1] = Float(-1 * stopWatch!.timeIntervalSinceNow)

                passedRounds+=1
                
                currentCanvasView.doCorrectItem(tag)
                
                self.perform(#selector(doNextRound), with: nil, afterDelay: 1)
            }
        }else{
            currentCanvasView.doWrongItem(tag)
        }
    }
}

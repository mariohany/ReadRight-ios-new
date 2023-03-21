//
//  VisualNeglectTestVC.swift
//  readright
//
//  Created by user225703 on 7/21/22.
//

import Foundation

let TEST_DURATION:Int = 300

class VisualNeglectTestVC: UIViewController {
    
    @IBOutlet weak private var TimeLabel:UILabel!
    @IBOutlet weak private var Container:UIView!
    let viewModel:NeglectViewModel = NeglectViewModel()
    var updatingTimer:Timer?
    var totalTime:Int = 300 //intially is 5 min (300s)
        
    var uniqueTargetsCount:Int = 0 //unique targets
    var allTargetsVisitsCount:Int = 0 //unique and revisited targets
    
    var uniqueDistractorsCount:Int = 0 //unique distractors
    var allDistractorsVisitsCount:Int = 0//unique and revisited distractors
    
    var targetRevisitsCount:Int = 0 //targets revisits only
    var distractorsRevisitsCount:Int = 0//distractors revisits only
    
    var allClicksCount:Int = 0
    
    var vnt_X:Int = 0
    var vnt_Y:Int = 0
    
    var numRevisitsLeft:Int = 0
    var numRevisitsRight:Int = 0
    var numTargetsMissedLeft:Int = 0
    var numTargetsMissedRight:Int = 0
    
    var testCanvas:NeglectCanvasView? = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeSuccess()
        observeLoading()
        observeError()
        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(customBackBtn))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        //initializations
        uniqueDistractorsCount = 0
        uniqueTargetsCount = 0
        allDistractorsVisitsCount = 0
        allTargetsVisitsCount = 0
        distractorsRevisitsCount = 0
        targetRevisitsCount = 0
        allClicksCount = 0
    
        vnt_X = 0
        vnt_Y = 0
    
        numRevisitsLeft = 0
        numRevisitsRight = 0
    
        numTargetsMissedLeft = 0
        numTargetsMissedRight = 0
        
        let alert = CustomAlertView(title:"الهدف الخاص بك هو: ",
                                    messageImage:UIImage(named:"BigUpperCircle")!,
                                    buttonTitle:"أنا مستعد",
                                    delegate:self,
                                    tag:0)
        alert?.show()
        
        testCanvas = .fromNib()
        testCanvas?.parent = self
        
        self.Container.addSubview(testCanvas!)
        testCanvas?.randmoizeItems()
    }

    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار الإهمال البصري"
    }
    
    func observeSuccess(){
        viewModel.result.subscribe { status in
            if let msg = status.element, msg != ""{
                self.performSegue(withIdentifier: "FinishNeglectTest", sender: self)
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
    
    @objc func customBackBtn() {
        let alert = CustomAlertView(title:"هل تريد إلغاء الاختبار ؟",
                                                          buttonOKTitle:"نعم، إلغي الاختبار",
                                                      buttonCancelTitle:"عودة للاختبار",
                                                               delegate:self,
                                                                    tag:3)
        alert?.show()
    }

    func didMiss(TargetLeft leftMissedTargetsCount: Int, andRight rightMissedTargetsCount:Int) {
        numTargetsMissedLeft = leftMissedTargetsCount
        numTargetsMissedRight = rightMissedTargetsCount
//        NSLog(@"%@:%i\n%@:%i", @"left", leftMissedTargetsCount, @"right", rightMissedTargetsCount);
    }
    
    @objc func updateTimeLabel(_ timer:Timer) {
        totalTime-=1
        
        self.TimeLabel.text = String(format:"%02d:%02d", totalTime/60, totalTime % 60)
        if(totalTime == 0){
            //hanlde finish of test
            updatingTimer?.invalidate()
            updatingTimer = nil
            self.handleNeglectViewModel()
        }
    }

    func handleNeglectViewModel() {
        viewModel.vnt_score = Int((Float(uniqueTargetsCount) / Float(Constants.NUMBER_NEGLECT_TARGETS)) * 100)
        
        viewModel.vnt_targets = Int((Float(allTargetsVisitsCount) / Float(Constants.NUMBER_NEGLECT_TARGETS)) * 100)
        viewModel.vnt_distractors = Int((Float(allDistractorsVisitsCount) / Float(Constants.NUMBER_NEGLECT_DISTRACTORS)) * 100)
        viewModel.vnt_revisits = targetRevisitsCount + distractorsRevisitsCount
        viewModel.vnt_duration = TEST_DURATION - totalTime
        if(allClicksCount  == 0){
            allClicksCount = 1
        }
        vnt_X /= allClicksCount
        vnt_Y /= allClicksCount
        viewModel.vnt_X = vnt_X
        viewModel.vnt_Y = vnt_Y
        
        viewModel.numTotalTargets = (allTargetsVisitsCount)
        viewModel.numTotalDistractors = (allDistractorsVisitsCount)
        viewModel.numTargetsMissed = (Constants.NUMBER_NEGLECT_TARGETS - uniqueTargetsCount)
        viewModel.numTargetsMissedLeft = (numTargetsMissedLeft)
        viewModel.numTargetsMissedRight = (numTargetsMissedRight)
        viewModel.numRevisits = (targetRevisitsCount + distractorsRevisitsCount)
        viewModel.numRevisitsLeft = (numRevisitsLeft)
        viewModel.numRevisitsRight = (numRevisitsRight)
        viewModel.elements = testCanvas?.getElements() ?? []
        viewModel.meanX = (vnt_X)
        viewModel.meanY = (vnt_Y)
        viewModel.hitsPath = testCanvas?.getHitsPath() ?? []
        
        viewModel.submitResult()
    }

    @IBAction private func amDone() {
        let alert = CustomAlertView(title:"هل أنت متأكد أنك أنتهيت ؟",
                                  buttonOKTitle:"نعم، أعرض النتائج",
                                  buttonCancelTitle:"عودة للاختبار",
                                  delegate:self,
                                  tag:1)
        alert?.show()
    }
    
    
}

extension VisualNeglectTestVC : CustomAlertViewDelegate {
    func didSelectButtonAtIndex(tag: Int, index: Int) {
        switch (tag) {
            case 0: // Showing target alert
                if (index == 0) {
                    updatingTimer =  Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(updateTimeLabel), userInfo:nil, repeats:true)
                }
                break
                
            case 1: // Finishing alert
                if (index == 0) {
                    //show the new controller
                    updatingTimer?.invalidate()
                    updatingTimer = nil
                    
                    self.handleNeglectViewModel()
                }
                break
            
            case 3: // Existing alert
                if (index == 0) {
                    //back to tests dashboard
                    self.popToTestsController()
                }
                break
            
        default:
            break
        }
    }
    
    func popToTestsController(){
        if let destinationViewController = self.navigationController?.viewControllers.filter({$0 is ReadingVC}).first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }

}

extension VisualNeglectTestVC: NeglectCanvasViewDelegate {
    func didSelectNewTarget(x: Int, y: Int) {
        self.allClicksCount+=1
        uniqueTargetsCount+=1
        allTargetsVisitsCount+=1
        vnt_X += x
        vnt_Y += y
    }
    
    func didSelectDistractorTarget(x: Int, y: Int) {
        allClicksCount+=1
        uniqueDistractorsCount+=1
        allDistractorsVisitsCount+=1
        vnt_X += x
        vnt_Y += y
    }
    
    func didSelectRevisitedDistractorTarget(x: Int, y: Int) {
        allClicksCount+=1
        allDistractorsVisitsCount+=1
        distractorsRevisitsCount+=1
        vnt_X += x
        vnt_Y += y
        
        if (Int(x) < Int(testCanvas!.frame.size.width / 2)) {
            numRevisitsLeft+=1
        } else {
            numRevisitsRight+=1
        }
    }
    
    func didSelectVisitedTarget(x: Int, y: Int) {
        allClicksCount+=1
        allTargetsVisitsCount+=1
        targetRevisitsCount+=1
        vnt_X += x
        vnt_Y += y
        
        
        if (Int(x) < Int(testCanvas!.frame.size.width / 2)) {
            numRevisitsLeft+=1
        } else {
            numRevisitsRight+=1
        }
    }
    
    func didMissTarget(leftMissedTargetsCount: Int, rightMissedTargetsCount: Int) {
        numTargetsMissedLeft = leftMissedTargetsCount
        numTargetsMissedRight = rightMissedTargetsCount
    }
    
}

extension VisualNeglectTestVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FinishNeglectTest"){
            // Get reference to the destination view controller
            let vc = segue.destination as? ResultNeglectTestVC
            vc?.ResultScore = Int((Float(uniqueTargetsCount) / Float(Constants.NUMBER_NEGLECT_TARGETS)) * 100)
        }
    }
}

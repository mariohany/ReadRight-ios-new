//
//  ADLTestVC.swift
//  readright
//
//  Created by user225703 on 7/13/22.
//

import Foundation
import UIKit

let NUMBER_OF_ACTIVITIES = 6

class ADLTestVC: UIViewController, CustomAlertViewDelegate {
    
    
    
    @IBOutlet weak private var Activity0: UIButton!
    @IBOutlet weak private var Activity1: UIButton!
    @IBOutlet weak private var Activity2: UIButton!
    @IBOutlet weak private var Activity3: UIButton!
    @IBOutlet weak private var Activity4: UIButton!
    @IBOutlet weak private var Activity5: UIButton!
    @IBOutlet weak private var ButtonsView: UIView!
    @IBOutlet weak private var ResultView: UIView!
    @IBOutlet weak private var RateView: UIView!
    @IBOutlet weak private var ActivityLabel: UILabel!
    @IBOutlet weak private var PercentageLabel: UILabel!
    @IBOutlet weak private var ResultActivityLabel: UILabel!
    @IBOutlet weak private var Slider: CustomSlider!
    @IBOutlet weak private var Gauge: UIImageView!
    @IBOutlet weak private var Thumb: DragableImageView!
    @IBOutlet weak private var FinishedBtn: UIButton!
    @IBOutlet weak private var TestView: CustomView!
    @IBOutlet weak private var TestEndView: CustomView!
    @IBOutlet weak private var ActivityLabel0: UILabel!
    @IBOutlet weak private var ActivityLabel1: UILabel!
    @IBOutlet weak private var ActivityLabel2: UILabel!
    @IBOutlet weak private var ActivityLabel3: UILabel!
    @IBOutlet weak private var ActivityLabel4: UILabel!
    @IBOutlet weak private var ActivityLabel5: UILabel!
    @IBOutlet weak private var ActivityImage0: UIImageView!
    @IBOutlet weak private var ActivityImage1: UIImageView!
    @IBOutlet weak private var ActivityImage2: UIImageView!
    @IBOutlet weak private var ActivityImage3: UIImageView!
    @IBOutlet weak private var ActivityImage4: UIImageView!
    @IBOutlet weak private var ActivityImage5: UIImageView!
    let viewModel = ADLViewModel()
    var currentActivity:Int = 0
    var percentages:[Int] = []
    var visited:[Int] = []
    var activitiesNames:[String] = []
    var activitiesQuestions:[String] = []
    var orangeImages:[String] = []
    var greenImages:[String] = []
    var largeOrangeImages:[String] = []
    var largeGreenImages:[String] = []
    var testFinished:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeSuccess()
        observeLoading()
        observeError()
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(customBackBtn))
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        loadPreDefinedData()
        
        self.RateView.isHidden = true
        self.ResultView.isHidden = true
        self.ButtonsView.isHidden = false
        
        self.Slider.gauge = self.Gauge
        self.Slider.thumb = self.Thumb
        self.Thumb.maxLimit  = Float(self.Gauge.frame.size.height)
        self.Thumb.minLimit = 0
        
        self.FinishedBtn.isEnabled = false
        
        currentActivity = 0
    }
    
    func observeSuccess(){
        viewModel.result.subscribe { status in
//            if let msg = status.element, msg != ""{
                self.popToTestsController()
//            }
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

    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "تقييم أنشطة الحياه اليومية"
    }

func tickClockWise(){
    UIView.animate(withDuration: 2.0) {
        self.swipPlaces()
    } completion: { finished in
        self.handleActivitiesAlpha()
        self.handleNextScenario()
    }
}

func swipPlaces(){
    var temp1Frame:CGRect?
    var temp2Frame:CGRect?
    
    temp1Frame = self.Activity0.frame
    self.Activity0.frame = self.Activity5.frame
    
    temp2Frame = self.Activity1.frame
    self.Activity1.frame = temp1Frame!
    
    temp1Frame = self.Activity2.frame
    self.Activity2.frame = temp2Frame!
    
    temp2Frame = self.Activity3.frame
    self.Activity3.frame = temp1Frame!
    
    temp1Frame = self.Activity4.frame
    self.Activity4.frame = temp2Frame!
    
    temp2Frame = self.Activity5.frame
    self.Activity5.frame = temp1Frame!
    
    currentActivity = (currentActivity + 1) % NUMBER_OF_ACTIVITIES
}

    func handleActivitiesAlpha(){
        for i in 0 ..< NUMBER_OF_ACTIVITIES {
            let ActivityButton:UIButton? = value(forKey: String(format: "%d", "Activity", i)) as? UIButton
            if ( i == currentActivity){
                ActivityButton?.alpha = 1.0
            }else{
                ActivityButton?.alpha = 0.4
            }
        }
    }


    @IBAction private func ActivityPressed(_ sender:UIButton) {
        let tag = sender.tag
        if((visited[tag] != 0) && testFinished){
            var numberOFTurns:Int = tag - currentActivity
            if(numberOFTurns < 0){
                numberOFTurns += NUMBER_OF_ACTIVITIES
            }
            for _ in 0 ..< numberOFTurns {
                tickClockWise()
            }
        }
    }

func showCurrentResult(){
    self.ButtonsView.isHidden = true
    self.RateView.isHidden = true
    self.ResultView.isHidden = false
    self.ResultActivityLabel.text = activitiesNames[currentActivity]
    self.PercentageLabel.text = String(format: "%d%%", percentages[currentActivity])
    if(percentages[currentActivity] == 0){
        //Green color
        self.PercentageLabel.textColor = UIColor(red: 119/255.0, green: 156.0/255.0, blue: 89.0/255.0, alpha: 1)
    }else{
        //Orange color 217,109,55
        self.PercentageLabel.textColor = UIColor(red: 207/255.0, green: 97.0/255.0, blue: 49.0/255.0, alpha: 1)
    }
}
    
    
func handleNextScenario(){
    if((visited[currentActivity]) != 0){
        showCurrentResult()
    }else{
        self.RateView.isHidden = true
        self.ButtonsView.isHidden = false
    }
}

@IBAction private func noBtn() {
    //set the current activity to green
    let currentActivityButton:UIButton? = value(forKey: String(format: "Activity%d", currentActivity)) as? UIButton
    currentActivityButton?.setImage(UIImage(named: greenImages[currentActivity]), for: .normal)
    
    visited[currentActivity] = 1
    if((currentActivity == NUMBER_OF_ACTIVITIES - 1) && !testFinished){
        testFinished = true
        self.FinishedBtn.isEnabled = true
    }
    self.tickClockWise()
}

    @IBAction private func yesBtn() {
        self.ButtonsView.isHidden = true
        self.Slider.setThumbPosition(0)
        self.RateView.isHidden = false
        
        self.ActivityLabel.text = activitiesQuestions[currentActivity]
    }

    @IBAction private func moreInfoBtn() {
    
    }

    @IBAction private func saveBtn() {
        percentages[currentActivity] = Int(self.Slider.getThumbPercentage())
        //set the current to orange
        let currentActivityButton:UIButton? = value(forKey: String(format: "Activity%d", currentActivity)) as? UIButton
        
        if(percentages[currentActivity] > 0){
            currentActivityButton?.setImage(UIImage(named: orangeImages[currentActivity]), for: .normal)
        }else{
            currentActivityButton?.setImage(UIImage(named: greenImages[currentActivity]), for: .normal)
        }
        visited[currentActivity] = 1
        if((currentActivity == NUMBER_OF_ACTIVITIES - 1) && !testFinished){
            testFinished = true
            self.FinishedBtn.isEnabled = true
        }
        
        if((visited[(currentActivity + 1) % NUMBER_OF_ACTIVITIES] == 0)){
            self.tickClockWise()
        }else{
            self.showCurrentResult()
        }
    }

    func performTestEnd(){
        for i in 0 ..< NUMBER_OF_ACTIVITIES {
            let currentActivityImageView:UIImageView? = value(forKey: String(format: "ActivityImage%d", i)) as? UIImageView
            let currentActivityLabel:UILabel? = value(forKey: String(format: "ActivityLabel%d", i)) as? UILabel
            currentActivityLabel?.text = String(format: "%d%%", percentages[i])
            
            if(percentages[i] > 0){ //Orange stuff
                currentActivityLabel?.textColor = UIColor(red:217/255.0, green:109.0/255.0, blue:55.0/255.0,alpha:1)
                currentActivityImageView?.image = UIImage(named:largeOrangeImages[i])
            }else{//Green stuff
                currentActivityLabel?.textColor = UIColor(red:119/255.0, green:156.0/255.0, blue:89.0/255.0, alpha:1)
                currentActivityImageView?.image = UIImage(named:largeGreenImages[i])
            }
        }
        
    //    self.TestView.hidden = true;
    //    self.TestEndView.hidden = false;
        let alert = CustomAlertView.init(title: "هل أنت متأكد من إنهاء الاختبار ؟", buttonOKTitle: "نعم، الاختبار التالى", buttonCancelTitle: "عودة للاختبار", delegate: self, tag: 2)
        alert?.show()

    }

    @IBAction private func cancelBtn() {
        self.RateView.isHidden = true
        self.ButtonsView.isHidden = false
    }

    @IBAction private func changeBtn() {
        self.ResultView.isHidden = true
        self.ButtonsView.isHidden = true
        self.RateView.isHidden = false
        self.ActivityLabel.text = activitiesQuestions[currentActivity]
        self.Slider.setThumbPosition(Int32(percentages[currentActivity]))
    }

    @IBAction private func veFinishedBtn() {
        if(testFinished){
            self.performTestEnd()
        }
    }

    @IBAction private func pressChangeBk() {
        self.TestView.isHidden = false
        self.TestEndView.isHidden = true
    }

    @IBAction private func startNextTestBtn() {
        handleViewModel()
    }

    func handleViewModel(){
        viewModel.adl_FindingThings = percentages[0]
        viewModel.adl_driving = percentages[1]
        viewModel.adl_Hygiene = percentages[2]
        viewModel.adl_ReadingNews = percentages[3]
        viewModel.adl_ReadingBooks = percentages[4]
        viewModel.adl_EnjoyReading = percentages[5]
        viewModel.submitResult()
    }

    func loadPreDefinedData() {
        activitiesNames[0] = "العثور علي الأشياء في بيتك"
        activitiesNames[1] = "قيادة السيارات"
        activitiesNames[2] = "النظافة الشخصية"
        activitiesNames[3] = "قراءة الصحف"
        activitiesNames[4] = "قراءة الكتب"
        activitiesNames[5] = "الاستمتاع بالقراءة"
        
        activitiesQuestions[0] = "ما هي قدرتك على العثور على الأشياء في بيتك ؟"
        activitiesQuestions[1] = "ما هو مدى صعوبتك لعدم ضل الطرق أثناء القيادة ؟"
        activitiesQuestions[2] = "يرجي تقييم مدى صعوبتك في مجال النظافة الشخصية ؟"
        activitiesQuestions[3] = "ما هو مدى صعوبتك لفهم قصة كاملة في الصحف ؟"
        activitiesQuestions[4] = "ما هي قدرتك على قراءة كتاب كامل ؟"
        activitiesQuestions[5] = "ما هي قدرتك على الاستمتاع بالقراءة عموما ؟"
        
        orangeImages[0] = "OrangeFinding"
        orangeImages[1] = "OrangeDriving"
        orangeImages[2] = "OrangeHygiene"
        orangeImages[3] = "OrangeNews"
        orangeImages[4] = "OrangeBook"
        orangeImages[5] = "OrangeEReading"
        
        greenImages[0] = "GreenFinding"
        greenImages[1] = "GreenDrive"
        greenImages[2] = "GreenHygiene"
        greenImages[3] = "GreenNews"
        greenImages[4] = "GreenBook"
        greenImages[5] = "GreenEReading"
        
        largeGreenImages[0] = "BigGreenFinding"
        largeGreenImages[1] = "BigGreenDriving"
        largeGreenImages[2] = "BigGreenHygiene"
        largeGreenImages[3] = "BigGreenNews"
        largeGreenImages[4] = "BigGreenBook"
        largeGreenImages[5] = "BigGreenEReading"
        
        largeOrangeImages[0] = "BigOrangeFinding"
        largeOrangeImages[1] = "BigOrangeDriving"
        largeOrangeImages[2] = "BigOrangeHygiene"
        largeOrangeImages[3] = "BigOrangeNews"
        largeOrangeImages[4] = "BigOrangeBook"
        largeOrangeImages[5] = "BigOrangeReading"
    }
    
    func popToTestsController(){
        self.navigationController?.popViewController(animated: true)
    }

    
    func didSelectButtonAtIndex(tag: Int, index: Int) {
        switch (tag){
        case 2:// Existing alert
            if(index == 0){
                self.handleViewModel()
            }
            break
        case 3:// Existing alert
            if (index == 0) {
                //back to tests dashboard
                self.popToTestsController()
            }
        default:
            break
        }
    }

    @objc func customBackBtn(){
        let alert = CustomAlertView.init(title: "هل تريد إلغاء الاختبار ؟", buttonOKTitle: "نعم، إلغي الاختبار", buttonCancelTitle: "عودة للاختبار", delegate: self, tag: 3)
        alert?.show()
    }

}

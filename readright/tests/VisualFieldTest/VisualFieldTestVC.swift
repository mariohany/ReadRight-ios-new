//
//  VisualFieldTestVC.swift
//  readright
//
//  Created by user225703 on 7/12/22.
//

import Foundation
import UIKit

let NUMBER_OF_QUESTIONS = 36
let NUMBER_OF_DOTS_IN_CIRCLE = 4
let NUMBER_OF_MODES = 9

class VisualFieldTestVC : UIViewController, CustomAlertViewDelegate {
    @IBOutlet weak private var RoundNumber:UILabel!
    @IBOutlet weak private var CanvasContainer:UIView!
    @IBOutlet weak private var ResultContainer:UIView!
    @IBOutlet weak private var AnswersView:CustomView!
    @IBOutlet weak private var ResultView:CustomView!
    @IBOutlet weak private var TestView:CustomView!
    @IBOutlet weak private var AnswerBtn0:UIButton!
    @IBOutlet weak private var AnswerBtn1:UIButton!
    @IBOutlet weak private var AnswerBtn2:UIButton!
    @IBOutlet weak private var AnswerBtn3:UIButton!
    
    var results:[Int] = Array(repeating: 0, count: NUMBER_OF_QUESTIONS)
    var dotsHitted:[Int] = Array(repeating: 0, count: 16)
    var answersIDs:[Int] = Array(repeating: 0, count: NUMBER_OF_QUESTIONS)
    var answersFlow:[Int] = Array(repeating: 0, count: NUMBER_OF_QUESTIONS)
    var answers:[String] = Array(repeating: "", count: NUMBER_OF_QUESTIONS)
    var currentQuestion:Int = 0
    var currentStage:Int = 0
    var isFinished:Bool = false
    var canvasView:VisualCanvasView = .fromNib()
    var resultView:FieldResultView = .fromNib()
    var stopWatch:Date = Date()
    var vftDuration:Float = 0.0
    let viewModel:VisualFieldViewModel = VisualFieldViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFinished = false
        observeSuccess()
        observeLoading()
        observeError()
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(customBackBtn))

        self.navigationItem.leftBarButtonItem = barButtonItem
        
        fillReadyAnswers()
        self.TestView.isHidden = false
        self.AnswersView.isHidden = true
        
        canvasView.layer.borderColor = UIColor.black.cgColor
        canvasView.layer.borderWidth = 1.0

        
        CanvasContainer.addSubview(canvasView)
        currentQuestion = -1
        currentStage = 1
        repeat{
            currentQuestion = Int(arc4random_uniform(UInt32(NUMBER_OF_QUESTIONS)))
        }while((results[currentQuestion]) != 0)

        stopWatch = Date()
        answersFlow[currentStage - 1] = currentQuestion
        performQuestion()
        // Do any additional setup after loading the view.
    }
    
    func observeSuccess(){
        viewModel.result.subscribe { status in
            if let msg = status.element, msg != ""{
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
    
    
    func performQuestion(){
        self.TestView.isHidden = false
        self.AnswersView.isHidden = true
        results[currentQuestion] = 1
      
        self.RoundNumber.text =  Helpers.arabicCharacter(englishNumber: currentStage)
      
      
   //    self.RoundNumber.text =[ NSString stringWithFormat:@"%d", currentQuestion];
       
        canvasView.performQuestion(questionNo: currentQuestion) { finished in
            self.TestView.isHidden = true
            self.AnswersView.isHidden = false
            self.showAnswers()
        }
   }

   func showAnswers(){
       let answersImagesNames = answers[currentQuestion].split(separator: ",")
       let correctAnswer:String = String(format:"answer%d_%d", (currentQuestion / 9 + 1) , (currentQuestion % 9 + 1))
       
       self.AnswerBtn0.setImage(UIImage(named: String(answersImagesNames[0])), for: .normal)
       self.AnswerBtn1.setImage(UIImage(named: String(answersImagesNames[1])), for: .normal)
       self.AnswerBtn2.setImage(UIImage(named: String(answersImagesNames[2])), for: .normal)
       self.AnswerBtn3.setImage(UIImage(named: String(answersImagesNames[3])), for: .normal)
       
       self.AnswerBtn0.tag = 1
       self.AnswerBtn1.tag = 2
       self.AnswerBtn2.tag = 3
       self.AnswerBtn3.tag = 4
    
       
       if(correctAnswer == answersImagesNames[0]){
            self.AnswerBtn0.tag = -1
       }else if(correctAnswer == answersImagesNames[1]){
            self.AnswerBtn1.tag = -2
       }else if(correctAnswer == answersImagesNames[2]){
            self.AnswerBtn2.tag = -3
       }else if(correctAnswer == answersImagesNames[3]){
            self.AnswerBtn3.tag = -4
       }
       
   }

   func showResults(){       
       resultView.layer.borderColor = UIColor.black.cgColor
       resultView.layer.borderWidth = 1.0
       
       
       self.ResultContainer.addSubview(resultView)
       self.TestView.isHidden = true
       self.AnswersView.isHidden = true
       self.ResultView.isHidden = false

       var dotsHittedMutableArray:[Int] = []
       for i in 0..<Constants.NUMBER_OF_VISIUAL_FIELD_DOTS {
           dotsHittedMutableArray.insert(dotsHitted[i], at: i)
       }

       resultView.renderResultViewWithAlldots(results: dotsHittedMutableArray)
   }
    
    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار المجال البصري"
    }
    
    @IBAction private func doRepeatTest(){
        performQuestion()
    }
    
    @IBAction private func chooseAnswerBtn(_ sender:UIButton){
        var isCorrect:Int = sender.tag
       
       //Good answer
       //I am putting here 2 to differentiate between chosen and answered questions
       if(isCorrect < 0){
           results[currentQuestion] = 2
           isCorrect *= -1
           self.updateHittedDots()
       }
       answersIDs[currentQuestion] = isCorrect - 1
       currentStage += 1
       if(currentStage > NUMBER_OF_QUESTIONS){//It was the last question
           isFinished = true
           vftDuration = Float(-1 * stopWatch.timeIntervalSinceNow)           
           viewModel.vfTDuration = vftDuration
           viewModel.submitResult(answersIDs, answersFlow, dotsHitted)
       }else{
           repeat{
               currentQuestion = Int(arc4random_uniform(UInt32(NUMBER_OF_QUESTIONS)))
           } while(results[currentQuestion] != 0)
           
            answersFlow[currentStage - 1] = currentQuestion
            self.performQuestion()
       }
    }
    
    @IBAction private func nextTestBtn(){
        self.popToTestsController()
    }
    
    func popToTestsController(){
        if let destinationViewController = self.navigationController?.viewControllers.filter({$0 is ReadingVC}).first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }


    func fillReadyAnswers() {
        answers[0] = "answer1_1,answer1_3,answer1_2,other"
        answers[1] = "answer1_2,answer1_6,Q,answer1_7"
        answers[2] = "Q,answer1_8,answer1_9,answer1_3"
        answers[3] = "answer1_8,answer1_4,Q,answer1_6"
        answers[4] = "answer1_7,Q,answer1_9,answer1_5"
        answers[5] = "answer1_8,answer1_7,answer1_6,Q"
        answers[6] = "Q,answer1_7,answer1_9,answer1_6"
        answers[7] = "answer1_6,Q,answer1_9,answer1_8"
        answers[8] = "answer1_7,answer1_8,answer1_9,Q"
        answers[9] = "answer2_3,answer2_1,other,answer2_2"
        answers[10] = "answer2_6,answer2_2,answer2_7,Q"
        answers[11] = "answer2_8,Q,answer2_3,answer2_9"
        answers[12] = "answer2_4,answer2_8,answer2_6,Q"
        answers[13] = "Q,answer2_7,answer2_5,answer2_9"
        answers[14] = "answer2_7,answer2_8,Q,answer2_6"
        answers[15] = "answer2_7,Q,answer2_6,answer2_9"
        answers[16] = "Q,answer2_6,answer2_8,answer2_9"
        answers[17] = "answer2_8,answer2_7,Q,answer2_9"
        answers[18] = "answer3_2,other,answer3_1,answer3_3"
        answers[19] = "Q,answer3_7,answer3_2,answer3_6"
        answers[20] = "answer3_9,answer3_3,Q,answer3_8"
        answers[21] = "Q,answer3_6,answer3_8,answer3_4"
        answers[22] = "answer3_9,answer3_5,answer3_7,Q"
        answers[23] = "answer3_6,Q,answer3_8,answer3_7"
        answers[24] = "answer3_9,answer3_6,Q,answer3_7"
        answers[25] = "answer3_9,answer3_8,answer3_6,Q"
        answers[26] = "answer3_9,Q,answer3_7,answer3_8"
        answers[27] = "other,answer4_2,answer4_3,answer4_1"
        answers[28] = "answer4_7,Q,answer4_6,answer4_2"
        answers[29] = "answer4_3,answer4_9,answer4_8,Q"
        answers[30] = "answer4_6,Q,answer4_4,answer4_8"
        answers[31] = "answer4_5,answer4_9,Q,answer4_7"
        answers[32] = "Q,answer4_6,answer4_7,answer4_8"
        answers[33] = "answer4_6,answer4_9,answer4_7,Q"
        answers[34] = "answer4_8,answer4_9,Q,answer4_6"
        answers[35] = "Q,answer4_9,answer4_8,answer4_7"
    }
    
    func didSelectButtonAtIndex(tag:Int, index:Int){
        switch (tag) {
            case   3: // Existing alert
                if (index == 0) {
                    //back to tests dashboard
                    self.popToTestsController()
                }
                break
        default:
            break
        }
    }
    
    @objc func customBackBtn(){
        if(isFinished){
            self.popToTestsController()
        } else {
            let alert = CustomAlertView.init(title: "هل تريد إلغاء الاختبار ؟", buttonOKTitle: "نعم، إلغي الاختبار", buttonCancelTitle: "عودة للاختبار", delegate: self, tag: 3)
            alert?.show()
        }
    }
    
    func updateHittedDots(){
        let circle:Int = currentQuestion / NUMBER_OF_MODES
        let mode:Int = currentQuestion % NUMBER_OF_MODES
        let circleStart:Int = circle * NUMBER_OF_DOTS_IN_CIRCLE
        if(mode == 0){
            dotsHitted[circleStart]+=1
            dotsHitted[circleStart+1]+=1
            dotsHitted[circleStart+2]+=1
            dotsHitted[circleStart+3]+=1
        }else if(mode <= 2){
            let offset:Int = 2 * (mode/2)
            dotsHitted[circleStart + offset]+=1
            dotsHitted[circleStart + offset + 1]+=1
        }else if(mode <= 4){
            let offset:Int = ((mode - 2)/2)
            dotsHitted[circleStart + offset]+=1
            dotsHitted[circleStart + offset + 2]+=1
        }else if(mode <= 8){
            dotsHitted[circleStart + mode - 5]+=1
        }
    }
}

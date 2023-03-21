//
//  ReadingTestVC.swift
//  readright
//
//  Created by concarsadmin-mh on 03/05/2022.
//

import AVFoundation
import Foundation
import UIKit


let NUMBER_OF_STORIES = 12
let NUMBER_OF_CHOICES = 3

class ReadingTestVC: UIViewController{
    @IBOutlet weak private var ResultView: CustomView!
    @IBOutlet weak private var StoryView: CustomView!
    @IBOutlet weak private var QuestionView: CustomView!
    @IBOutlet weak private var CurrentQuestionLabel: UILabel!
    @IBOutlet weak private var CurrentStoryLabel: UILabel!
    @IBOutlet weak private var ResultAverageSecs: UILabel!
    @IBOutlet weak private var ResultAverageWords: UILabel!
    @IBOutlet weak private var QuestionText: UILabel!
    @IBOutlet weak private var StoryText: UITextView!
    @IBOutlet weak private var StartFinishBtn: UIButton!
    @IBOutlet weak private var ChartContainer: UIView!
    @IBOutlet weak private var CountDownLabel: UILabel!
    
    //Story 'n question params
    var currentStage:Int = 1
    var currentQuestion:Int = 0
    var stopWatch = Date()
    var currentReadingTime:TimeInterval?
    var questions:[NetworkModels.ReadingQuesionModel] = []
    var result:[NetworkModels.ReadingRequestModel] = Array(repeating: NetworkModels.ReadingRequestModel(answer: nil, questionNo: nil, readingTime: nil), count: 3)
    
    //Chart params
    var _values:[CGFloat] = []
    
    var _chart:SimpleBarChart = SimpleBarChart()
    var _texts:[String] = []
    var _xLabels:[String] = []
    var _barColors:[UIColor] = []
    var _currentBarColor:Int = 0
    
    var isFinished:Bool = false
    
    var currentUser:NetworkModels.UserInfo?
    var askedQuestionsArray:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var askedQuestionsCount:Int = 0
    var audioPlayer:AVAudioPlayer?
    let viewModel = ReadingTestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillSeedValues()
        observeSuccess()
        observeLoading()
        observeError()
        currentStage = 1
        isFinished = false
        QuestionView.isHidden = true
        StoryView.isHidden = false
        StoryText.isHidden = true
        
        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(customBackBtn))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        currentUser = SharedPref.shared.userInfo
        askedQuestionsCount = currentUser?.readingTestQuestionsCount ?? 0
        askedQuestionsArray = currentUser?.readingTestAskedQuestions ?? [0,0,0,0,0,0,0,0,0,0,0,0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "اختبار القراءة"
    }
    
    func observeSuccess(){
        viewModel.result.subscribe { status in
            if let success = status.element, success == true {
                self.currentUser = SharedPref.shared.userInfo
                self.currentUser?.readingTestQuestionsCount = self.askedQuestionsCount
                self.currentUser?.readingTestAskedQuestions = self.askedQuestionsArray
                SharedPref.shared.setUserInfo(userInfo: self.currentUser)
                self.ResultView.isHidden = false
                self.QuestionView.isHidden = true
                self.StoryView.isHidden = true
                self._chart.reloadData()
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

    func doResultsMagic(){
        audioPlayer = nil
        let passageSecs1:Float =  result[0].readingTime ?? 0.0
        let passageSecs2:Float =  result[1].readingTime ?? 0.0
        let passageSecs3:Float =  result[2].readingTime ?? 0.0
        
        let passageAverageSec = (passageSecs1 + passageSecs2 + passageSecs3) / 3
        
        let passageWords1:Int = questions[result[0].questionNo!].numberOfWords
        let passageWords2:Int = questions[result[1].questionNo!].numberOfWords
        let passageWords3:Int = questions[result[2].questionNo!].numberOfWords
        
        let passageWordsAverage:Float = Float((passageWords1+passageWords2+passageWords3)/3)
        let wordsPerMin:Int = Int((passageWordsAverage/passageAverageSec)*60)
        
        
        self.ResultAverageSecs.text = String(format: "%0.1f", passageAverageSec)
        self.ResultAverageWords.text = String(format: "%d", wordsPerMin)
        
        viewModel.tp_Passage1 = Int(passageSecs1)
        viewModel.tp_Passage2 = Int(passageSecs2)
        viewModel.tp_Passage3 = Int(passageSecs3)
        
        viewModel.tp_Answer1 = result[0].answer ?? 0
        viewModel.tp_Answer2 = result[1].answer ?? 0
        viewModel.tp_Answer3 = result[2].answer ?? 0
        
        viewModel.tp_ReadingSpeed = wordsPerMin
        
        viewModel.idPassage1 = result[0].questionNo ?? 0
        viewModel.idPassage2 = result[1].questionNo ?? 0
        viewModel.idPassage3 = result[2].questionNo ?? 0
        
        viewModel.submitResult(currentStage)
        
        
        let values:[CGFloat] = [CGFloat(passageSecs1), CGFloat(passageSecs2), CGFloat(passageSecs3)]
        let texts:[String] = [String(format: "%.2f", passageSecs1), String(format: "%.2f", passageSecs2), String(format: "%.2f", passageSecs3)]
        let labels:[String] = ["قطعة نصية ١", "قطعة نصية ٢", "قطعة نصية ٣"]
        self._chart.removeFromSuperview()
        self.loadChartBarWithValues(value: values, text: texts, labels: labels, incrementalValue: 1, containerView: self.ChartContainer)
        
    }

    func prepareStoryText(){
        self.StoryText.backgroundColor = UIColor.black
        self.StoryText.font = UIFont(name: "AdobeArabic-Regular", size: 38.0)
        self.StoryText.textColor = UIColor.white
        self.StoryText.textAlignment = .right
    }
    
    func fillSeedValues() {
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:1, storyText: "أهرامات مصر من أقدم عجائب الدنيا السبع، وتعتبر مقابر للفراعنة، وقد امتلأت مقابرهم في يوم من الأيام بممتلكات الملوك التي لا تقدر بثمن، والتي دفنت معهم حتي يستعملوها في الحياة الأخري. وقد نهبت كنوز الأهرامات منذ آلاف السنين. وترجع الفكرة في بناء الأهرامات إلي اعتقاد المصريين القدماء في خلود الروح." ,questionText: "هل تم ذكر فراعنة مصر في هذا المقطع ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:0, storyText: "تعطي جائزة نوبل لمن يقوم بالأبحاث البارزة، أو لمن يستطيع أن يبتكر تقنيات جديدة، أو من يقوم بخدمات اجتماعية نبيلة. وتعد جائزة نوبل أعلي مرتبة علي مستوي العالم. الأب الروحي لجائزة نوبل هو الصناعي السويدي ومخترع الديناميت، الفريد نوبل. ويتم توزيع جوائز نوبل في احتفال رسمي في العاشر من ديسمبر ." ,questionText: "هل تم ذكر الاوسكار في هذا المقطع ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:1, storyText: "قال أطباء إن علاجاً محتملا لحساسية الفول السوداني نجح في تغيير حياة عدد من الاطفال المشاركين في تجربة طبية. وكان علي الاطفال زيادة كمية الفول السوداني التي يتناولونها يوميا بصورة تدريجية. وقد رجحت نتائج التجربة أن ۸٤ في المئة من الأطفال استطاعوا تناول الفول السوداني يومياً بعد مضي ستة أشهر ." ,questionText: "هل تحدث هذا المقطع عن حساسية الفول السوداني ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:0, storyText: " قالت منظمة الأمم المتحده للتربية والعلوم اليونسكو إن نحو ٤۳ في المئة من الأطفال في الدول العربية يفتقرون المبادئ الأساسية للتعليم سواء كانوا في المدارس أو خارجها. ووفقا للتقارير ، فإن طفلا من بين كل أربعة اطفال ، في الدول الفقيرة ، لا يستطيع قراءة جملة واحدة وتزيد النسبة في مناطق الصحراء الكبري." ,questionText: "هل تحدث هذا المقطع عن الأطفال في اليابان ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:0, storyText: "اعلنت شركة صناعة السيارات الفاخرة (بورش) عن أول سيارة كهربائية وهي معروضة في متحف في ألمانيا .و تم العثور علي هذه السيارة في إحدي المباني التجارية لتخزين البضائع والصناعات ومعدات النقل الثقيلة بالعاصمة النمساوية فيينا. وصمم فرديناند بورش هذه السيارة الكهربائية عندما كان عمره ۲۲ ، وقد اسس شركته في عام ۱۹۳۱." ,questionText: "هل تم ذكر الطائرات في هذا المقطع ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:0, storyText: "ابن سينا ولد في قرية (أفشنة) الفارسية قرب بخاري. عرف بإسم الشيخ الرئيس، وسماه الغربيون بأمير الأطباء وأبو الطب الحديث. وقد ألف ٤٥۰ كتاب في مواضيع مختلفة، العديد منها يركز علي الفلسفة والطب الحديث. ويعتبر ابن سينا من أول من كتب عن الطب في العالم. ولقد اتبع أسلوب آبقراط وجالينوس." ,questionText: "هل تحدث هذا المقطع عن ابن سينا ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:51, answer:0, storyText: "الحديث عن مثلث برمودا يشبة الحديث عن الحكايات الخرافية، ولكن يبقي الفرق هنا هو أن مثلث برمودا حقيقة واقعية لمسناها في عصرنا هذا، وقرأنا عنها في الصحف العربية والعالمية، ويمكن القول أن مثلث برمودا يعتبر التحدي الذي يواجه الإنسان في هذا القرن . وهو أحد الغرائب الطبيعية الذي تتحدث عنه الصحف." ,questionText: "هل تحدث هذا المقطع عن البراكين ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:1, storyText: "يقع مضيق جبل طارق البحري بين المغرب وأسبانيا ومستعمرة جبل طارق البريطانية، ويفصل بين المحيط الأطلسي والبحر الأبيض المتوسط. سمي لهذا الإسم لان القائد طارق بن زياد عبره في بداية الفتوحات الإسلامية لأسبانيا عام ۷۱۱ ميلادية. يبلغ عمق المياه فيه حوالي ۳۰۰ متر، واقل مسافة بين ضفتيه هي ۱٤ كيلومتر." ,questionText: "هل تحدث هذا المقطع عن مضيق جبل طارق ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:1, storyText: "يعتزم بنك باركليز البريطاني إغلاق ربع فروعه الحالية في المملكة المتحدة بالإضافة الى تسريح مئات العاملين في قسم الاستثمار المصرفي. فإنه من المتوقع أن يستبدل بنك الإقراض البريطاني منافذ صغيرة في متاجر (أزدا). وتأتي خطة تسريح العمالة إلي جانب ما أعلنه البنك عن خفض ۳۷۰۰ وظيفة في أوائل العام الماضي." ,questionText: "هل تم ذكر بنك باركليز البريطاني في هذا المقطع ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:53, answer:0, storyText: "أمرت محكمة في جنوب أفريقيا على النحاتين بإزالة تمثال لأرنب من البرونز تم وضعه بطريقة خفية داخل أذن تمثال لنلسون مانديلا. وقال متحدث باسم المحكمة أن القرار جاء لإعادة الكرامة لتمثال الزعيم الجنوب الأفريقي. و قد وضعوا النحاتين هذا التمثال كنوع من التوقيع لهم كما يفيد الاعتراف بالتعجل في عملية النحت لإنهاء التمثال." ,questionText: "هل تم ذكر تمثال سلحفاه في هذا المقطع ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:50, answer:1, storyText: " يعتقد باحثون أمريكون ان استخدام المبيدات الحشرية قد تعزز الإصابة بمرض الزهايمر. واظهرت الدراسات أن نسبة وجود مركب (DDT)  في اجسام المرضي المصابين بالزهايمر تصل لأربعة أضعاف النسب المرصودة لدي الإحصاءات ولكن مركز ابحاث الزهايمر ببريطانيا أكد أنه لا زالت هناك حاجة إلي توفير أدلة علمية اكثر لإثبات وجود علاقة." ,questionText: "هل تحدث هذا المقطع عن مرض الزهايمر ؟"))
        
        questions.append(NetworkModels.ReadingQuesionModel(numberOfWords:53, answer:0, storyText: "منذ اليوم الأول تحول جهاز (الآي بود) الذي اطلقتة شركة أبل في ۲۰۰۱ إلي أيقونة في عالم التكنولوجيا. فقد تميز (الآي بود) بتصميمه ذي العجلة المميزة التى يمكن النقر عليها، وسماعاته البيضاء المتوفرة بسهولة، إذ جعل من أجهزة الصوتيات النقالة نسخة جذابة واكثر تطوراً مقارنة بمشغل (الووك مان) الذي أطلقته شركتة سوني قديماً." ,questionText: "هل تحدث هذا المقطع عن جهاز الكمبيوتر ؟"))
        
    }
    
    @IBAction private func startBtn(){
        audioPlayer = nil
        if(self.StartFinishBtn.isSelected && self.CountDownLabel.isHidden){ //finish button
            self.StartFinishBtn.isSelected = false
            showNextQuestion()
        }else if(self.CountDownLabel.isHidden){ //start button
            self.StartFinishBtn.isSelected = true
            showNextStory()
        }
    }
    
    func showNextQuestion(){
        currentReadingTime = stopWatch.timeIntervalSinceNow
        self.StoryText.isHidden = true
        self.StoryView.isHidden = true
        self.QuestionView.isHidden = false
        self.QuestionText.text = questions[currentQuestion].questionText
    }
    
    func showNextStory() {
        if(askedQuestionsCount >= NUMBER_OF_STORIES){
            askedQuestionsArray = [0,0,0,0,0,0,0,0,0,0,0,0]
            askedQuestionsCount = 0
        }
        
        repeat{
            currentQuestion = Int(arc4random_uniform(UInt32(NUMBER_OF_STORIES)))
        }while(askedQuestionsArray[currentQuestion] as! Int != 0)
        
        self.StoryText.text = questions[currentQuestion].storyText
        
        askedQuestionsArray[currentQuestion] = 1
        askedQuestionsCount+=1
        
        //back again hena ya yassin
    
        countDownAnimation { finished in
            self.StoryText.isHidden = false
            self.QuestionView.isHidden = true
            self.StoryView.isHidden = false
            self.prepareStoryText()
            self.stopWatch = Date()
        }
    }
    
    @IBAction private func answerBtn(_ sender: UIButton){
        audioPlayer = nil
        result[currentStage-1] = NetworkModels.ReadingRequestModel(answer: sender.tag == questions[currentQuestion].answer ? 1 : 0, questionNo: currentQuestion, readingTime: Float(( -1 * currentReadingTime!)))
        if(currentStage < 3){
            currentStage+=1
            self.StoryText.isHidden = true
            self.QuestionView.isHidden = true
            self.StoryView.isHidden = false
            self.CurrentStoryLabel.text = Helpers.arabicCharacter(englishNumber: currentStage)
            self.CurrentQuestionLabel.text = Helpers.arabicCharacter(englishNumber: currentStage)
        }else{ //test is finished
            isFinished = true
            doResultsMagic()
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
    

    @IBAction private func havingReadingVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.HAVING_READING_VOICE_OVER)
        
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying {
                audioPlayer.currentTime = 0
                audioPlayer.play()
            }else{
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }else{
            audioPlayer = Helpers.getAudioPlayer(fileName: Constants.HAVING_READING_VOICE_OVER)
            audioPlayer?.play()
        }
    }
    
    @IBAction private func questionReadingTestVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.READING_QUESTIONS_VOICE_OVER_ARRAY[currentQuestion])
        
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying {
                audioPlayer.currentTime = 0
                audioPlayer.play()
            }else{
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }else{
            audioPlayer = Helpers.getAudioPlayer(fileName: Constants.READING_QUESTIONS_VOICE_OVER_ARRAY[currentQuestion])
            audioPlayer?.play()
        }
    }
    
    @objc func customBackBtn(){
        if(!isFinished){
            let alert = CustomAlertView.init(title: "هل تريد إلغاء الاختبار ؟", buttonOKTitle: "نعم، إلغي الاختبار", buttonCancelTitle: "عودة للاختبار", delegate: self, tag: 3)
            alert?.show()
        }else{
            self.popToTestsController()
        }
    }
    
    func countDownAnimation(completion: @escaping (_ finished:Bool) -> Void) {
        
        self.CountDownLabel.isHidden = false
        self.CountDownLabel.alpha = 1.0
        self.CountDownLabel.text = "٣"
        UIView.animate(withDuration: 1, delay: 0.0, options: .layoutSubviews) {
            self.CountDownLabel.alpha = 0
        } completion: { finished in
            self.CountDownLabel.alpha = 1.0
            self.CountDownLabel.text = "٢"
            
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseInOut) {
                self.CountDownLabel.alpha = 0
            } completion: { finished in
                self.CountDownLabel.alpha = 1.0
                self.CountDownLabel.text = "١"
                
                UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseInOut) {
                    self.CountDownLabel.alpha = 0
                } completion: { finished in
                    self.CountDownLabel.isHidden = true
                    completion(finished)
                }
            }
        }
    }
}

extension ReadingTestVC: SimpleBarChartDataSource, SimpleBarChartDelegate {
    
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        return UInt(_values.count)
    }
    
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: UInt) -> CGFloat {
        return _values[Int(index)]
    }
    
    func barChart(_ barChart: SimpleBarChart!, textForBarAt index: UInt) -> String! {
        return _texts[Int(index)]
    }
    
    func barChart(_ barChart: SimpleBarChart!, colorForBarAt index: UInt) -> UIColor! {
        return _barColors[_currentBarColor]
    }
    
    func barChart(_ barChart: SimpleBarChart!, xLabelForBarAt index: UInt) -> String! {
        return _xLabels[Int(index)]
    }
    
    
    private func loadChartBarWithValues(value:[CGFloat], text:[String], labels:[String], incrementalValue:Int, containerView:UIView){
        _values = value
        _texts = text
        _xLabels = labels
        _barColors = [UIColor(red: 119/255.0, green: 156/255.0, blue: 89/255.0, alpha: 1)]
        
        let chartFrame = CGRect(x: 30.0, y: 60.0, width: containerView.frame.width, height: containerView.frame.height)
        _chart = SimpleBarChart(frame: chartFrame)
        //_chart.center                     = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        _chart.delegate = self
        _chart.dataSource = self
        _chart.barShadowOffset = CGSize(width: 2.0, height: 1.0)
        _chart.animationDuration = 1.0
//        chart.barShadowColor = UIColor(ciColor: .gray)
        _chart.barShadowAlpha = 0.0
        _chart.barShadowRadius = 1.0
        _chart.barWidth = 60.0
        
        _chart.xLabelType = SimpleBarChartXLabelTypeHorizontal
        _chart.incrementValue = incrementalValue
        _chart.barTextType = SimpleBarChartBarTextTypeTop
        _chart.barTextColor = UIColor(ciColor: .white)
        _chart.gridColor = UIColor(ciColor: .gray)
        
        containerView.addSubview(_chart)
    }
    
}

extension ReadingTestVC: CustomAlertViewDelegate {
    func didSelectButtonAtIndex(tag: Int, index: Int) {
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
}



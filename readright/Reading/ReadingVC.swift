//
//  ReadingVC.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import AVFoundation
import Foundation
import UIKit


let MAX_SPEED:Int = 4
let INTERVAL_ANIMATION:CGFloat = 0.01
let TEXTVIEW_SEGMENT_WIDTH:Int = 100
let TEXT_Y_POSITION:CGFloat = 65
let TEXT_HEIGHT:CGFloat = 142

class ReadingVC: UIViewController, ColorDialogueDelegate {
    
    var feedParser: MWFeedParser?
    var parsedItems: [MWFeedItem] = []
    var formatter:DateFormatter = DateFormatter()
    var itemsToDisplay:[MWFeedItem] = []
    var movingTextContainer: UIView?
    var textTimer:Timer?
    var remainingTherapyTimer:Timer?
    var movingTextX:CGFloat = CGFloat()
    var previousMovingTextX:CGFloat = CGFloat()
    var previousRatioFactor:CGFloat = CGFloat()

    var intervalTime:CGFloat? = CGFloat()
    var movingTextSize:CGFloat? = CGFloat()
    var colorView:ColorDialogueView = .fromNib()
    var step:Float?
    var currentBackgroundColor:UIColor?
    var currentTextColor:UIColor?
    var textBgView:UIView?
    var orangeImages: [String] = [String](repeating: "", count: 6)
    var greenImages: [String] = [String](repeating: "", count: 6)
    var greyImages: [String] = [String](repeating: "", count: 6)
    var readingTestNo:Int?

    //Therapy API Skeleton
    var stopWatch:Date?
    var currentTherapyItemTitle:String = ""
    var userIsReading:Bool = false
    var totalTherapyTime:Int = 0


    var currentBookId:Int = 0
    var currentChapterId:Int = 0
    var previousIndexRow:Int = -1
    var previousSegment:Int = 0
    
    var books:[NetworkModels.BookDataItem] = []
    var chapters:[NetworkModels.ChapterDataItem] = []
    var audioPlayer:AVAudioPlayer?

    var leftTextView: UITextView?
    var rightTextView: UITextView?
    var currentTherapyText:String?
    var startFrameIndex:Int = 0
    var startTxtIndex:Int = 0

    var previousTextViews: [UITextView] = []
    var isGoingForward: Bool = false
    
    let viewModel:TherapyViewModel = TherapyViewModel()
    
    @IBOutlet weak private var beforeStartView:CustomView!
    @IBOutlet weak private var testsDashboardView:CustomView!
    @IBOutlet weak private var TherapySegment:UISegmentedControl!
    @IBOutlet weak private var MovingTxtLabel:UILabel!
    @IBOutlet weak private var TherapyTitleLabel:UILabel!
    
    @IBOutlet weak private var VolumeSlider:UISlider!
    @IBOutlet weak private var SeekerSlider:UISlider!
    @IBOutlet weak private var PlayBtn:UIButton!
    
    @IBOutlet weak private var TherapyVew:UIView!
    @IBOutlet weak private var NewsView:CustomView!
    @IBOutlet weak private var BooksView:CustomView!
    
    @IBOutlet weak private var NewsTableView:UITableView!
    @IBOutlet weak private var BooksTableView:UITableView!
    @IBOutlet weak private var ChaptersTableView:UITableView!
    
    @IBOutlet weak private var TestBtn_1:UIButton!
    @IBOutlet weak private var TestLabel_1:UILabel!

    @IBOutlet weak private var TestBtn_2:UIButton!
    @IBOutlet weak private var TestLabel_2:UILabel!

    @IBOutlet weak private var TestBtn_3:UIButton!
    @IBOutlet weak private var TestLabel_3:UILabel!

    @IBOutlet weak private var TestBtn_4:UIButton!
    @IBOutlet weak private var TestLabel_4:UILabel!

    @IBOutlet weak private var TestBtn_5:UIButton!
    @IBOutlet weak private var TestLabel_5:UILabel!

    @IBOutlet weak private var TestBtn_6:UIButton!
    @IBOutlet weak private var TestLabel_6:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllSeeds()
        
        let spinner:UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        
        spinner.center = CGPoint(x: 520, y: 700)
        spinner.tag = 12
        beforeStartView.addSubview(spinner)
        spinner.startAnimating()
        
        observeError()
        observeLoading()
        observeBooks()
        observeChapters()
        
        //Delegates
        self.NewsTableView.delegate = self
        self.NewsTableView.dataSource = self
        self.BooksTableView.dataSource = self
        self.BooksTableView.delegate = self
        self.ChaptersTableView.dataSource = self
        self.ChaptersTableView.delegate = self
        textBgView = UIView(frame: CGRect(x: 0.0, y: TEXT_Y_POSITION, width: self.TherapyVew.frame.size.width, height: TEXT_HEIGHT))
        textBgView?.backgroundColor = UIColor(ciColor: .black)
        TherapyVew.addSubview(textBgView!)
        step = 0.5 * Float(MAX_SPEED)
        colorView.delegate = self
        TherapySegment.isUserInteractionEnabled = false
        currentBackgroundColor = UIColor(ciColor: .black)
        currentTextColor = UIColor(red:199/255.0, green:81.0/255.0, blue:51.0/255.0, alpha:1)
        formatter.dateFormat = "dd/MM/yyyy"
        let feedURL = URL(string: Constants.RSS_FEEDS_URL)
        feedParser = MWFeedParser(feedURL: feedURL)
        feedParser?.delegate = self
        feedParser?.feedParseType = ParseTypeFull
        feedParser?.connectionType = ConnectionTypeAsynchronously
        
//        totalTherapyTime = SharedPref.shared.userInfo. [CommonHelper getCurrentUser].therapySpentTime ;
        
        self.TherapyTitleLabel.text = "Aljazeera - مباشر"
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func handleTestsViewsStatusWithPendingTestId(_ pendingTestId:Int){
        if(pendingTestId == 0 || pendingTestId > Constants.SEARCH_TASK_TEST){
            return
        }
        var tempTestBtn: UIButton?
        var tempTestLbl: UILabel?
        
        //Set all the finished tests with green colors
        for i in 1..<pendingTestId {
            //Set the current pending test with green color and make it clickable
            tempTestBtn = value(forKey: String(format: "TestBtn_%d", i)) as? UIButton
            tempTestLbl = value(forKey: String(format: "TestLabel_%d", i)) as? UILabel
            
            //Set the btn with grey background
            tempTestBtn?.setImage(UIImage(named: greenImages[i - 1]), for: .normal)
            tempTestBtn?.isUserInteractionEnabled = false
            //Set the text label with grey color
            tempTestLbl?.textColor = UIColor(red:119.0/255.0, green:156.0/255.0, blue:89.0/255.0, alpha:1)
        }
        
        //Set the current pending test with Orange color and make it clickable
        tempTestBtn = value(forKey: String(format: "TestBtn_%d", pendingTestId)) as? UIButton
        tempTestLbl = value(forKey: String(format: "TestLabel_%d", pendingTestId)) as? UILabel
        
        //Set the btn with orange background
        tempTestBtn?.setImage(UIImage(named: orangeImages[pendingTestId - 1]), for: .normal)
        //Set the text label with orange color
        tempTestLbl?.textColor = UIColor(red:218.0/255.0, green:118.0/255.0, blue:60.0/255.0, alpha:1)
        tempTestBtn?.isUserInteractionEnabled = true
        
        
        //Set all the undone tests yet with grey colors
        for j in (pendingTestId + 1) ... Constants.NUMBER_OF_TESTS {
            //Set the current pending test with grey color and make it clickable
            tempTestBtn = value(forKey: String(format: "TestBtn_%d", j)) as? UIButton
            tempTestLbl = value(forKey: String(format: "TestLabel_%d", j)) as? UILabel
            
            //Set the btn with grey background
            tempTestBtn?.setImage(UIImage(named: greenImages[j - 1]), for: .normal)
            tempTestBtn?.isUserInteractionEnabled = false
            //Set the text label with grey color
            tempTestLbl?.textColor = UIColor(red:209.0/255.0, green:209.0/255.0, blue:209.0/255.0, alpha:1)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
//        if(currentUser.therapyStatus == NEED_THERAPY){
            initTherapyScenes()
//        }else{
//            initTestsScenes()
//            handleTestsViewsStatusWithPendingTestId(currentUser.pendingTestId)
//        }
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
    
    func observeBooks() {
        viewModel.error.asObservable().subscribe { status in
            if let error = status.element, error != "" {
                Helpers.handleErrorMessages(message: error)
            }
            print(status)
        }
    }
    
    func observeChapters() {
        viewModel.error.asObservable().subscribe { status in
            if let error = status.element, error != "" {
                Helpers.handleErrorMessages(message: error)
            }
            print(status)
        }
    }
    
    @objc func appDidEnterBackground(){
        leftTherapy()
    }

    func leftTherapy() {
        textTimer?.invalidate()
        self.PlayBtn.isSelected = false
        if(userIsReading){
            completeTherapyInterval()
        }
        userIsReading = false
    }
    
    func loadAllSeeds() {
        greenImages[0] = "GreenReading"
        greenImages[1] = "GreenField"
        greenImages[2] = "GreenReading"
        greenImages[3] = "GreenNeglect"
        greenImages[4] = "GreenADL"
        greenImages[5] = "GreenSearch"
        
        orangeImages[0] = "OrangeReading"
        orangeImages[1] = "OrangeFieldTest"
        orangeImages[2] = "OrangeReading"
        orangeImages[3] = "OrangeNeglect"
        orangeImages[4] = "OrangeADL"
        orangeImages[5] = "OrangeSearch"
        
        greyImages[0] = "GreyReading"
        greyImages[1] = "GreyField"
        greyImages[2] = "GreyReading"
        greyImages[3] = "GreyNeglect"
        greyImages[4] = "GreyADL"
        greyImages[5] = "GreySearch"
    }
    
    func initTherapyScenes(){
        TherapyVew.isHidden = false
        testsDashboardView.isHidden = true
        
        feedParser?.parse()
    }

    func initTestsScenes(){
        TherapyVew.isHidden = true
        if(testsDashboardView.isHidden){
            beforeStartView.isHidden = false
        }else{
            beforeStartView.isHidden = true
        }
    }

    
    func completeTherapyInterval() {
        remainingTherapyTimer?.invalidate()
        let secSpent:Int =  Int(-1 * (stopWatch?.timeIntervalSinceNow ?? 0))
        
        totalTherapyTime += secSpent
        
        //call the API
        viewModel.therapy_duration = secSpent
        viewModel.therapyItemTitle = currentTherapyItemTitle
        viewModel.readingChapterID = currentChapterId
        viewModel.readingBookID = currentBookId
        
        
        //Three conditions to return without submitting
        if(viewModel.therapy_duration == 0){
            return
        }
        if(viewModel.therapyItemTitle == "" && viewModel.readingChapterID == 0){
            return
        }
        if(viewModel.therapyItemTitle == nil && viewModel.readingChapterID == 0){
            return
        }
//        if(totalTherapyTime >= Constants.THERAPY_SHOULD_TIME){
//            viewModel.submitCompleteTherapy()
//            //do all magic to star tests again
//        } else {
//            viewModel.submitTherapyInterval()
//        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "العلاج"
        self.navigationController?.navigationBar.topItem?.title = "العلاج"
    }
    
    @IBAction func refreshNewsBtn(_ sender: UIButton) {
        refreshNewsRSSFeeds()
    }
    
    @IBAction func settingBtn(_ sender: UIButton) {
        colorView.update(txtColor:currentTextColor!, backgroundColor:currentBackgroundColor!)
        textTimer?.invalidate()
        PlayBtn.isSelected = false
        
        if(userIsReading){
            completeTherapyInterval()
        }
        userIsReading = false
        
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window?.addSubview(colorView)
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        if(PlayBtn.isSelected){   //was pause state
            PlayBtn.isSelected = false
            textTimer?.invalidate()
            
            if(userIsReading){
                completeTherapyInterval()
            }
            userIsReading = false
        } else { //was play state
            if(previousIndexRow == -1){
                return
            }
            PlayBtn.isSelected = true
            if(!userIsReading){
                stopWatch = Date()
                userIsReading = true
                remainingTherapyTimer?.invalidate()
                remainingTherapyTimer = Timer.scheduledTimer(timeInterval: TimeInterval((Constants.THERAPY_SHOULD_TIME - totalTherapyTime)), target: self, selector: #selector(timeUpWhileReadingInOneItem), userInfo: nil, repeats: true)
                
            }
            textTimer = Timer.scheduledTimer(timeInterval: intervalTime!, target: self, selector: #selector(self.animateTxt), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func playbackBtn(_ sender: UIButton) {
        movingTextX = -1 * (movingTextSize ?? 0)
        movingTextContainer?.frame = CGRect(x: movingTextX, y: movingTextContainer?.frame.origin.y ?? 0.0, width: movingTextContainer?.frame.size.width ?? 0.0, height: movingTextContainer?.frame.size.height ?? 0.0)
        initializeTheFirstTwoTextViews()
        updateSeekerSlide()
    }
    
    @IBAction func changeVolumeSlider(_ sender: UISlider) {
        let speedFactor = VolumeSlider.value <= 0.01 ? 0.01 : VolumeSlider.value
        step = speedFactor * Float(MAX_SPEED)
    }
    
    @IBAction func changeSeekerSlider(_ sender: UISlider) {
        let ratioFactor:CGFloat = CGFloat(self.SeekerSlider.value)
        isGoingForward = (ratioFactor >= previousRatioFactor);
        if(rightTextView != nil && !isGoingForward){
            if(previousTextViews.count > 0){
                //remove left and add right
                addTextInBackward()
            }
        }
        previousRatioFactor = ratioFactor;
        var newXFactor = (1.0 - ratioFactor) * (movingTextSize ?? 0)
        newXFactor *= -1
        movingTextContainer?.frame = CGRect(x: newXFactor, y: movingTextContainer?.frame.origin.y ?? 0, width: movingTextContainer?.frame.size.width ?? 0, height: movingTextContainer?.frame.size.height ?? 0)
    }
    
    @IBAction func changeTherapyTybe(_ sender: UISegmentedControl) {
        let selectedSegment:Int = self.TherapySegment.selectedSegmentIndex
        previousSegment = self.TherapySegment.selectedSegmentIndex
        switch (selectedSegment) {
        case Constants.THERAPY_NEWS_VIEW: do { //news
            self.BooksView.isHidden = true
            self.NewsTableView.isHidden = false
            break
        }
        case Constants.THERAPY_LIBRARY_VIEW: do { //Libary(Books)
            feedParser?.stopParsing()
            self.BooksView.isHidden = false
            self.NewsTableView.isHidden = true
            viewModel.requestBooks()
            break
        }
        default:
            break
        }
    }
    
    @IBAction func PressGoTests(_ sender: UIButton) {
        self.beforeStartView.isHidden = true
        self.testsDashboardView.isHidden = false
    }
    
    @IBAction func goReadingTest1(_ sender: UIButton) {
        readingTestNo = 1
        performSegue(withIdentifier: "GoReadingTest", sender: self)
    }
    
    @IBAction func goVisualTest(_ sender: UIButton) {
        performSegue(withIdentifier: "GoVisualTest", sender: self)
    }
    
    @IBAction func goReadingTest2(_ sender: UIButton) {
        readingTestNo = 2
        performSegue(withIdentifier: "GoReadingTest", sender: self)
    }
    
    @IBAction func goNeglectTest(_ sender: UIButton) {
        performSegue(withIdentifier: "GoNeglectTest", sender: self)
    }
    
    @IBAction func goADLTest(_ sender: UIButton) {
        performSegue(withIdentifier: "GoADLTest", sender: self)
    }
    
    @IBAction func goDesktopSearchTest(_ sender: UIButton) {
        performSegue(withIdentifier: "GoSearchTest", sender: self)
    }
    
    @IBAction func beforeTestVoiceOver(_ sender: UIButton) {
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying {
                audioPlayer.currentTime = 0;
                audioPlayer.play()
            }else{
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }else{
            audioPlayer = Helpers.getAudioPlayer(fileName: Constants.TESTS_INTRO_VOICE_OVER)
            audioPlayer?.play()
        }
    }
    
    func refreshNewsRSSFeeds(){
        parsedItems.removeAll()
        feedParser?.stopParsing()
        self.NewsTableView.alpha = 0.3
        self.NewsTableView.isUserInteractionEnabled = false
        self.TherapySegment.isUserInteractionEnabled = false

        feedParser?.parse()
    }
    
    func updateNewsTableWithParsedItems() {
        itemsToDisplay = parsedItems.sorted(by: { item1, item2 in
            item1.date > item2.date
        })
//        [parsedItems sortedArrayUsingDescriptors:
//                          [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
//                                                                               ascending:NO]]];
        self.NewsTableView.isUserInteractionEnabled = true
        self.NewsTableView.alpha = 1
        self.NewsTableView.reloadData()
    }
    
    func addTextInBackward() {
        var viewXPoint:CGFloat = 0
        repeat {
            let txtViewSegment = previousTextViews.last ?? UITextView()
            
            let txtViewSegmentOrigin = txtViewSegment.frame.origin
            let newOrigin =  movingTextContainer?.convert(txtViewSegmentOrigin, to: nil)
            
            viewXPoint = newOrigin?.x ?? 0
            
            previousTextViews.removeLast()
            
            txtViewSegment.textColor = currentTextColor
            
            txtViewSegment.backgroundColor = currentBackgroundColor
            
            txtViewSegment.autoresizesSubviews = false
            txtViewSegment.isEditable = false
            txtViewSegment.textAlignment = .right
            
            movingTextContainer?.addSubview(txtViewSegment)
            startFrameIndex += Int(sizeOfText(txt: leftTextView?.text))
            startTxtIndex -= leftTextView?.text.count ?? 0
            leftTextView?.removeFromSuperview()
            
            leftTextView = rightTextView
            rightTextView = txtViewSegment
            
        } while ( viewXPoint > 0 && previousTextViews.count > 0)
    }
    
    func addTextInForward(){
        if(startTxtIndex < currentTherapyText?.count ?? 0){
            
            var txtSegment:String? = nil
            var txt = currentTherapyText
            
            if(Int(startTxtIndex + TEXTVIEW_SEGMENT_WIDTH) < txt?.count ?? 0){
                var extender:Int = 0
                var baseIndex:Int = Int(startTxtIndex + TEXTVIEW_SEGMENT_WIDTH - 1)
                while (txt?[baseIndex + extender] != " " && (baseIndex + extender) < txt!.count - 1){
                    extender+=1
                }
                txtSegment = txt?[Range(uncheckedBounds: (startTxtIndex, TEXTVIEW_SEGMENT_WIDTH + extender))]
            }else{
                txtSegment = txt?.substring(fromIndex: startTxtIndex)
            }

            startFrameIndex -= Int(sizeOfText(txt: txtSegment))
            let txtViewSegment = UITextView(frame: CGRect(x: startFrameIndex, y: 0, width: Int(sizeOfText(txt: txtSegment)), height: Int(TEXT_HEIGHT)))
            txtViewSegment.font = UIFont(name: "AdobeArabic-Regular", size: 104.0)
            txtViewSegment.textColor = currentTextColor
            txtViewSegment.backgroundColor = currentBackgroundColor
            txtViewSegment.autoresizesSubviews = false
            txtViewSegment.isEditable = false
            txtViewSegment.textAlignment = .right
            txtViewSegment.text = txtSegment
            rightTextView?.removeFromSuperview()
            if let rightTextView = rightTextView {
                previousTextViews.append(rightTextView)
            }
            movingTextContainer?.addSubview(txtViewSegment)
            startTxtIndex += txtSegment?.count ?? 0
            rightTextView = leftTextView
            leftTextView = txtViewSegment
        }
    }
    
    @objc func animateTxt(){
        movingTextX = movingTextContainer?.frame.origin.x ?? CGFloat()
        previousMovingTextX = movingTextX
        movingTextX += CGFloat(step ?? 0)
        
        
        if(movingTextX < 0){
            //Here check of the left
            if(leftTextView != nil){
                if let currentTextViewOrigin = leftTextView?.frame.origin {
                    if let newOrigin = movingTextContainer?.convert(currentTextViewOrigin, to: nil) {
                        let originOffset = Int((newOrigin.x * -1) + self.TherapyVew.frame.size.width) - Int(leftTextView?.frame.size.width ?? 0)
                        if(originOffset < 0){
                            //remove right and add left;
                            addTextInForward()
                        }
                    }
                }
            }
            
            if let view = movingTextContainer {
                movingTextContainer?.frame = CGRect(x: movingTextX, y: view.frame.origin.y, width: view.frame.size.width,height: view.frame.size.height)
            }
            updateSeekerSlide()
        }else{   //Here the therapy item is finished
            textTimer?.invalidate()
            PlayBtn.isSelected = false
            completeTherapyInterval()
            userIsReading = false
        }
    }
    
    func runTherapyTableCellItem(_ txt:String, _ therapyItemTitle:String){
        userIsReading = true
        currentTherapyItemTitle = therapyItemTitle
        currentTherapyText = txt
        stopWatch = Date()
        remainingTherapyTimer?.invalidate()
        
        remainingTherapyTimer = Timer.scheduledTimer(timeInterval: TimeInterval((Constants.THERAPY_SHOULD_TIME - totalTherapyTime)), target: self, selector: #selector(timeUpWhileReadingInOneItem), userInfo: nil, repeats: true)
        
        textTimer?.invalidate()
        movingTextContainer?.removeFromSuperview()
        
        
        previousTextViews = []
        previousRatioFactor = 0
        isGoingForward = true
        
        movingTextX = CGFloat(calculateTextViewsSizes(txt))
        movingTextSize = movingTextX
        movingTextX *= -1
        previousMovingTextX = movingTextX
        
        //initial speed of the half of the slider
        intervalTime = INTERVAL_ANIMATION
        movingTextContainer = UIView(frame: CGRect(x:movingTextX, y:TEXT_Y_POSITION, width:movingTextSize ?? CGFloat(), height:TEXT_HEIGHT))
        
        initializeTheFirstTwoTextViews()
        TherapyVew.addSubview(movingTextContainer!)
        
        PlayBtn.isSelected = true
        textBgView?.backgroundColor = currentBackgroundColor
        textTimer = Timer.scheduledTimer(timeInterval:intervalTime!, target:self, selector:#selector(self.animateTxt), userInfo:nil, repeats: true)
    }
    
    func sizeOfText(txt:String?) -> Float {
        let font = UIFont(name: "AdobeArabic-Regular", size: 104.0)
        let attributes = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: txt ?? "", attributes: attributes as [NSAttributedString.Key : Any])
        let rect = attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: TEXT_HEIGHT), options: .usesLineFragmentOrigin, context: nil)
        return Float(rect.size.width + 10.0)
    }
    
    func initializeTheFirstTwoTextViews() {
        let txt:String = currentTherapyText ?? ""
        startTxtIndex = 0
        startFrameIndex = Int(movingTextContainer?.frame.size.width ?? 0)
        var txtSegment:String? = nil
        movingTextContainer?.subviews.forEach{
            $0.removeFromSuperview()
        }
        
        repeat {
            if((startTxtIndex + TEXTVIEW_SEGMENT_WIDTH) < txt.count){
                var extender:Int = 0
                var baseIndex:Int = startTxtIndex + TEXTVIEW_SEGMENT_WIDTH - 1
                while (txt[baseIndex + extender] != " " && (baseIndex + extender) < txt.count - 1){
                    extender+=1
                }
                txtSegment = txt[Range(uncheckedBounds: (startTxtIndex, TEXTVIEW_SEGMENT_WIDTH + extender))]
            } else {
                txtSegment =  txt.substring(fromIndex: startTxtIndex)
            }
            
            
            startFrameIndex -= Int(sizeOfText(txt:txtSegment))
            
            let txtViewSegment = UITextView(frame: CGRect(x: startFrameIndex, y: 0, width: Int(sizeOfText(txt:txtSegment)), height: Int(TEXT_HEIGHT)))
            
            txtViewSegment.font = UIFont(name: "AdobeArabic-Regular", size: 104.0)
            txtViewSegment.textColor = currentTextColor
            
            
            txtViewSegment.backgroundColor = currentBackgroundColor
            
            txtViewSegment.autoresizesSubviews = false
            txtViewSegment.isEditable = false
            txtViewSegment.textAlignment = .right
            
            txtViewSegment.text = txtSegment
            
            movingTextContainer?.addSubview(txtViewSegment)
            startTxtIndex += txtSegment?.count ?? 0
            
            if((movingTextContainer?.subviews.count ?? 0) == 1){
                rightTextView = txtViewSegment
                leftTextView = nil
            }else if ((movingTextContainer?.subviews.count ?? 0) == 2){
                leftTextView = txtViewSegment
                break
            }
        } while ( startTxtIndex < txt.count)
        
    }
    
    func calculateTextViewsSizes(_ txt:String) -> Float {
        var startTxt:Int = 0
        var txtSegment:String? = nil
        var size:Float = 0
        
        repeat {
            if((startTxt + TEXTVIEW_SEGMENT_WIDTH) < txt.count){
                txtSegment = txt[Range(uncheckedBounds: (startTxt, TEXTVIEW_SEGMENT_WIDTH))]
            }else{
                txtSegment = txt.substring(fromIndex: startTxt)
            }
            
            size += sizeOfText(txt:txtSegment)
            
            startTxt += txtSegment?.count ?? 0
            
        } while (startTxt < txt.count)
        
        return size
    }
    
    func updateTextViewsColors() {
        self.view.showActivityView()
        DispatchQueue(label: "My Queue").async {
            DispatchQueue.main.async {
                self.movingTextContainer?.subviews.forEach {
                    ($0 as? UILabel)?.textColor = self.currentTextColor
                    ($0 as? UILabel)?.backgroundColor = self.currentBackgroundColor
                }
                self.view.hideActivityView()
            }
        }
    }
    
    func didPressContinueBtn(txtColor: UIColor, backgroundColor: UIColor) {
        colorView.removeFromSuperview()
        currentTextColor = txtColor
        currentBackgroundColor = backgroundColor
        didchangeColor()
    }
    
    func didchangeColor() {
        updateTextViewsColors()
        textBgView?.backgroundColor = currentBackgroundColor
        
        PlayBtn.isSelected = true
        textTimer = Timer.scheduledTimer(timeInterval: intervalTime ?? 0, target: self, selector: #selector(self.animateTxt), userInfo: nil, repeats: true)
        
        userIsReading = true
        stopWatch = Date()
        remainingTherapyTimer?.invalidate()
        
        remainingTherapyTimer = Timer.scheduledTimer(timeInterval: TimeInterval((Constants.THERAPY_SHOULD_TIME - totalTherapyTime)), target: self, selector: #selector(timeUpWhileReadingInOneItem), userInfo: nil, repeats: true)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leftTherapy()
        audioPlayer = nil
    }
    
    
    func getRandomColor() -> UIColor {
        let hue:CGFloat = ( CGFloat(arc4random() % 256) / 256.0 )  //  0.0 to 1.0
        let saturation:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5  //  0.5 to 1.0, away from white
        let brightness:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5  //  0.5 to 1.0, away from black
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        
    }
    
    @objc func timeUpWhileReadingInOneItem() {
        PlayBtn.isSelected = false
        textTimer?.invalidate()
        if(userIsReading){
            completeTherapyInterval()
        }
        userIsReading = false
    }
    
    func updateSeekerSlide() {
        let positiveTextPosition:CGFloat = -1 * movingTextX
        var distanceRatio:Float = Float(positiveTextPosition / (movingTextSize ?? 0))
        distanceRatio = 1 - distanceRatio
        SeekerSlider.setValue(distanceRatio, animated: true)
    }
    
}

extension ReadingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedSegment = self.TherapySegment.selectedSegmentIndex
        // Return the number of rows in the section.
        if(tableView == self.NewsTableView && selectedSegment == Constants.THERAPY_NEWS_VIEW){
            return parsedItems.count
        }
        if(tableView == self.BooksTableView  && selectedSegment == Constants.THERAPY_LIBRARY_VIEW){
            return books.count
        }
        if(tableView == self.ChaptersTableView  && selectedSegment == Constants.THERAPY_LIBRARY_VIEW){
            return chapters.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedSegment = self.TherapySegment.selectedSegmentIndex
        var cellIdentifier = ""
        var cell:UITableViewCell?
        let bgView = UIView()
        let arrayIndex = indexPath.row
        
        switch (selectedSegment) {
        case Constants.THERAPY_NEWS_VIEW: //news
            do {
                cellIdentifier = "TherapyNewsCell"
                
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                if (cell == nil) {
                    cell = TherapyNewsCell(style: .default, reuseIdentifier: cellIdentifier)
                }
                
                // Configure the cell.
                
                if (itemsToDisplay[arrayIndex] != nil) {
                    // Process
                    let itemTitle = (itemsToDisplay[arrayIndex].title != nil) ? String(NSString(string: itemsToDisplay[arrayIndex].title).convertingHTMLToPlainText()) : "[No Title]"
                    // Set
                    var subtitle = ""
                    if let date = itemsToDisplay[arrayIndex].date {
                        subtitle = formatter.string(from: date)
                    }

                    (cell as? TherapyNewsCell)?.TopicDate?.text = subtitle
                    (cell as? TherapyNewsCell)?.TopicTitle?.text = itemTitle
                }
                
                bgView.backgroundColor = UIColor(red:243.0/255.0, green:250.0/255.0, blue:212.0/255.0, alpha:1).withAlphaComponent(1) //light green
                cell?.selectedBackgroundView = bgView
                cell?.isHidden = false
                break
            }
        case Constants.THERAPY_LIBRARY_VIEW: //library of books
            do {
                if(tableView == self.ChaptersTableView){
                    cellIdentifier = "TherapyChapterCell"
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                    if (cell == nil) {
                        cell = TherapyChapterCell(style: .default, reuseIdentifier: cellIdentifier)
                    }
                    
                    (cell as? TherapyChapterCell)?.ChapterTitle.text = chapters[arrayIndex].chapterTitle
                    
                    bgView.backgroundColor = UIColor(red:255.0/255.0, green:239.0/255.0, blue:230.0/255.0, alpha:1).withAlphaComponent(1) //light Orange
                    cell?.selectedBackgroundView = bgView
                    
                }else if(tableView == self.BooksTableView){
                    cellIdentifier = "TherapyBooksCell"
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                    if (cell == nil) {
                        cell = TherapyBooksCell(style: .default, reuseIdentifier: cellIdentifier)
                    }
                    
                    (cell as? TherapyBooksCell)?.BookAuthor.text = books[arrayIndex].bookAuthor
                    (cell as? TherapyBooksCell)?.BookTitle.text = books[arrayIndex].bookTitle
                    (cell as? TherapyBooksCell)?.BookTopic.text = books[arrayIndex].bookCategory
                    
                    bgView.backgroundColor = UIColor(red:243.0/255.0, green:250.0/255.0, blue:212.0/255.0, alpha:1).withAlphaComponent(1) //light grey
                    cell?.selectedBackgroundView = bgView
                    
                }
                break
            }
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSegment = self.TherapySegment.selectedSegmentIndex
        switch (selectedSegment) {
        case Constants.THERAPY_NEWS_VIEW: //news
            do {
                self.TherapyTitleLabel.text = "Aljazeera - مباشر"
                if(previousSegment == selectedSegment && previousIndexRow == indexPath.row){
                    return
                }else{
                    previousIndexRow = indexPath.row
                }
                if(userIsReading){
                    completeTherapyInterval()
                }
                
                let selectedItem = itemsToDisplay[indexPath.row]
                currentChapterId = 0
                
                
            runTherapyTableCellItem(String(NSString(string:selectedItem.summary).convertingHTMLToPlainText()), String(NSString(string: selectedItem.title).convertingHTMLToPlainText()))
                break
            }
        case Constants.THERAPY_LIBRARY_VIEW: //Chapter and Books
            do {
                if(tableView == self.ChaptersTableView) {
                    if(previousSegment == selectedSegment && previousIndexRow == indexPath.row){
                        return
                    }else{
                        previousIndexRow = indexPath.row
                    }
                    
                    if(userIsReading){
                        completeTherapyInterval()
                    }
                    
                    currentChapterId = chapters[indexPath.row].chapterId ?? 0
                    
                    if let url = URL(string: chapters[indexPath.row].chapterUrl ?? "") {
                        let req = URLRequest(url: url)
                        self.view.showActivityView()
                        let session:URLSessionDataTask = URLSession.shared.dataTask(with: req, completionHandler: { data, response, error in
                            DispatchQueue.main.async {
                                if let data = data {
                                    
                                    if let content = String(data: data, encoding: .utf8), let title = self.chapters[indexPath.row].chapterTitle {
                                        self.runTherapyTableCellItem(String(NSString(string:content).convertingHTMLToPlainText()), title)
                                    }
                                }
                                self.view.hideActivityView()
                            }
                        })
                        session.resume()
                    }
                }else if(tableView == self.BooksTableView){
                    //reload the chapter table with the it's chapters
                    self.TherapyTitleLabel.text = books[indexPath.row].bookTitle
                    currentBookId = books[indexPath.row].bookId ?? 0
                    viewModel.readingBookID = currentBookId
                    
                    viewModel.requestChapters()
                    
                }
                
                break
            }
        default: break
        }
    }
}

extension ReadingVC: MWFeedParserDelegate {
    func feedParserDidStart(_ parser:MWFeedParser) {
        parsedItems.removeAll()
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        
    }
    
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if let item = item {
            parsedItems.append(item)
        }
    }
    
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        updateNewsTableWithParsedItems()
        self.TherapySegment.isUserInteractionEnabled = true
    }

    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        self.TherapySegment.isUserInteractionEnabled = true
        if (parsedItems.count == 0) {
        } else {
            // Failed but some items parsed, so show and inform of error
            let alert = UIAlertController(title: "Parsing Incomplete", message: "There was an error during the parsing of this feed. Not all of the feed items could parsed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        updateNewsTableWithParsedItems()
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

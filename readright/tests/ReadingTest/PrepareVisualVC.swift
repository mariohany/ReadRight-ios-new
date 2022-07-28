//
//  PrepareVisualVC.swift
//  readright
//
//  Created by user225703 on 7/11/22.
//

import AVFoundation
import UIKit

class PrepareVisualVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak private var InstructionView: CustomView!
    @IBOutlet weak private var PrepareView: CustomView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var pageControl: CustomPageControl!
    var audioPlayer: AVAudioPlayer?
    var pageInstructionNumber:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: Helpers(), action: #selector(Helpers.popToTestsController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem;

        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 2
        self.pageChanged(self.pageControl)
        self.pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        let subviewMain:UIView? =  Bundle.main.loadNibNamed("InstructionsVisual", owner: self, options: nil)?.last as? UIView
        if let subV = subviewMain {
            self.scrollView.addSubview(subV)
            self.scrollView.contentSize = CGSize(width: subV.frame.size.width, height: subV.frame.size.height)
        }
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
    }

    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار المجال البصري"
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber:Int = Int(roundf(Float(self.scrollView.contentOffset.x / (self.scrollView.frame.size.width))))
        self.pageControl.currentPage = pageNumber
        pageInstructionNumber = 2 - Int(pageNumber)
        audioPlayer = nil
    }
    
    @IBAction private func prepareVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.PREPARE_VISUAL_VOICE_OVER)
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying {
                audioPlayer.currentTime = 0
                audioPlayer.play()
            }else{
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }else{
            audioPlayer?.play()
        }
    }
    
    @IBAction private func instructionVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.INSTRUCTIONS_VISUAL_VOICE_OVER_ARRAY[pageInstructionNumber])
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying {
                audioPlayer.currentTime = 0
                audioPlayer.play()
            }else{
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }else{
            audioPlayer?.play()
        }
    }
    
    @IBAction private func startInstruction(){
        audioPlayer = nil
        self.InstructionView.isHidden = false
        self.PrepareView.isHidden = true
    }
    
    @IBAction private func startVisualTest(){
        audioPlayer = nil
        performSegue(withIdentifier: "StartVisualFieldTest", sender: self)
    }
    
    @IBAction private func backIntro(){
        audioPlayer = nil
        self.InstructionView.isHidden = true
        self.PrepareView.isHidden = false
    }
    
    @IBAction private func pageChanged(_ sender:CustomPageControl){
        audioPlayer = nil
        let x:CGFloat = CGFloat(self.pageControl.currentPage) * self.scrollView.frame.size.width
        self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        self.pageControl.updateDots()
    }
}





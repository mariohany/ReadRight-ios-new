//
//  PreReadingTestVC.swift
//  readright
//
//  Created by concarsadmin-mh on 03/05/2022.
//

import Foundation
import AVFoundation
import UIKit

class PreReadingTestVC: UIViewController{
    @IBOutlet weak private var PrepareView: CustomView!
    @IBOutlet weak private var InstructionsView: CustomView!
    @IBOutlet weak private var MainTitle: UILabel!
    var audioPlayer: AVAudioPlayer?
    var readingTestNo:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: Helpers(), action: #selector(Helpers.popToTestsController))
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = String(format: "%@", " اختبار القراءة ", Helpers.arabicCharacter(englishNumber: self.readingTestNo))
        self.MainTitle.text = String(format: "%@", " اختبار القراءة ", Helpers.arabicCharacter(englishNumber: self.readingTestNo))
    }
    
    @IBAction private func showInstructions(){
        self.PrepareView.isHidden = true
        self.InstructionsView.isHidden = false
        audioPlayer = nil
    }
    
    @IBAction private func backIntro(){
        audioPlayer = nil
        self.InstructionsView.isHidden = true
        self.PrepareView.isHidden = false
    }
    
    @IBAction private func startReadingTest(){
        audioPlayer = nil
        performSegue(withIdentifier: "StartReadingTest", sender: self)
    }
    
    @IBAction private func prepareReadingTestVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.PREPARE_READING_VOICE_OVER)
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
    
    @IBAction private func instructionsReadingtestVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.INSTRUCTIONS_READING_VOICE_OVER)
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
    
    
}

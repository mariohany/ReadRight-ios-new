//
//  PrepareADLTestVC.swift
//  readright
//
//  Created by user225703 on 7/13/22.
//

import AVFoundation
import UIKit

class PrepareADLTestVC: UIViewController {
    @IBOutlet weak private var PrepareView: CustomView!
    @IBOutlet weak private var InstructionsView: CustomView!
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popToTestsController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func popToTestsController(){
        if let destinationViewController = self.navigationController?.viewControllers.filter({$0 is ReadingVC}).first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }


    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "تقييم أنشطة الحياه اليومية"
    }
    
    @IBAction private func showInstructions() {
        audioPlayer = nil
        self.PrepareView.isHidden = true
        self.InstructionsView.isHidden = false
    }

    @IBAction private func backIntro() {
        audioPlayer = nil
        self.InstructionsView.isHidden = true
        self.PrepareView.isHidden = false
    }

    @IBAction private func startReadingTest(){
        audioPlayer = nil
        performSegue(withIdentifier: "StartADLTest", sender: self)
    }

    @IBAction private func prepareVoiceOver() {
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.PREPARE_ADL_VOICE_OVER)
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
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.INSTRUCTIONS_ADL_VOICE_OVER)
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

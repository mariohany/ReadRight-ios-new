//
//  PrepareNeglectVC.swift
//  readright
//
//  Created by user225703 on 7/21/22.
//

import AVFoundation
import UIKit

class PrepareNeglectVC: UIViewController {
    @IBOutlet weak private var PrepareView: CustomView!
    @IBOutlet weak private var InstructionsView: CustomView!
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: Helpers.self, action: #selector(Helpers.popToTestsController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func goTestsBackBtn(){
        if let array = self.navigationController?.viewControllers {
            self.navigationController?.popToViewController(array[1], animated: true)
        }
    }

    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار الإهمال البصري"
    }
    

    @IBAction private func showInstructions(){
        audioPlayer = nil
        self.PrepareView.isHidden = true
        self.InstructionsView.isHidden = false
    }
    
    @IBAction private func startNeglectTest(){
        audioPlayer = nil;
        self.performSegue(withIdentifier: "StartNeglectTest", sender:self)
    }
    
    @IBAction private func backToIntro(){
        audioPlayer = nil;
        self.InstructionsView.isHidden = true
        self.PrepareView.isHidden = false
    }

    @IBAction private func prepareVoiceOver(){
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.PREPARE_NEGLECT_VOICE_OVER)
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
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.INSTRUCTIONS_NEGLECT_VOICE_OVER)
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

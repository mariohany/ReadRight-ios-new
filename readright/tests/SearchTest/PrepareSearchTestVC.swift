//
//  PrepareSearchTestVC.swift
//  readright
//
//  Created by user225703 on 7/17/22.
//

import AVFoundation


class PrepareSearchTestVC: UIViewController {
    @IBOutlet weak private var PrepareView: CustomView!
    @IBOutlet weak private var InstructionsView: CustomView!
    var audioPlayer:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let backImage = UIImage(named:"TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image:backImage, style:.plain, target:Helpers.self, action:#selector(Helpers.popToTestsController))
        self.navigationItem.leftBarButtonItem = barButtonItem
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار البحث النظري"
    }

    @IBAction private func prepareSearchVoiceOver() {
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.PREPARE_SEARCH_VOICE_OVER)
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

    @IBAction private func instructionVoiceOver() {
        audioPlayer = Helpers.getAudioPlayer(fileName: Constants.INSTRUCTIONS_SEARCH_VOICE_OVER)
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

    @IBAction private func startSearchTest() {
        audioPlayer = nil
        performSegue(withIdentifier: "StartSearchTest", sender: self)
    }
}

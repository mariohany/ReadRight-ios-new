//
//  Help.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import Foundation
import UIKit
import WebKit
import AVKit
import MessageUI

class HelpVC: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak private var aboutBtn: UIButton!
    @IBOutlet weak private var faqBtn: UIButton!
    @IBOutlet weak private var therapyBtn: UIButton!
    @IBOutlet weak private var readingBtn: UIButton!
    @IBOutlet weak private var visualBtn: UIButton!
    @IBOutlet weak private var neglectBtn: UIButton!
    @IBOutlet weak private var desktopBtn: UIButton!
    @IBOutlet weak private var adlBtn: UIButton!
    @IBOutlet weak private var contactUsBtn: UIButton!
    @IBOutlet weak private var aboutView: UIView!
    @IBOutlet weak private var videoView: UIView!
    @IBOutlet weak private var webview: WKWebView!
    private var player: AVPlayerViewController?
    private var mailCont: MFMailComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutView.isHidden = false
        videoView.isHidden = true
        webview.isHidden = true
        webview.scrollView.delegate = self
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.scrollView.contentOffset = CGPoint(x: 10, y: 0)
        webview.isOpaque = false
        let url = URL(string:"https://arabic-readright.com/faq.html")
        if let url = url {
            let urlRequest = URLRequest(url: url)
            webview.load(urlRequest)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "مساعدة"
        self.navigationController?.navigationBar.topItem?.title = "مساعدة"
    }
    
    @IBAction private func pressAbout(){
        if(!self.aboutBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = true
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = true
            self.webview.isHidden = true
            self.aboutView.isHidden = false
        }
    }
    @IBAction private func pressFac(){
        if(!self.faqBtn.isSelected){
            self.faqBtn.isSelected = true
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = true
            self.webview.isHidden = false
            self.aboutView.isHidden = true
        }
    }
    @IBAction private func pressTherapy(){
        if(!self.therapyBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = true
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = false
            self.webview.isHidden = true
            self.aboutView.isHidden = true
            addVideoWithName(urlString: "https://arabic-readright.com/videos/Therapy.m4v")
        }
    }
    @IBAction private func pressReading(){
        if(!self.readingBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = true
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = false
            self.webview.isHidden = true
            self.aboutView.isHidden = true
            addVideoWithName(urlString: "https://arabic-readright.com/videos/Reading.m4v")
        }
    }
    @IBAction private func pressVisual(){
        if(!self.visualBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = true
            
            self.videoView.isHidden = false
            self.webview.isHidden = true
            self.aboutView.isHidden = true
            addVideoWithName(urlString: "https://arabic-readright.com/videos/Visual.m4v")
        }
    }
    @IBAction private func pressNeglect(){
        if(!self.neglectBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = true
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = false
            self.webview.isHidden = true
            self.aboutView.isHidden = true
            addVideoWithName(urlString: "https://arabic-readright.com/videos/Neglect.m4v")
        }
    }
    @IBAction private func pressDesktop(){
        if(!self.desktopBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = false
            self.desktopBtn.isSelected = true
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = false
            self.webview.isHidden = true
            self.aboutView.isHidden = true
            addVideoWithName(urlString: "https://arabic-readright.com/videos/ADL.m4v")
        }
    }
    @IBAction private func pressAdl(){
        if(!self.adlBtn.isSelected){
            self.faqBtn.isSelected = false
            self.readingBtn.isSelected = false
            self.aboutBtn.isSelected = false
            self.therapyBtn.isSelected = false
            self.neglectBtn.isSelected = false
            self.adlBtn.isSelected = true
            self.desktopBtn.isSelected = false
            self.visualBtn.isSelected = false
            
            self.videoView.isHidden = false
            self.webview.isHidden = true
            self.aboutView.isHidden = true
            addVideoWithName(urlString: "https://arabic-readright.com/videos/Desktop.m4v")
        }
    }
    @IBAction private func pressContactUs(){
        if(MFMailComposeViewController.canSendMail()) {
            mailCont = MFMailComposeViewController()
            mailCont?.mailComposeDelegate = self;
            mailCont?.setSubject("ReadRight")
            mailCont?.setToRecipients(["Info@arabic-readright.com"])
            mailCont?.setMessageBody("Hello,", isHTML: false)
            if let controler = mailCont {
                self.present(controler, animated: true, completion: nil)
            }
        }
    }
    
    func addVideoWithName(urlString:String){
        let url = URL(string: urlString)
        if let url = url {
            UIGraphicsBeginImageContext(CGSize(width: 1,height: 1))
            player?.view?.removeFromSuperview()
            
            player = AVPlayerViewController()
            
            let playerItem = AVPlayerItem(url: url)
            let playVideo = AVPlayer(playerItem: playerItem)
            player?.player = playVideo
            
            UIGraphicsEndImageContext()
            
            player?.view.frame = self.videoView.bounds
            if let view = player?.view {
                self.videoView.addSubview(view)
            }
            player?.player?.play()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
    
    func webView(_ wv: WKWebView, didFinish navigation: WKNavigation!) {
        let rw = 0.94
        
        wv.scrollView.minimumZoomScale = rw
        wv.scrollView.maximumZoomScale = rw
        wv.scrollView.zoomScale = rw
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        mailCont?.dismiss(animated: true, completion: nil)
    }
}

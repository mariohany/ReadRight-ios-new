//
//  ResultNeglectTestVC.swift
//  readright
//
//  Created by user225703 on 7/21/22.
//

import Foundation


class ResultNeglectTestVC: UIViewController{
    
    @IBOutlet weak private var ScoreTextField:UILabel!
    var ResultScore:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "TestsBackIcons")?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popToTestsController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.ScoreTextField.text = "\(String(self.ResultScore))%"
    }
    
    @objc func popToTestsController(){
        if let destinationViewController = self.navigationController?.viewControllers.filter({$0 is ReadingVC}).first {
            navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }


    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        self.navigationItem.title = "اختبار الإهمال البصري"
    }

    @IBAction private func goNextTest() {
        self.popToTestsController()
    }
}

//
//  VisualCanvasView.swift
//  readright
//
//  Created by concarsadmin-mh on 12/03/2022.
//

import Foundation
import UIKit

class VisualCanavasView: UIView {
    @IBOutlet weak private var crossHair: UIImageView!
    
    @IBOutlet weak private var dot1_1: CustomView!
    @IBOutlet weak private var dot1_2: CustomView!
    @IBOutlet weak private var dot1_3: CustomView!
    @IBOutlet weak private var dot1_4: CustomView!
    
    @IBOutlet weak private var dot2_1: CustomView!
    @IBOutlet weak private var dot2_2: CustomView!
    @IBOutlet weak private var dot2_3: CustomView!
    @IBOutlet weak private var dot2_4: CustomView!
    
    @IBOutlet weak private var dot3_1: CustomView!
    @IBOutlet weak private var dot3_2: CustomView!
    @IBOutlet weak private var dot3_3: CustomView!
    @IBOutlet weak private var dot3_4: CustomView!
    
    @IBOutlet weak private var dot4_1: CustomView!
    @IBOutlet weak private var dot4_2: CustomView!
    @IBOutlet weak private var dot4_3: CustomView!
    @IBOutlet weak private var dot4_4: CustomView!
    
    @IBOutlet weak private var outer1: UIImageView!
    @IBOutlet weak private var outer2: UIImageView!
    @IBOutlet weak private var outer3: UIImageView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        Bundle.main.loadNibNamed("CanvasView", owner: self, options: nil)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
//        Bundle.main.loadNibNamed("CanvasView", owner: self, options: nil)
    }
//    convenience init(){
//        self.init()
//        Bundle.main.loadNibNamed("CanvasView", owner: self, options: nil)
//    }
    
    func peformQuestion(views:[UIView], showAnswers: @escaping (_ finished:Bool) -> Void) {
        doStartAnimation { finished in
            self.setAllDotsAlphas()
            self.setAllDotsHidden(isHidden: true)
            self.setHiddenViews(views: views, isHidden: false)
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.setViewsAlpha(views: views, alpha: 0)
            }, completion: { finished in
                let delayInSeconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + (delayInSeconds * Double(NSEC_PER_SEC))) {
                    showAnswers(finished)
                }
            })
        }
    }
    
    
    func setAllDotsAlphas() {
        self.dot1_1.alpha = CGFloat(0.72)
        self.dot1_2.alpha = CGFloat(0.72)
        self.dot1_3.alpha = CGFloat(0.72)
        self.dot1_4.alpha = CGFloat(0.72)
        
        self.dot1_1.backgroundColor = UIColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        self.dot1_2.backgroundColor = UIColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        self.dot1_3.backgroundColor = UIColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        self.dot1_4.backgroundColor = UIColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        
        self.dot1_1.layer.borderColor = CGColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        self.dot1_2.layer.borderColor = CGColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        self.dot1_3.layer.borderColor = CGColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        self.dot1_4.layer.borderColor = CGColor(red:184/255.0, green:184.0/255.0, blue:184.0/255.0, alpha:1)
        
        
        self.dot2_1.alpha = CGFloat(0.7)
        self.dot2_2.alpha = CGFloat(0.7)
        self.dot2_3.alpha = CGFloat(0.7)
        self.dot2_4.alpha = CGFloat(0.7)
        
        self.dot2_1.backgroundColor = UIColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        self.dot2_2.backgroundColor = UIColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        self.dot2_3.backgroundColor = UIColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        self.dot2_4.backgroundColor = UIColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        
        self.dot2_1.layer.borderColor = CGColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        self.dot2_2.layer.borderColor = CGColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        self.dot2_3.layer.borderColor = CGColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        self.dot2_4.layer.borderColor = CGColor(red:179/255.0, green:179.0/255.0, blue:179.0/255.0, alpha:1)
        
        
        self.dot3_1.alpha = CGFloat(0.66)
        self.dot3_2.alpha = CGFloat(0.66)
        self.dot3_3.alpha = CGFloat(0.66)
        self.dot3_4.alpha = CGFloat(0.66)
        
        self.dot3_1.backgroundColor = UIColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        self.dot3_2.backgroundColor = UIColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        self.dot3_3.backgroundColor = UIColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        self.dot3_4.backgroundColor = UIColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        
        self.dot3_1.layer.borderColor = CGColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        self.dot3_2.layer.borderColor = CGColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        self.dot3_3.layer.borderColor = CGColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        self.dot3_4.layer.borderColor = CGColor(red:168/255.0, green:168.0/255.0, blue:168.0/255.0, alpha:1)
        
        
        self.dot4_1.alpha = CGFloat(0.55)
        self.dot4_2.alpha = CGFloat(0.55)
        self.dot4_3.alpha = CGFloat(0.55)
        self.dot4_4.alpha = CGFloat(0.55)
        
        self.dot4_1.backgroundColor = UIColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        self.dot4_2.backgroundColor = UIColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        self.dot4_3.backgroundColor = UIColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        self.dot4_4.backgroundColor = UIColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        
        self.dot4_1.layer.borderColor = CGColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        self.dot4_2.layer.borderColor = CGColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        self.dot4_3.layer.borderColor = CGColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
        self.dot4_4.layer.borderColor = CGColor(red:140/255.0, green:140.0/255.0, blue:140.0/255.0, alpha:1)
    }
    
    func setAllDotsHidden(isHidden:Bool) {
        self.dot1_1.isHidden = isHidden
        self.dot1_2.isHidden = isHidden
        self.dot1_3.isHidden = isHidden
        self.dot1_4.isHidden = isHidden
        
        self.dot2_1.isHidden = isHidden
        self.dot2_2.isHidden = isHidden
        self.dot2_3.isHidden = isHidden
        self.dot2_4.isHidden = isHidden
        
        self.dot3_1.isHidden = isHidden
        self.dot3_2.isHidden = isHidden
        self.dot3_3.isHidden = isHidden
        self.dot3_4.isHidden = isHidden
        
        self.dot4_1.isHidden = isHidden
        self.dot4_2.isHidden = isHidden
        self.dot4_3.isHidden = isHidden
        self.dot4_4.isHidden = isHidden
    }
    
    func performQuestion(questionNo:Int, showAnswers: @escaping (_ finished:Bool) -> Void){
        
        let circle:Int = questionNo / 9 + 1
        let mode:Int = questionNo % 9
        let views = getViewsFromCircle(circle: circle, mode: mode) as? [UIView]
        if let views = views {
            self.peformQuestion(views: views){ finished in
                showAnswers(finished)
            }
        }
    }
    
    func getViewsFromCircle(circle:Int, mode:Int) -> [Any?]? {
        switch (mode) {
        case 0://A
            do {
                let point1:String = String(format: "dot%d_%d", circle,1)
                let point2:String = String(format: "dot%d_%d", circle,2)
                let point3:String = String(format: "dot%d_%d", circle,3)
                let point4:String = String(format: "dot%d_%d", circle,4)
                let views:[Any?] = [value(forKey: point1), value(forKey: point2), value(forKey: point3), value(forKey: point4)]
                return views
            }
        case 1://B
            do {
                let point1 = String(format: "dot%d_%d", circle,2)
                let point2 = String(format: "dot%d_%d", circle,3)
                let views:[Any?] = [value(forKey: point1), value(forKey: point2)]
                return views
            }
        case 2://C
            do {
                let point1 = String(format: "dot%d_%d", circle,1)
                let point2 = String(format: "dot%d_%d", circle,4)
                let views:[Any?] = [value(forKey: point1), value(forKey: point2)]
                return views
            }
        case 3://D
            do {
                let point1 = String(format: "dot%d_%d", circle,3)
                let point2 = String(format: "dot%d_%d", circle,4)
                let views:[Any?] = [value(forKey: point1), value(forKey: point2)]
                return views
            }
        case 4://E
            do {
                let point1 = String(format: "dot%d_%d", circle,1)
                let point2 = String(format: "dot%d_%d", circle,2)
                let views:[Any?] = [value(forKey: point1), value(forKey: point2)]
                return views
            }
        case 5://F
            do {
                let point1 = String(format: "dot%d_%d", circle,3)
                let views:[Any?] = [value(forKey: point1)]
                return views
            }
        case 6://G
            do {
                let point1 = String(format: "dot%d_%d", circle,2)
                let views:[Any?] = [value(forKey: point1)]
                return views
            }
        case 7://H
            do {
                let point1 = String(format: "dot%d_%d", circle,4)
                let views:[Any?] = [value(forKey: point1)]
                return views
            }
        case 8://I
            do {
                let point1 = String(format: "dot%d_%d", circle,1)
                let views:[Any?] = [value(forKey: point1)]
                return views
            }
        default:
            break
        }
        return nil
    }
    
    func prepareVisualPoint(x:Int, y:Int)-> UIView {
        let dot = UIView(frame: CGRect(x: x, y: y, width: 25, height: 25))
        dot.layer.borderWidth = 1.0
        dot.layer.cornerRadius = 13
        dot.backgroundColor = UIColor(ciColor: .black)
        return dot
    }
    
    func doStartAnimation(completionTest: @escaping (_ finished:Bool) -> Void) {
        
        self.outer1.isHidden = false
        self.outer1.alpha = 1
        
        UIView.animate(withDuration: 0.666, delay: 0.0, options: .layoutSubviews, animations: {
            self.outer1.alpha = 0
        }, completion: { finished in
            self.outer2.isHidden = false
            self.outer2.alpha = 1
            
            UIView.animate(withDuration: 0.666, delay: 0.0, options: .curveEaseInOut, animations: {
                self.outer2.alpha = 0
            }, completion: { finished in
                self.outer3.isHidden = false
                self.outer3.alpha = 1
                
                UIView.animate(withDuration: 0.666, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.outer3.alpha = 0
                }, completion: { finished in
                    
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.crossHair.alpha = 0
                    }, completion: { finished in
                        self.crossHair.alpha = 1
                        self.outer3.alpha = 1
                        self.outer3.isHidden = true
                        
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.outer3.alpha = 0
                        }, completion: { finished in
                            completionTest(finished)
                        })
                    })
                })
            })
        })
    }
    
    func setHiddenViews(views:[UIView], isHidden:Bool) {
        for view in views {
            view.isHidden = isHidden
        }
    }
    
    func setViewsAlpha(views:[UIView], alpha:Float) {
        for view in views {
            view.alpha = CGFloat(alpha)
        }
    }
}

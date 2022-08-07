//
//  SearchCanavasView.swift
//  readright
//
//  Created by user225703 on 8/5/22.
//

import Foundation
import UIKit


@objc protocol SearchCanvasViewDelegate {
    func didSelectItemWithTag(_ tag: Int)
}


@IBDesignable class SearchCanvasView: UIView {
    var parent:SearchCanvasViewDelegate?
    var numberOfTargets:Int?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    @IBAction private func selectItem(sender:UIButton) {
        let itemBtn = sender
        if let parent = self.parent, responds(to: #selector(parent.didSelectItemWithTag)) {
            parent.didSelectItemWithTag(itemBtn.tag)
        }
    }

    func isSelectetTarget(_ tag:Int) -> Bool{
        let itemBtn:UIButton = self.viewWithTag(tag) as! UIButton
        return itemBtn.isSelected
    }

    func doCorrectItem(_ tag:Int){
        let itemBtn:UIButton = self.viewWithTag(tag) as! UIButton
        let itemName:String = SearchTestHelper.getItemName(itemBtn.tag)
        let selectedImageName:String = String(format: "%@-correct", itemName)
        itemBtn.setImage(UIImage(named:selectedImageName), for: .selected)
        
        let correctView:UIImageView = UIImageView(image: UIImage(named:"Item_Correct"))

        let rotationDegree:Float = -1 * atan2f(Float(itemBtn.transform.b), Float(itemBtn.transform.a))

        correctView.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDegree))

        correctView.center = CGPoint(x: itemBtn.bounds.size.width/2 + itemBtn.bounds.origin.x, y: itemBtn.bounds.size.height/2+itemBtn.bounds.origin.y)
        itemBtn.addSubview(correctView)
        
        //    [[self viewWithTag: itemBtn.tag] setHidden:YES];
        itemBtn.isSelected = true
    }

    func doWrongItem(_ tag:Int) {
        let itemBtn:UIButton = viewWithTag(tag) as! UIButton
        let itemName:String = SearchTestHelper.getItemName(itemBtn.tag)
        let selectedImageName:String = String(format:"%@-wrong",itemName)
        itemBtn.setImage(UIImage(named:selectedImageName), for:.selected)
        
        let correctView:UIImageView = UIImageView(image: UIImage(named:"Item_Wrong"))
        
        let rotationDegree:Float = -1 * atan2f(Float(itemBtn.transform.b), Float(itemBtn.transform.a));
        
        correctView.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDegree));
        correctView.center = CGPoint(x: itemBtn.bounds.size.width/2 + itemBtn.bounds.origin.x,y: itemBtn.bounds.size.height/2+itemBtn.bounds.origin.y);
        correctView.tag = 100
        //    correctView.center = CGPointMake(0, itemBtn.frame.size.height / 2);
        itemBtn.addSubview(correctView)
        
        //    [[self viewWithTag: itemBtn.tag] setHidden:YES];
        itemBtn.isSelected = true
        self.perform(#selector(undoWrongItem), with: tag, afterDelay: 1)
    }

    @objc func undoWrongItem(_ tag:Int){
        let itemBtn:UIButton = viewWithTag(tag) as! UIButton
        let itemName:String = SearchTestHelper.getItemName(itemBtn.tag)
        let normalImageName:String = String(format:"%@",itemName)
        itemBtn.setImage(UIImage(named:normalImageName), for:.normal)

        let wrongMark = viewWithTag(100) as! UIImageView
        wrongMark.removeFromSuperview()
        
        itemBtn.isSelected = false
    }

    func removeTargets(){
       for placedView in self.subviews {
           if(placedView.tag >= 0 && placedView.tag < self.numberOfTargets! ){
               placedView.removeFromSuperview()
           }
       }
    }

    func randamizeItems(_ isLeft:Bool, _ target:Int){
        var targetNumber:Int = 0

        let viewWidth:Float = Float(self.frame.size.width)
        let viewHeight:Float = Float(self.frame.size.height)

        var img:UIImage?
        var randomDegree:Float?
        var xEndBoundry:Float?
        var xStartBoundry:Float = 0
        var yBoundry:Float?
        let sizeRatio:Float = 1.1
        var candidatateWidth:Float?
        var candidateHeight:Float?
        self.removeTargets()

        while (targetNumber < self.numberOfTargets!) {
            var goodView = true
            let candidateView:UIButton = UIButton(type: .custom)
            img = UIImage(named:SearchTestHelper.getItemName(targetNumber))
            candidatateWidth = Float(img!.size.width) / sizeRatio
            candidateHeight = Float(img!.size.height) / sizeRatio
            xEndBoundry = viewWidth - candidatateWidth! / 2
            yBoundry = viewHeight - candidateHeight! / 2
            xStartBoundry = 0
            
            if(targetNumber == target){
                xEndBoundry = viewWidth/2 - candidatateWidth! / 2; //left or right
                if(!isLeft){ //right target
                    xStartBoundry = xEndBoundry!
                }
            }
            

            candidateView.frame = CGRect(x:CGFloat(Float(arc4random_uniform(UInt32(xEndBoundry!))) + xStartBoundry), y:CGFloat(arc4random_uniform(UInt32(yBoundry!))), width:CGFloat(candidatateWidth!), height:CGFloat(candidateHeight!))
            candidateView.tag = targetNumber
            candidateView.setImage(img, for:.normal)
            candidateView.addTarget(self, action: #selector(selectItem), for: .touchUpInside)
            candidateView.contentMode = .scaleToFill
            randomDegree = Float(arc4random_uniform(360))
            candidateView.transform = CGAffineTransform(rotationAngle: Double((randomDegree ?? 0)) * .pi / 180)

            
            for placedView in self.subviews {
                
                if (candidateView.frame.intersects(placedView.frame)) {
                    randomDegree = Float(arc4random_uniform(360))
                    candidateView.transform = CGAffineTransform(rotationAngle:Double((randomDegree ?? 0)) * .pi / 180)
                    goodView = false
                    break
                }
            }
            if (goodView) {
                self.addSubview(candidateView)
                targetNumber += 1
            }
        }

    }
}

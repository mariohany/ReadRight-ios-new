//
//  NeglectCanvasView.swift
//  readright
//
//  Created by user225703 on 8/18/22.
//

import Foundation
import UIKit


let CORRECT_TARGET_TAG:Int = 1
let CORRECT_TARGET_VISITED_TAG:Int = 2

let DISTRACTOR_TAG_COMPLETE_CIRCLE:Int = 3
let DISTRACTOR_VISITED_TAG_COMPLETE_CIRCLE:Int = 4

let DISTRACTOR_TAG_LOWER_CIRCLE:Int = 5
let DISTRACTOR_VISITED_TAG_LOWER_CIRCLE:Int = 6

let ANIMATION_PERIOD:Double = 0.5

protocol NeglectCanvasViewDelegate {
    func didSelectNewTarget(x:Int, y:Int)
    func didSelectDistractorTarget(x:Int, y:Int)
    func didSelectRevisitedDistractorTarget(x:Int, y:Int)
    func didSelectVisitedTarget(x:Int, y:Int)
    func didMissTarget(leftMissedTargetsCount:Int, rightMissedTargetsCount:Int)
}

@IBDesignable class NeglectCanvasView: UIView {
    var parent:NeglectCanvasViewDelegate?
    var elementsArray:[NetworkModels.Elements] = []
    var hitsPath:[NetworkModels.HitsPath] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func removeTargets(){
        for placedView in self.subviews {
            if(placedView.tag >= 0) {
                placedView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func selectTarget(sender:UIButton) {
        let itemBtn = sender
        let tag:Int = itemBtn.tag
        
        switch (tag) {
            case CORRECT_TARGET_TAG:
            do {
                let x:Int = Int((itemBtn.frame.origin.x - self.frame.size.width / 2) + itemBtn.frame.size.width / 2)
                let y:Int = -1 * Int(((itemBtn.frame.origin.y - self.frame.size.height / 2) + itemBtn.frame.size.height / 2))
                self.parent?.didSelectNewTarget(x: x, y: y)
                itemBtn.tag = CORRECT_TARGET_VISITED_TAG
                itemBtn.setImage(UIImage(named:"SelectedCircle"), for: .normal)
                self.perform(#selector(undoCorrectHighlightItem), with: itemBtn, afterDelay: ANIMATION_PERIOD)
                
                break
            }
            case CORRECT_TARGET_VISITED_TAG:
            do {
                let x:Int = Int((itemBtn.frame.origin.x - self.frame.size.width / 2) + itemBtn.frame.size.width / 2)
                let y:Int = -1 * Int(((itemBtn.frame.origin.y - self.frame.size.height / 2) + itemBtn.frame.size.height / 2))
                self.parent?.didSelectVisitedTarget(x: x, y: y)
                itemBtn.setImage(UIImage(named:"SelectedCircle"), for:.normal)
                self.perform(#selector(undoCorrectHighlightItem), with: itemBtn, afterDelay: ANIMATION_PERIOD)
                break
            }
        default:
            break
        }
        
        self.updateClicksCount(sender)
        self.numOfLeftTargets()
    }


    @objc func undoCorrectHighlightItem(_ itemBtn:UIButton){
        itemBtn.setImage(UIImage(named:"UpperCircle"), for:.normal)
    }

    @objc func undoHighlightCompletedWrongItem(_ itemBtn:UIButton){
        itemBtn.setImage(UIImage(named:"CompleteCircle"), for:.normal)
    }


    @objc func undoHighlightLowerWrongItem(_ itemBtn:UIButton){
        itemBtn.setImage(UIImage(named:"LowerCircle"), for:.normal)
    }

    func numOfLeftTargets() {
        var leftTargets:Int = 0
        var rightTargets:Int = 0
        for placedView in self.subviews {
            if(placedView.tag == CORRECT_TARGET_TAG) {
                let centerX:Int = Int(placedView.frame.origin.x + placedView.frame.size.width / 2)
                if (centerX < Int(self.frame.size.width / 2)) {
                    leftTargets+=1
                } else {
                    rightTargets+=1
                }
            }
        }
        self.parent?.didMissTarget(leftMissedTargetsCount: leftTargets, rightMissedTargetsCount: rightTargets)
    }



    @IBAction func selectWrongTarget(sender:UIButton) {
        let itemBtn:UIButton = sender
        let tag:Int = itemBtn.tag
        switch (tag) {
            case DISTRACTOR_TAG_COMPLETE_CIRCLE: do {
                let x = (itemBtn.frame.origin.x - self.frame.size.width / 2) + itemBtn.frame.size.width / 2
                let y = -1 * ((itemBtn.frame.origin.y - self.frame.size.height / 2) + itemBtn.frame.size.height / 2)
                self.parent?.didSelectDistractorTarget(x:Int(x), y:Int(y))
                itemBtn.tag = DISTRACTOR_VISITED_TAG_COMPLETE_CIRCLE
                
                itemBtn.setImage(UIImage(named:"SelectedCompleteCircle"), for:.normal)
                self.perform(#selector(undoHighlightCompletedWrongItem), with: itemBtn, afterDelay: ANIMATION_PERIOD)
                break
            }
            case DISTRACTOR_VISITED_TAG_COMPLETE_CIRCLE: do {
                let x = (itemBtn.frame.origin.x - self.frame.size.width/2) + itemBtn.frame.size.width / 2
                let y = -1 * ( (itemBtn.frame.origin.y - self.frame.size.height/2) + itemBtn.frame.size.height / 2)
                self.parent?.didSelectRevisitedDistractorTarget(x:Int(x), y:Int(y))
                
                itemBtn.setImage(UIImage(named:"SelectedCompleteCircle"), for:.normal)
                self.perform(#selector(undoHighlightCompletedWrongItem), with: itemBtn, afterDelay: ANIMATION_PERIOD)
                break
            }
            case DISTRACTOR_TAG_LOWER_CIRCLE:
            do {
                let x = (itemBtn.frame.origin.x - self.frame.size.width / 2) + itemBtn.frame.size.width / 2
                let y = -1 * ( (itemBtn.frame.origin.y - self.frame.size.height / 2) + itemBtn.frame.size.height / 2)
                self.parent?.didSelectDistractorTarget(x:Int(x), y:Int(y))
                itemBtn.tag = DISTRACTOR_VISITED_TAG_LOWER_CIRCLE
                
                itemBtn.setImage(UIImage(named:"SelectedLowerCircle"), for:.normal)
                self.perform(#selector(undoHighlightLowerWrongItem), with: itemBtn, afterDelay: ANIMATION_PERIOD)
                break
            }
            case DISTRACTOR_VISITED_TAG_LOWER_CIRCLE:
            do {
                let x = (itemBtn.frame.origin.x - self.frame.size.width / 2) + itemBtn.frame.size.width / 2
                let y = -1 * ( (itemBtn.frame.origin.y - self.frame.size.height / 2) + itemBtn.frame.size.height / 2)
                self.parent?.didSelectRevisitedDistractorTarget(x:Int(x), y:Int(y))
                
                itemBtn.setImage(UIImage(named:"SelectedLowerCircle"), for:.normal)
                self.perform(#selector(undoHighlightLowerWrongItem), with: itemBtn, afterDelay: ANIMATION_PERIOD)
                break
            }
        default:
            break
        }
        self.updateClicksCount(sender)
        self.numOfLeftTargets()
    }

    func updateClicksCount(_ sender:UIButton) {
        for i in 0 ..< elementsArray.count {
            let temp:NetworkModels.Elements = elementsArray[i]
            
            let xCoord1:Float = temp.x ?? 0.0
            let xCoord2:Float = Float(sender.frame.origin.x + sender.frame.size.width / 2)
            
            let yCoord1:Float = temp.y ?? 0.0
            let yCoord2:Float = Float(sender.frame.origin.y + sender.frame.size.height / 2)
            
            if (xCoord1 == xCoord2 && yCoord1 == yCoord2) {
                var oldClickCount:Int = temp.numClicks ?? 0
                oldClickCount+=1
                elementsArray[i].numClicks = oldClickCount
                let tmpPath = NetworkModels.HitsPath(itemId: hitsPath.count + 1, index: temp.itemId!)
                hitsPath.append(tmpPath)
            }
        }
    }

    func randmoizeItems(){
        var targetNumber:Int = 0
        
        let viewWidth:Float = Float(self.frame.size.width)
        let viewHeight:Float = Float(self.frame.size.height)
        
        var img:UIImage? = UIImage(named:"CompleteCircle") // just a placeholder we only care for the size here
        var xEndBoundry:Float? = 0
        var xStartBoundry:Float = 0
        var yBoundry:Float? = 0
        var sizeRatio:Float = 1.1
        var candidatateWidth:Float? = 0
        var candidateHeight:Float? = 0
        self.removeTargets()
        
        while (targetNumber <  (15+36)) {
            var goodView = true
            let candidateView:UIButton = UIButton(type: .custom)
                                          
            candidatateWidth = Float(img?.size.width ?? 0.0) / sizeRatio
            candidateHeight = Float(img?.size.height ?? 0.0) / sizeRatio
            xEndBoundry = viewWidth - (candidatateWidth ?? 0) / 2
            yBoundry = viewHeight - (candidateHeight ?? 0) / 2
            xStartBoundry = 0
            var type:Int = 0
            
            
            candidateView.frame = CGRect(x: CGFloat(arc4random_uniform(UInt32(Int(xEndBoundry ?? 0)))) + CGFloat(xStartBoundry ), y: CGFloat(arc4random_uniform(UInt32(Int(yBoundry ?? 0)))), width: CGFloat(candidatateWidth ?? 0.0), height: CGFloat(candidateHeight ?? 0.0))
            if(targetNumber < 36 / 2){
                candidateView.setImage(UIImage(named:"LowerCircle"), for:.normal)
                candidateView.addTarget(self, action: #selector(selectWrongTarget), for: .touchUpInside)
                candidateView.tag = DISTRACTOR_TAG_LOWER_CIRCLE
                type = 2
            } else if(targetNumber < 36) {
                candidateView.setImage(UIImage(named:"CompleteCircle"), for:.normal)
                candidateView.addTarget(self, action: #selector(selectWrongTarget), for: .touchUpInside)
                candidateView.tag = DISTRACTOR_TAG_COMPLETE_CIRCLE
                type = 3
            } else {
                candidateView.setImage(UIImage(named:"UpperCircle"), for:.normal)
                candidateView.setImage(UIImage(named:"SelectedCircle"), for:.highlighted)
                candidateView.addTarget(self, action: #selector(selectTarget), for: .touchUpInside)
                candidateView.tag = CORRECT_TARGET_TAG
                type = 1
            }
            candidateView.contentMode = .scaleToFill
            
            
            for placedView in self.subviews {
                if (candidateView.frame.insetBy(dx: 3, dy: 3).intersects(placedView.frame)) {
                    goodView = false
                    break
                }
            }
            if (goodView) {
                self.addSubview(candidateView)
                
                // create and add info about the target/
                let element = NetworkModels.Elements(itemId: targetNumber + 1, type: type, numClicks: 0, x: Float(candidateView.frame.origin.x + (candidateView.frame.size.width / 2)), y: Float(candidateView.frame.origin.y + (candidateView.frame.size.height / 2)))
                
                elementsArray.append(element)
                
                targetNumber += 1
            }
        }
    }

    func getElements() -> [NetworkModels.Elements] {
        return elementsArray
    }

    func getHitsPath() -> [NetworkModels.HitsPath] {
        return hitsPath
    }
}

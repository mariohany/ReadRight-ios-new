//
//  CustomPageControl.swift
//  readright
//
//  Created by user226904 on 11/1/22.
//

import UIKit

class CustomPageControl: UIPageControl {
    
    private let activeImage: UIImage = UIImage(named:"blackDotFar")!
    private let inactiveImage: UIImage = UIImage(named:"greyDotFar")!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
    }
    
    func updateDots(){
        for i in 0..<self.subviews.count {
            let dot:UIImageView = imageViewForSubview(self.subviews[i])
            if (i == self.currentPage){
                dot.image = activeImage
            }else{
                dot.image = inactiveImage
            }
        }
    }
    
    func imageViewForSubview(_ view:UIView) -> UIImageView {
        var dot:UIImageView?
        if let view = view as? UIView {
            for subview in view.subviews{
                if let subview = subview as? UIImageView{
                    dot = subview
                    break
                }
            }
            if (dot == nil){
                dot = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
                view.addSubview(dot!)
            }
        }else{
            dot = view as? UIImageView
        }
        return dot!
    }

    func setCurrentPage(_ page:Int){
        super.currentPage = page
        updateDots()
    }
}

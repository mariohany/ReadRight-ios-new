//
//  TherapyChapterCell.swift
//  readright
//
//  Created by concarsadmin-mh on 02/04/2022.
//

import Foundation
import UIKit


class TherapyChapterCell: UITableViewCell {
    @IBOutlet weak public var ChapterTitle:UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

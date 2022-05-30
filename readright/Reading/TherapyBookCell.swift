//
//  TherapyBookCell.swift
//  readright
//
//  Created by concarsadmin-mh on 02/04/2022.
//

import Foundation
import UIKit


class TherapyBooksCell: UITableViewCell {
    @IBOutlet weak public var BookTitle:UILabel!
    @IBOutlet weak public var BookAuthor:UILabel!
    @IBOutlet weak public var BookTopic:UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

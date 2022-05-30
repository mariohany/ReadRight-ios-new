//
//  TherapyHistoryCell.swift
//  readright
//
//  Created by concarsadmin-mh on 26/02/2022.
//

import Foundation
import UIKit

class TherapyHistoryCell: UITableViewCell {
    @IBOutlet weak var HistoryDate: UILabel!
    @IBOutlet weak var HistoryTime: UILabel!
    @IBOutlet weak var HistoryTitle: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  TherapyNewsCell.swift
//  readright
//
//  Created by concarsadmin-mh on 02/04/2022.
//

import Foundation
import UIKit


public class TherapyNewsCell: UITableViewCell {
    @IBOutlet var TopicDate: UILabel!
    @IBOutlet var TopicTitle: UILabel!
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

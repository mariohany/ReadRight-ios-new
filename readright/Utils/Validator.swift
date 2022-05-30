//
//  Validator.swift
//  readright
//
//  Created by concarsadmin-mh on 31/12/2021.
//

import Foundation

class Validator {
    class func validate(email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,200}", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
}

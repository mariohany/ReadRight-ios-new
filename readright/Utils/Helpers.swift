//
//  Helpers.swift
//  readright
//
//  Created by concarsadmin-mh on 04/12/2021.
//

import UIKit
import LKAlertController
import AVFoundation

class Helpers{
    
    
//    static func appDelegate() -> AppDelegate {
//        let app = UIApplication.shared
//        return app.delegate! as! AppDelegate
//    }
    
    static let ARABIC_DICTIONARY:[String] = ["١","٢","٣","٤","٥","٦","٧","٨","٩","١٠","١١","١٢","١٣","١٤","١٥","١٦","١٧","١٩","١٩","٢٠","٢١","٢٢","٢٣","٢٤","٢٥","٢٦","٢٧","٢٨","٢٩"]
    
    enum Format{
        case date
        case time
    }
    static func convertDate(_ addedAt : String, wantedFormat: Format)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = dateFormatter.date(from: addedAt)
        switch wantedFormat {
        case .date:
            dateFormatter.dateFormat = "dd MMMM"
            if let date = date {
                let dateString = dateFormatter.string(from: date)
                return dateString
            } else {
                return ""
            }
            
        case .time:
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                let timeString = dateFormatter.string(from: date)
                return timeString
            } else {
                return ""
            }
        }
    }
    
    static func convertDateToFullDate(_ addedAt : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "YYYY-MM-dd'T'HH:mm:ss.SSSSSS"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return convertDateAlbums(addedAt)
        }
    }
    
    static func convertHomeDate(_ addedAt : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return convertDateAlbums(addedAt)
        }
    }
    
    static func convertDateArticles(_ addedAt : String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return convertDateAlbums(addedAt)
        }
    }
    
    static func convertDateQueries(_ addedAt : String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZsss"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return convertDateAlbums(addedAt)
        }
    }
    
    static func convertDateAlbums(_ addedAt : String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return ""
        }
    }
    static func convertDateInspection(_ addedAt : String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM, yyyy, h:mm a"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return ""
        }
    }
    
    static func convertDateWishList(_ addedAt : String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: addedAt)
        dateFormatter.dateFormat = "dd MMMM"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return ""
        }
    }
    
    static func convertDate(_ wantedDate : String?)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = dateFormatter.date(from: wantedDate ?? "")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = date {
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        return ""
    }
    
    static func convertDateToApi(_ wantedDate : String)-> String? {
        if wantedDate == "" {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date = dateFormatter.date(from: wantedDate)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let dateString = dateFormatter.string(from: date ?? Date())
        return dateString
    }
    
    static func convertDateType(_ wantedDate : String?)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: wantedDate ?? "")
        return date
    }
    
    static func convertNotificationsDateType(_ wantedDate : String?)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: wantedDate ?? "")
        return date
    }
    
//    static func convertDateFromServiceCenter(_ wantedDate : String?)-> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//
//        let date = dateFormatter.date(from: wantedDate ?? "")
//        dateFormatter.dateFormat = "h a"
//        if SharedPreferences.shared.currentLang == "ar" {
//            dateFormatter.locale = NSLocale(localeIdentifier: "ar") as Locale
//        }
//        if let date = date {
//            let dateString = dateFormatter.string(from: date)
//            return dateString
//        }
//        return nil
//    }
    
    static func convertNumber(_ number: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "EN")
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .none
        return numberFormatter.string(from: number as NSNumber)!
    }
    
    static func convertNumberToStringFormat(_ number : Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let formattedNumber = formatter.string(from: NSNumber(value: number))
        return formattedNumber!
    }
    
    static func floorNumber(_ number: Float) -> String {
        if floor(number) == number {
            return String(Int(number))
        } else {
            return String(format: "%.1f", number)
        }
    }
    
    static func handleErrorMessages(message: String) {
        Alert(title: "Error", message: message)
            .addAction("Ok")
            .show()
    }
    static func alert(title: String, message: String) {
        Alert(title: title, message: message)
            .addAction("Ok")
            .show()
    }
    static func convertTime(time: String) -> String?{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "H:mm"
        if let date12 = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "h:mm a"
            let date22 = dateFormatter.string(from: date12)
            return date22
        } else {
            return nil
        }
    }
    
    static func checkIfEmptyTextField(textfield:UITextField) -> Bool {
        if textfield.text?.replacingOccurrences(of: " ", with: "") == ""{
            return true
        }
        return false
    }
    static func convertArabicNumbersToEnglish(_ number : String) -> String? {
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        if let final = Formatter.number(from: number) {
            return final.stringValue
        }
        return nil
    }
    
    static func convertArabicPhoneNumbersToEnglish(_ phoneNumber : String) -> String? {
        var number = phoneNumber
        var zero : String?
        if number.starts(with: "0")  || number.starts(with: "٠") {
            number.removeFirst()
            zero = "0"
        }
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        if let final = Formatter.number(from: number) {
            if zero != nil {
                return zero! + final.stringValue
            } else {
                return final.stringValue
            }
        }
        return nil
    }
    
    static func getAudioPlayer(fileName:String) -> AVAudioPlayer? {
        let name:String = String(fileName.split(separator: ".")[0])
        let type:String = String(fileName.split(separator: ".")[1])
        let path = Bundle.main.path(forResource: name, ofType: type)
        let soundUrl = URL(fileURLWithPath: path ?? "")
        do{
            let audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            return audioPlayer
        } catch let err {
            print("ERROR: Failed to retrieve music file Path \(err.localizedDescription)")
            return nil
        }
    }
    
    static func arabicCharacter(englishNumber:Int) -> String{
        return ARABIC_DICTIONARY[englishNumber - 1]
    }
    
    static func saveTherapyCounter(_ duration:Int){
        var user = SharedPref.shared.userInfo
        user?.therapyCurrentDuration = duration
        SharedPref.shared.setUserInfo(userInfo: user)
    }
    
    
    
}



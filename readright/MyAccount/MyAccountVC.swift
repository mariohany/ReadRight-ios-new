//
//  MyAccountVC.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import Foundation
import UIKit

class MyAccountVC: UIViewController, UITextFieldDelegate{
    @IBOutlet weak private var emailField: CustomTextField!
    @IBOutlet weak private var nameField: CustomTextField!
    @IBOutlet weak private var password1Field:CustomTextField!
    @IBOutlet weak private var password2Field:CustomTextField!
    @IBOutlet weak private var yearBirthField:CustomTextField!
    @IBOutlet weak private var maleRadioButton:UIButton!
    @IBOutlet weak private var femaleRadioButton:UIButton!
    @IBOutlet weak private var RightBlindRadioBtn:UIButton!
    @IBOutlet weak private var LeftBlindRadioBtn:UIButton!
    @IBOutlet weak private var noBlindRadioBtn:UIButton!
    @IBOutlet weak private var RightVisionRadioBtn:UIButton!
    @IBOutlet weak private var LeftVisionRadioBtn:UIButton!
    @IBOutlet weak private var BothSidesRadioBtn:UIButton!
    @IBOutlet weak private var NotSureRadioBtn:UIButton!
    @IBOutlet weak private var HeadStrockRadioBtn:UIButton!
    @IBOutlet weak private var HeadEnjuryRadiobtn:UIButton!
    @IBOutlet weak private var SurgeryRadioBtn:UIButton!
    @IBOutlet weak private var OtherRadioBtn:UIButton!
    @IBOutlet weak private var startMonthField:CustomTextField!
    @IBOutlet weak private var startYearField:CustomTextField!
    @IBOutlet weak private var strokeCauseField:CustomTextField!
    @IBOutlet weak private var problemOtherCauseField:CustomTextField!
    let viewModel = MyAccountViewModel()
    private var genderIndex:Int = 0
    private var blindTypeIndex:Int = 0
    private var blindCauseIndex:Int = 0
    private var blindWithIndex:Int = 0
    let birthYearPicker = UIPickerView()
    let startYearPicker = UIPickerView()
    let startMonthPicker = UIPickerView()
    var years:[Int] = []
    var months:[Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeUserInfo()
        observeLoading()
        observeError()
        createDataSources()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        birthYearPicker.delegate = self
        startYearPicker.delegate = self
        startMonthPicker.delegate = self
        birthYearPicker.dataSource = self
        startYearPicker.dataSource = self
        startMonthPicker.dataSource = self
        
        self.yearBirthField.inputAccessoryView = toolbar
        self.startYearField.inputAccessoryView = toolbar
        self.startMonthField.inputAccessoryView = toolbar
        self.yearBirthField.inputView = birthYearPicker
        self.startYearField.inputView = startYearPicker
        self.startMonthField.inputView = startMonthPicker
        
        self.emailField.delegate = self
        self.password2Field.delegate = self
        self.password1Field.delegate = self
        self.nameField.delegate = self
        self.yearBirthField.delegate = self
        self.startMonthField.delegate = self
        self.startYearField.delegate = self
        self.problemOtherCauseField.delegate = self
        self.strokeCauseField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "حسابي"
        self.navigationController?.navigationBar.topItem?.title = "حسابي"
    }
    
    
    @objc func donePressed(){
        self.view.endEditing(true)
    }

    func createDataSources(){
        for year in 1900...Calendar.current.component(.year, from: Date()) {
            years.append(year)
        }
        for month in 1...12 {
            months.append(month)
        }
    }
    
    func observeUserInfo(){
        viewModel.userInfo.subscribe { event in
            if let userInfo = event.element, userInfo != nil  {
                if let userInfo = userInfo{
                    self.bindViewsData(userInfo: userInfo)
                }
            }
        }
    }
    
    func observeLoading() {
        viewModel.isLoading.asObservable().subscribe { status in
            if let state = status.element, state == true{
                self.view.showActivityView()
            }else {
                self.view.hideActivityView()
            }
        }
    }
    
    func observeError() {
        viewModel.error.asObservable().subscribe { status in
            if let error = status.element, !error.isEmpty {
                Helpers.handleErrorMessages(message: error)
            }
            print(status)
        }
    }
    
    @IBAction func maleAction(){
        genderIndex = 1
        if !self.maleRadioButton.isSelected {
            self.maleRadioButton.isSelected = true
            self.femaleRadioButton.isSelected = false
        }
    }
    @IBAction func femaleAction(){
        genderIndex = 2
        if !self.femaleRadioButton.isSelected {
            self.maleRadioButton.isSelected = false
            self.femaleRadioButton.isSelected = true
        }
    }
    @IBAction func noBlindRadio(){
        blindTypeIndex = 3
        if !self.noBlindRadioBtn.isSelected {
            self.RightBlindRadioBtn.isSelected = false
            self.LeftBlindRadioBtn.isSelected = false
            self.noBlindRadioBtn.isSelected = true
        }
    }
    @IBAction func rightBlindRadio(){
        blindTypeIndex = 1
        if !self.RightBlindRadioBtn.isSelected {
            self.RightBlindRadioBtn.isSelected = true
            self.LeftBlindRadioBtn.isSelected = false
            self.noBlindRadioBtn.isSelected = false
        }
    }
    @IBAction private func leftBlindRadio(){
        blindTypeIndex = 2
        if !self.LeftBlindRadioBtn.isSelected {
            self.RightBlindRadioBtn.isSelected = false
            self.LeftBlindRadioBtn.isSelected = true
            self.noBlindRadioBtn.isSelected = false
        }
    }
    @IBAction private func notSureVisionRadio(){
        blindWithIndex = 4
        if !self.NotSureRadioBtn.isSelected {
            self.RightVisionRadioBtn.isSelected = false
            self.LeftVisionRadioBtn.isSelected = false
            self.BothSidesRadioBtn.isSelected = false
            self.NotSureRadioBtn.isSelected = true
        }
    }
    @IBAction private func leftVisionRadio(){
        blindWithIndex = 2
        if !self.LeftVisionRadioBtn.isSelected {
            self.RightVisionRadioBtn.isSelected = false
            self.LeftVisionRadioBtn.isSelected = true
            self.BothSidesRadioBtn.isSelected = false
            self.NotSureRadioBtn.isSelected = false
        }
    }
    @IBAction private func bothVisionRadio(){
        blindWithIndex = 3
        if !self.BothSidesRadioBtn.isSelected {
            self.RightVisionRadioBtn.isSelected = false
            self.LeftVisionRadioBtn.isSelected = false
            self.BothSidesRadioBtn.isSelected = true
            self.NotSureRadioBtn.isSelected = false
        }
    }
    @IBAction private func rightVisionRadio(){
        blindWithIndex = 1
        if !self.RightVisionRadioBtn.isSelected {
            self.RightVisionRadioBtn.isSelected = true
            self.LeftVisionRadioBtn.isSelected = false
            self.BothSidesRadioBtn.isSelected = false
            self.NotSureRadioBtn.isSelected = false
        }
    }
    @IBAction private func headStrockRadio(){
        blindCauseIndex = 1
        if !self.HeadStrockRadioBtn.isSelected {
            self.HeadStrockRadioBtn.isSelected = true
            self.HeadEnjuryRadiobtn.isSelected = false
            self.SurgeryRadioBtn.isSelected = false
            self.OtherRadioBtn.isSelected = false
        }
    }
    @IBAction private func headHurtRadio(){
        blindCauseIndex = 2
        if !self.HeadEnjuryRadiobtn.isSelected {
            self.HeadStrockRadioBtn.isSelected = false
            self.HeadEnjuryRadiobtn.isSelected = true
            self.SurgeryRadioBtn.isSelected = false
            self.OtherRadioBtn.isSelected = false
        }
    }
    @IBAction private func headSurgeryRadio(){
        blindCauseIndex = 3
        if !self.SurgeryRadioBtn.isSelected {
            self.HeadStrockRadioBtn.isSelected = false
            self.HeadEnjuryRadiobtn.isSelected = false
            self.SurgeryRadioBtn.isSelected = true
            self.OtherRadioBtn.isSelected = false
        }
    }
    
    @IBAction private func otherRadio(){
        blindCauseIndex = 4
        if !self.OtherRadioBtn.isSelected {
            self.HeadStrockRadioBtn.isSelected = false
            self.HeadEnjuryRadiobtn.isSelected = false
            self.SurgeryRadioBtn.isSelected = false
            self.OtherRadioBtn.isSelected = true
        }
    }
    
    @IBAction private func pressRegisterBtn(){
        let email: String = self.emailField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password1: String = self.password1Field?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password2: String = self.password2Field?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let name: String = self.nameField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateOfBirth: String = self.yearBirthField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !email.isEmpty, Validator.validate(email: email) else {
            Helpers.handleErrorMessages(message: "يجب ادخال بريد الكتروني صحيح!")
            return
        }
        guard !password1.isEmpty else {
            Helpers.handleErrorMessages(message: "يجب ادخال كلمة السر!")
            return
        }
        guard password1.count >= 6 else {
            Helpers.handleErrorMessages(message: "يجب أن لا تقل كلمة السر عن ستة أحرف!")
            return
        }
        guard password1 == password2 else {
            Helpers.handleErrorMessages(message: "إعادة كلمة المرور غير صحيحة!")
            return
        }
        guard !name.isEmpty else {
            Helpers.handleErrorMessages(message: "يجب ادخال الاسم المفضل!")
            return
        }
        guard genderIndex != 0 else {
            Helpers.handleErrorMessages(message: "يجب تحديد الجنس!")
            return
        }
        guard !dateOfBirth.isEmpty else {
            Helpers.handleErrorMessages(message: "يجب ادخال عام الميلاد!")
            return
        }
        guard blindTypeIndex != 0 else {
            Helpers.handleErrorMessages(message: "يجب تحديد نوع العمى!")
            return
        }
        
        var cause:String? = nil
        if blindCauseIndex == 1 {
            cause = self.strokeCauseField.text
        }else if blindCauseIndex == 4 {
            cause = self.problemOtherCauseField.text
        }
        
        viewModel.updateUserInfo(email: email,
                           password: password1,
                           confirmPassword: password2,
                           name: name,
                           gender: genderIndex,
                           yearOfBirth: self.yearBirthField.text!,
                           hemianopiaType: blindTypeIndex,
                           vpSide: blindWithIndex,
                           vpCause: blindCauseIndex,
                           vpStartDate: "\(self.startMonthField.text ?? "")/\(self.startYearField.text ?? "")",
                           vpExtraCause: cause)
    }
    
    func bindViewsData(userInfo: NetworkModels.UserInfo){
        emailField.text = userInfo.email
        nameField.text = userInfo.name

        
        birthYearPicker.selectRow(years.firstIndex(of: Int(userInfo.yob ?? "0") ?? 0) ?? 0, inComponent: 0, animated: false)
        yearBirthField.text = userInfo.yob
        
        startYearPicker.selectRow(years.firstIndex(of: Int(userInfo.vpStartDate?.split(separator: "/").last ?? "0") ?? 0) ?? 0, inComponent: 0, animated: false)
        startYearField.text = userInfo.vpStartDate?.split(separator: "/").last?.lowercased() ?? ""
        
        startMonthPicker.selectRow(months.firstIndex(of: Int(userInfo.vpStartDate?.split(separator: "/").first ?? "0") ?? 0) ?? 0, inComponent: 0, animated: false)
        startMonthField.text = userInfo.vpStartDate?.split(separator: "/").first?.lowercased() ?? ""
        
        switch userInfo.gender {
        case 1: maleAction()
        case 2: femaleAction()
        default: break
        }
        
        switch userInfo.hemianopiaTypeId {
        case 1: rightBlindRadio()
        case 2: leftBlindRadio()
        case 3: noBlindRadio()
        default: break
        }
        
        switch userInfo.vpSideId {
        case 1: rightVisionRadio()
        case 2: leftVisionRadio()
        case 3: bothVisionRadio()
        case 4: notSureVisionRadio()
        default: break
        }
        
        switch userInfo.vpCauseId {
        case 1: headStrockRadio()
            strokeCauseField.text = userInfo.vpExtraCause
        case 2: headHurtRadio()
        case 3: headSurgeryRadio()
        case 4: otherRadio()
            problemOtherCauseField.text = userInfo.vpExtraCause
        default: break
        }
    }
}

extension MyAccountVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == birthYearPicker || pickerView == startYearPicker {
            return years.count
        }else if pickerView == startMonthPicker {
            return months.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == birthYearPicker || pickerView == startYearPicker {
            return String(years[row])
        }else if pickerView == startMonthPicker {
            return String(months[row])
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == birthYearPicker {
            self.yearBirthField.text = String(years[row])
        } else if pickerView == startYearPicker {
            self.startYearField.text = String(years[row])
        } else if pickerView == startMonthPicker {
            self.startMonthField.text = String(months[row])
        }
    }
}

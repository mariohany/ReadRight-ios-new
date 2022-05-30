//
//  RegisterVC.swift
//  readright
//
//  Created by concarsadmin-mh on 26/12/2021.
//
import UIKit
import RNActivityView
import RxSwift
import JWTDecode

class RegisterVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak private var RegisterEmailField:CustomTextField!
    @IBOutlet weak private var RegisterPassword1Field:CustomTextField!
    @IBOutlet weak private var RegisterPassword2Field:CustomTextField!
    @IBOutlet weak private var RegisterNickName:CustomTextField!
    @IBOutlet weak private var RegisterYearBirth:CustomTextField!
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
    @IBOutlet weak private var RegisterStartMonth:CustomTextField!
    @IBOutlet weak private var RegisterStartYear:CustomTextField!
    @IBOutlet weak private var RegisterStrokeCause:CustomTextField!
    @IBOutlet weak private var RegisterProblemOtherCause:CustomTextField!
    let viewModel = RegisterViewModel()
    private var genderIndex:Int = 0
    private var blindTypeIndex:Int = 0
    private var blindCauseIndex:Int = 0
    private var blindWithIndex:Int = 0
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    var initialViewController = UIViewController()
    let birthYearPicker = UIPickerView()
    let startYearPicker = UIPickerView()
    let startMonthPicker = UIPickerView()
    var years:[Int] = []
    var months:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeLogin()
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
        
        self.RegisterYearBirth.inputAccessoryView = toolbar
        self.RegisterStartYear.inputAccessoryView = toolbar
        self.RegisterStartMonth.inputAccessoryView = toolbar
        self.RegisterYearBirth.inputView = birthYearPicker
        self.RegisterStartYear.inputView = startYearPicker
        self.RegisterStartMonth.inputView = startMonthPicker
        
        self.RegisterEmailField.delegate = self
        self.RegisterPassword2Field.delegate = self
        self.RegisterPassword1Field.delegate = self
        self.RegisterNickName.delegate = self
        self.RegisterYearBirth.delegate = self
        self.RegisterStartMonth.delegate = self
        self.RegisterStartYear.delegate = self
        self.RegisterProblemOtherCause.delegate = self
        self.RegisterStrokeCause.delegate = self
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
    
    func observeLogin(){
        viewModel.loginResponse.subscribe { status in
            if let state = status.element, state == true{
                self.initialViewController = self.mainStoryBoard.instantiateViewController(withIdentifier: "TabbBarViewController")
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).window?.rootViewController = self.initialViewController
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
            if let error = status.element, error != "" {
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
        let email: String = self.RegisterEmailField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password1: String = self.RegisterPassword1Field?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password2: String = self.RegisterPassword2Field?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let name: String = self.RegisterNickName?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateOfBirth: String = self.RegisterYearBirth?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
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
            cause = self.RegisterStrokeCause.text
        }else if blindCauseIndex == 4 {
            cause = self.RegisterProblemOtherCause.text
        }
        
        viewModel.register(email: email,
                           password: password1,
                           confirmPassword: password2,
                           name: name,
                           gender: genderIndex,
                           yearOfBirth: self.RegisterYearBirth.text!,
                           hemianopiaType: blindTypeIndex,
                           vpSide: blindWithIndex,
                           vpCause: blindCauseIndex,
                           vpStartDate: "\(self.RegisterStartMonth.text ?? "")/\(self.RegisterStartYear.text ?? "")",
                           vpExtraCause: cause)
    }
    
}

extension RegisterVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
            self.RegisterYearBirth.text = String(years[row])
        } else if pickerView == startYearPicker {
            self.RegisterStartYear.text = String(years[row])
        } else if pickerView == startMonthPicker {
            self.RegisterStartMonth.text = String(months[row])
        }
    }
}

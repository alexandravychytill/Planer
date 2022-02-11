//
//  AlertViewController.swift
//  Planer
//
//  Created by Alexandra Vychytil on 07.01.22.
//
import UIKit
import UserNotifications

class AlertViewController : UIViewController, UITableViewDelegate{
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var alertTextField: UITextField!
    @IBOutlet weak var alertTextFieldDate: UITextField!
    
    var buttonAction: ( (_ textInput: String, _ textInputDate: String, _ reminderUDID: String) -> Void)?
   
    @IBOutlet weak var alertCancleButton: UIButton!

    
    let dateP = UIDatePicker()
    var alertTitle = String()
    var actionButtonTitle = String()
    var textfield = String()
    var textfieldDate = String()
    var textfieldDateText = String()
    var textfieldText = String()
    var isChanged = Bool()
    var textInput = ""
    var textInputDate = ""
    var reminderUDID = ""

    
    let notificationCenter = UNUserNotificationCenter.current()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // datepicker
        dateP.datePickerMode = .dateAndTime
        dateP.addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
        dateP.addTarget(self, action: #selector(isDateChanged), for: UIControl.Event.valueChanged)
        dateP.frame.size = CGSize(width: 0, height: 300)
        dateP.preferredDatePickerStyle = .wheels
        dateP.backgroundColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
        dateP.minimumDate = Date()
        alertTextFieldDate.inputView = dateP
        alertCancleButton.layer.cornerRadius = 5.0
        actionButton.layer.cornerRadius = 5.0
        notificationCenter.requestAuthorization(options: [.alert, .sound]){ (permissionGranted, error) in
        if(!permissionGranted){
            print("Permission denied")
            }
        }
        setupView()
    }
    
    // when datepicker value changed
    @objc func dateChanged(datePicker: UIDatePicker){
        alertTextFieldDate.text = formatDate(date: datePicker.date)
    }
    
    @objc func isDateChanged(datePicker: UIDatePicker){
        isChanged = true
    }
    
    // for alertTextFieldDate
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    // cancle button
    @IBAction func didTabCancle
    (sender: Any){
        dismiss(animated: true)
    }
    
    func setupView(){
        titleLabel.text = alertTitle
        actionButton.setTitle(actionButtonTitle, for: .normal)
        alertTextField.placeholder = textfield
        alertTextField.text = textfieldText
        alertTextFieldDate.placeholder = textfieldDate
        alertTextFieldDate.text = textfieldDateText
    }
    
    // delete notification
    func didDeleteToDo(udid: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [udid])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [udid])
    }
    
    // creat notification
    @IBAction func didTabAction(sender: Any){
        dismiss(animated: true)
        
        // Unique Disability ID
        let udidString = UUID().uuidString
       
        DispatchQueue.main.async {
           
            // format alertTextFieldDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy HH:mm"
            
            let date2 = dateFormatter.date(from: self.alertTextFieldDate.text!)
        
            var date = Date()
                // if datepicker has a changed value
                if(self.isChanged == true){
                    date = self.dateP.date
                }else{
                    date = date2!
            }
            
            let body = self.alertTextField.text!
            self.notificationCenter.getNotificationSettings{(settings) in
                // if settings are authorized
                if (settings.authorizationStatus == .authorized){
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                    content.body = body
                    
                let dateComp = Calendar.current.dateComponents([.year, .month,.day, .hour, .minute], from: date)
                    
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                
                let request = UNNotificationRequest(identifier: udidString, content: content, trigger: trigger)
        
                self.notificationCenter.add(request) {(error) in
                    if(error != nil){
                        print("Error" + error.debugDescription)
                    }
                }
                let ac = UIAlertController(title: "Notification", message: "At", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.present(ac, animated: true)
                }))
            }else{
                // enable Settings for notification
                let ac = UIAlertController(title: "Enable Notification?", message: "At", preferredStyle: .alert)
                let goToSettings = UIAlertAction(title: "Settings", style: .default){
                    (_) in
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                    else{
                        return
                    }
                    if(UIApplication.shared.canOpenURL(settingsURL)){
                        UIApplication.shared.open(settingsURL){ (_) in}
                    }
                }
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.present(ac, animated: true)
                    }))
                    ac.addAction(goToSettings)
                    }
                }
            }
        self.textInput = alertTextField.text!
        self.textInputDate = alertTextFieldDate.text!
        self.reminderUDID = udidString
        buttonAction?(textInput, textInputDate, reminderUDID)
    }
}


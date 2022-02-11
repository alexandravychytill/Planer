//
//  AlertService.swift
//  Planer
//
//  Created by Alexandra Vychytil on 07.01.22.
//
import UIKit

class AlertService{
    
    func alert(title: String, buttonTitle: String, alertTextField: String, alertTextFieldText: String ,textfieldDate: String,textfieldDateText: String , completion: @escaping (_ textInput: String, _ textInputDate: String, _ reminderUDID: String) -> Void) ->  AlertViewController{
        let storyboard = UIStoryboard(name: "AlertAddToDo", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as!
            AlertViewController
        
        alertVC.textfieldDate = textfieldDate
        
        alertVC.textfieldDateText = textfieldDateText
        
        alertVC.alertTitle = title
        
        alertVC.actionButtonTitle = buttonTitle
        
        alertVC.textfield = alertTextField
        
        alertVC.textfieldText = alertTextFieldText
        
        alertVC.buttonAction = completion
        
        return alertVC
    }
}

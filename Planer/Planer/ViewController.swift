//
//  ViewController.swift
//  Planer
//
//  Created by Alexandra Vychytil on 05.01.22.
//
import UIKit

class ViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{
    
    // to create Alert
    let alertService = AlertService()
    
    // for notification
    let alertViewController =  AlertViewController()
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()
    var dates = [String]()
    var remindersUdid = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        self.dates = UserDefaults.standard.stringArray(forKey: "dates") ?? []
        self.remindersUdid = UserDefaults.standard.stringArray(forKey: "remindersUdid") ?? []
        title = "Your To do's"
        view.addSubview(table)
        table.dataSource = self
        self.table.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
        // reload table data every 30 seconds
        Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(reloadDataTable), userInfo: nil, repeats: true)
    }
    
    @objc func reloadDataTable() {
       self.table.reloadData()
    }
    
    // to edit row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //  Allows to move rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    // change index of moved items
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
        var currentDates = UserDefaults.standard.stringArray(forKey: "dates") ?? []
        var currentRemindersUdid = UserDefaults.standard.stringArray(forKey: "remindersUdid") ?? []
        currentDates.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        currentItems.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        currentRemindersUdid.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        UserDefaults.standard.setValue(currentItems, forKey: "items")
        UserDefaults.standard.setValue(currentDates, forKey: "dates")
        UserDefaults.standard.setValue(currentItems, forKey: "remindersUdid")
        self.items.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.dates.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.remindersUdid.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.table.reloadData()
    }
    
    // update table items and notifiction
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVC = alertService.alert(title: "Edit To do", buttonTitle: "done", alertTextField: "Edit To do", alertTextFieldText: self.items[indexPath.row], textfieldDate: "Select Date", textfieldDateText: self.dates[indexPath.row]){ [weak self] textInput, textInputDate, reminderUDID in
            if  !textInput.isEmpty{
                DispatchQueue.main.async {
                    let udid = self!.remindersUdid[indexPath.row]
                    self?.alertViewController.didDeleteToDo(udid: udid)
                    var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                    currentItems[indexPath.row] = textInput
                    var currentDates = UserDefaults.standard.stringArray(forKey: "dates") ?? []
                    currentDates[indexPath.row] = textInputDate
                    var currentRemindersUdid = UserDefaults.standard.stringArray(forKey: "remindersUdid") ?? []
                    currentRemindersUdid[indexPath.row] = reminderUDID
                    UserDefaults.standard.setValue(currentItems, forKey: "items")
                    UserDefaults.standard.setValue(currentDates, forKey: "dates")
                    UserDefaults.standard.setValue(currentItems, forKey: "remindersUdid")
                    self?.items[indexPath.row] = textInput
                    self?.dates[indexPath.row] = textInputDate
                    self?.remindersUdid[indexPath.row] = reminderUDID
                    self?.table.reloadData()
                }
            }
        }
        present(alertVC, animated: false)
    }
    
    // set editing when press sort to false
    @IBAction func idTapSort(){
        if table.isEditing{
            table.isEditing = false
        }else{
            table.isEditing = true
        }
    }
    
    // add to do and notification
    @IBAction func didTabAdd(){
        let alertVC = alertService.alert(title: "Add To do", buttonTitle: "done", alertTextField: "Type in new To do", alertTextFieldText: "", textfieldDate: "Select Date", textfieldDateText: ""){ [weak self] textInput, textInputDate, reminderUDID  in
            if  !textInput.isEmpty{
                DispatchQueue.main.async {
                    var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                    var currentDates = UserDefaults.standard.stringArray(forKey: "dates") ?? []
                    var currentRemindersUdid = UserDefaults.standard.stringArray(forKey: "remindersUdid") ?? []
                    currentRemindersUdid.append(reminderUDID)
                    currentItems.append(textInput)
                    currentDates.append(textInputDate)
                    UserDefaults.standard.setValue(currentItems, forKey: "items")
                    UserDefaults.standard.setValue(currentDates, forKey: "dates")
                    UserDefaults.standard.setValue(currentDates, forKey: "remindersUdid")
                    self?.items.append(textInput)
                    self?.dates.append(textInputDate)
                    self?.remindersUdid.append(reminderUDID)
                    self?.table.reloadData()
                }
            }
        }
        present(alertVC, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    //delete icon
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // delete Tasks
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            alertViewController.didDeleteToDo(udid: remindersUdid[indexPath.row])
            items.remove(at: indexPath.row)
            dates.remove(at: indexPath.row)
            remindersUdid.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
            var currentDates = UserDefaults.standard.stringArray(forKey: "dates") ?? []
            var currentRemindersUdid = UserDefaults.standard.stringArray(forKey: "remindersUdid") ?? []
            currentItems.remove(at: indexPath.row)
            currentDates.remove(at: indexPath.row)
            currentRemindersUdid.remove(at: indexPath.row)
            UserDefaults.standard.setValue(currentItems, forKey: "items")
            UserDefaults.standard.setValue(currentDates, forKey: "dates")
            UserDefaults.standard.setValue(currentDates, forKey: "remindersUdid")
            self.table.reloadData()
            tableView.endUpdates()
        }
    }
    
    // get items lenght
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // set tableview items
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.detailTextLabel?.text = dates[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy HH:mm"
        let someDate = dateFormatter.date(from: dates[indexPath.row])
       
        if (someDate?.timeIntervalSinceNow.sign == .minus) {
            // date is in past
            cell.detailTextLabel?.textColor = UIColor.red
        }else{
            cell.detailTextLabel?.textColor = UIColor.black
        }
        return cell
    }
}

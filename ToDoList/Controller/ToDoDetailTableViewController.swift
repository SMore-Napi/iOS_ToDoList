//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Роман Солдатов on 28.03.2022.
//

import UIKit
import SafariServices

class ToDoDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDateDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var linkText: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    
    var isDatePickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    var toDo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDueDate: Date
        if let toDo = toDo {
          navigationItem.title = "To-Do"
          titleTextField.text = toDo.title
          isCompleteButton.isSelected = toDo.isComplete
          currentDueDate = toDo.dueDate
          notesTextView.text = toDo.notes
            linkText.text = toDo.link
        } else {
          currentDueDate = Date().addingTimeInterval(24*60*60)
        }

        dueDateDatePicker.date = currentDueDate
        updateDueDateLabel(date: currentDueDate)
        updateSaveButtonState()
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = date.formatted(.dateTime.month(.defaultDigits)
           .day().year(.twoDigits).hour().minute())
    }
   
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty ==
           false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    
    override func tableView(_ tableView: UITableView,
       heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            updateDueDateLabel(date: dueDateDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDateDatePicker.date
        let notes = notesTextView.text
        let link = linkText.text
        if toDo != nil {
                toDo?.title = title
                toDo?.isComplete = isComplete
                toDo?.dueDate = dueDate
                toDo?.notes = notes
                toDo?.link = link
            } else {
                toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes, link: link)
            }
    }
    
    @IBAction func openLinkInSafary(_ sender: UIButton) {
        if let url = URL(string: linkText.text!) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true,
                   completion: nil)
            }
    }
    
    @IBAction func shareQueue(_ sender: UIButton) {
        let description = "Hey! I have my to-do \(titleTextField.text!) until \(dueDateLabel.text!)"
            let activityController =
           UIActivityViewController(activityItems: [description],
              applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView =
               sender
            present(activityController, animated: true, completion: nil)
    }
    
}

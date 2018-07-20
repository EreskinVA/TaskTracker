//
//  EditTaskController.swift
//  TaskTracker
//
//  Created by Vladimir Ereskin on 19.07.2018.
//  Copyright © 2018 Vladimir Ereskin. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var textViewKomment: UITextView!
    @IBOutlet weak var textFieldTask: UITextField!
    @IBOutlet weak var statusSegmented: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Tasks?
    var rowIndexTask: Int?
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        // Загрузка из UserDefaults
        var arrayTask = [Tasks]()
        
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: DefaultsKeys.tasks) as? Data {
            print(data)
            let array = try? PropertyListDecoder().decode([Tasks].self, from: data)
            if array != nil {
                arrayTask = array!
            }
        }
        
        // заполнение View
        if textFieldTask.text == "" {
            let alertController = UIAlertController(title: "Ошибка!", message: "Не заполнена задача!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let date = datePicker.date
            let newTask = Tasks(title: textFieldTask.text!, comment: textViewKomment.text!, status: statusSegmented.titleForSegment(at: statusSegmented.selectedSegmentIndex)!, date: date)
            
            if rowIndexTask != nil {
                arrayTask[rowIndexTask!] = newTask
            } else {
                arrayTask.append(newTask)
            }
            
            // Запись в UserDefualts
            let defaults = UserDefaults.standard
            defaults.set(try? PropertyListEncoder().encode(arrayTask), forKey: DefaultsKeys.tasks)
            performSegue(withIdentifier: "unwindToVC1", sender: self)
        }
        
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewKomment.layer.borderWidth = 1
        textViewKomment.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        if task != nil {
            textViewKomment.text = task?.comment
            datePicker.date = (task?.date)!
            textFieldTask.text = task?.title
            switch task?.status {
            case "Новая": statusSegmented.selectedSegmentIndex = 0
            case "В процессе": statusSegmented.selectedSegmentIndex = 1
            case "Завершено": statusSegmented.selectedSegmentIndex = 2
            default: ""
            }
        } else {
            textViewKomment.text = task?.comment
            textFieldTask.text = task?.title
            statusSegmented.selectedSegmentIndex = 0
            statusSegmented.isEnabled = false
            datePicker.date = Date()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

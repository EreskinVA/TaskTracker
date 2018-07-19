//
//  ViewController.swift
//  TaskTracker
//
//  Created by Vladimir Ereskin on 18.07.2018.
//  Copyright © 2018 Vladimir Ereskin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var arrayTask = [Tasks]()
    var newFilterButtonPress = false
    var inProcessFilterButtonPress = false
    var endFilterButtonPress = false
    var oldArray = [Tasks]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newFilterButton: UIButton!
    @IBOutlet weak var inProcessFilterButton: UIButton!
    @IBOutlet weak var endFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        laodUserDefaults()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newFilterButtonPress = false
        inProcessFilterButtonPress = false
        endFilterButtonPress = false
        newFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        inProcessFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        endFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        laodUserDefaults()
        tableView.reloadData()
        
    }
    
    func saveUserDefaults() {
        // Запись в UserDefualts
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(arrayTask), forKey: DefaultsKeys.tasks)
    }
    
    func laodUserDefaults() {
        // Загрузка из UserDefaults
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: DefaultsKeys.tasks) as? Data {
            print(data)
            let array = try? PropertyListDecoder().decode([Tasks].self, from: data)
            if array != nil {
                arrayTask = array!
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EditViewController
                dvc.task = arrayTask[indexPath.row]
                dvc.rowIndexTask = indexPath.row
            }
        }
        
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
  
    // Фильтрация массива
    @IBAction func NewTaskFilter(_ sender: UIButton) {
        
        if !oldArray.isEmpty {
            laodUserDefaults()
        }
        
        if !newFilterButtonPress {
            let filteredArrayTask = arrayTask.filter({$0.status == "Новая"})
            oldArray = arrayTask
            arrayTask = filteredArrayTask
        } else {
            arrayTask = oldArray
            oldArray.removeAll()
        }

        newFilterButtonPress = !newFilterButtonPress
        newFilterButton.layer.backgroundColor = newFilterButtonPress ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        inProcessFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        endFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        inProcessFilterButtonPress = false
        endFilterButtonPress = false
        
        tableView.reloadData()
    }
    
    @IBAction func inProcess(_ sender: UIButton) {
        
        if !oldArray.isEmpty {
            laodUserDefaults()
        }
        
        if !inProcessFilterButtonPress {
            let filteredArrayTask = arrayTask.filter({$0.status == "В процессе"})
            oldArray = arrayTask
            arrayTask = filteredArrayTask
        } else {
            arrayTask = oldArray
            oldArray.removeAll()
        }
        
        inProcessFilterButtonPress = !inProcessFilterButtonPress
        inProcessFilterButton.layer.backgroundColor = inProcessFilterButtonPress ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        newFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        endFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        newFilterButtonPress = false
        endFilterButtonPress = false
        
        tableView.reloadData()
    }
    
    @IBAction func endTasks(_ sender: UIButton) {
        
        if !oldArray.isEmpty {
            laodUserDefaults()
        }
        
        if !endFilterButtonPress {
            let filteredArrayTask = arrayTask.filter({$0.status == "Завершено"})
            oldArray = arrayTask
            arrayTask = filteredArrayTask
        } else {
            arrayTask = oldArray
            oldArray.removeAll()
        }
        
        endFilterButtonPress = !endFilterButtonPress
        endFilterButton.layer.backgroundColor = endFilterButtonPress ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        newFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        inProcessFilterButton.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        newFilterButtonPress = false
        inProcessFilterButtonPress = false

        tableView.reloadData()
    }
    
    
}

extension ViewController: UITableViewDelegate { }

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
        
        cell.title.text = arrayTask[indexPath.row].title
        cell.comment.text = arrayTask[indexPath.row].comment
        cell.status.text = arrayTask[indexPath.row].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTask.count
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            self.arrayTask.remove(at: indexPath.row)
            self.saveUserDefaults()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}

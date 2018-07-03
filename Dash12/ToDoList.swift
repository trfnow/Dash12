//
//  ViewController.swift
//  Dash12
//
//  Created by Tyron f on 2018-07-03.
//  Copyright © 2018 Tyron F. All rights reserved.
//

import UIKit

class ToDoLisT: UITableViewController {
    
    var defaults = UserDefaults()
    
    var itemArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.itemArray = defaults.array(forKey: "ToDoList") as! [String]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskList", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var userTextField = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            
            self.itemArray.append(userTextField.text!)
            
            self.defaults.set(self.itemArray, forKey: "ToDoList")
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            
            textField.placeholder = "Enter New Task"
            userTextField = textField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    
}
















//
//  ViewController.swift
//  Dash12
//
//  Created by Tyron f on 2018-07-03.
//  Copyright © 2018 Tyron F. All rights reserved.
//

import UIKit

class ToDoLisT: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemList.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItem()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskList", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItem()

        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var userTextField = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            
            let newitem = Item()
            
            newitem.title = userTextField.text!
            
            self.itemArray.append(newitem)
            
            self.saveItem()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            
            textField.placeholder = "Enter New Task"
            userTextField = textField
        }
        
        present(alert, animated: true, completion: nil)
        

    }
    
    func saveItem() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("\n\nError Encoding : \n\n\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItem() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("\n\nError Decoding:\n\n")
            }
            
            tableView.reloadData()
            
        }
    
        

    }
    
    
}
















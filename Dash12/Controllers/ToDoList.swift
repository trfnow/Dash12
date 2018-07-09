//
//  ViewController.swift
//  Dash12
//
//  Created by Tyron f on 2018-07-03.
//  Copyright © 2018 Tyron F. All rights reserved.
//

import UIKit
import CoreData

class ToDoList: UITableViewController {
    
    var itemArray = [Item]()
    
    //Optional because it will be nil until it is set.
    var selectedCategory : Categories? {
        didSet{
            loadItem()
        }
    }
 
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemList.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
            
            let newitem = Item(context: self.context)
            newitem.title = userTextField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            
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
        
        
        do {
            try context.save()
        } catch {
            print("\n\nError Saving CoreData : \n\n\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//
//        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("\n\nError fetching data:\n\n\(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

extension ToDoList : UISearchBarDelegate {
    
    //What happens when the user presses search.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Giving the order to read data from CoreData Database of type [Item]
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Giving the order to filter data by only selection matching text.
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Giving the order to sort filtered data in alphabethical order.
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}












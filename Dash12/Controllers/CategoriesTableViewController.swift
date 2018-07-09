//
//  CategoriesTableViewController.swift
//  Dash12
//
//  Created by Tyron f on 2018-07-06.
//  Copyright © 2018 Tyron F. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    
    
    var categoryArray = [Categories]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryList", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoList
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
            print("\n\n\nCategories are saved!\n\n\n")
        } catch {
            print("\n\nError Saving Categories:\n\n\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func loadCategories() {
        let request : NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("\n\nError Loading Categories:\n\n\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Categories(context: self.context)
            
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        
        
        alert.addAction(action)
        alert.addTextField { (subTextField) in
            subTextField.placeholder = "Add a new category"
            textField = subTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

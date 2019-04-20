//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 19/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil-coalescing
        // If categories is NOT nill then return count
        // If categories is nil then return 1
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem" {
            let destVC = segue.destination as! TodoListTableViewController
            
            // Get the indexPath (row and section) of the currently selected row 
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new category"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            
            let newCategory = Category(name: textField.text!)
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
    }
    
    func loadCategories() {
        
        self.categories = realm.objects(Category.self)
        
//        self.tableView.reloadData()
    }
    
}

//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 16/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        cell.accessoryType = (item.isDone) ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = itemArray[indexPath.row]
        
        selectedItem.isDone = !selectedItem.isDone
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row after some time (if you don't have this then the selected row will be always highlighted with grey)
        
        tableView.reloadData() // Required to display the checkmark when the row is selected
    }

    // MARK: - IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Add new item"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            // Process textField.text
            let textField = alertController.textFields![0] as UITextField
            
            self.itemArray.append(Item(title: textField.text!, category: self.selectedCategory!, context: self.context))
            
            self.saveItems()
            
            
        }
        
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // One way to make an optional parameter is by declaring the parameter type as OPTIONAL and provide DEFAULT VALUE of NIL
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), additionalPredicate: NSPredicate? = nil) {
        
        // Get item(s) that belong to the selected category
        // Check item.category.name == selectedCategory.name
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", self.selectedCategory!.name!)
        
        // If there is an additional predicate then create a compund AND predicate
        // Else just get item(s) that belong to the selected category
        if let additionalPredicate = additionalPredicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching Item objects from context: \(error)")
        }
        self.tableView.reloadData()
    }
    
}

// MARK: - Search bar functionality
extension TodoListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Specify the query string / search term (i.e. TITLE attribute value that contains the search bar text and specify CASE AND DIACRITIC INSENSITIVE ([cd]))
        // %@ -> argument for string/object (i.e. CANNOT use %s because it refers to C string)
        let filterTitlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort the result based on the TITLE attribute in ALPHABETICAL ORDER
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, additionalPredicate: filterTitlePredicate)
        
    }
    
    // This delegate method is called each time the text in the search bar changes
    // i.e. when the user clears the search bar text, it will be called as well
    // However, this method will NOT be called when the search bar loads up with empty string because the text did NOT change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // If the search bar text changes AND it changes to an empty string (i.e. "")
        if searchBar.text == "" {
            loadItems() // Initialise the itemArray with all items in core data
            
            // WHENEVER you need to UPDATE THE USER INTERFACE
            // ALWAYS PERFORM IT IN THE MAIN THREAD!!!
            // IF NOT IN THE MAIN THREAD, search bar still the first responder...
            DispatchQueue.main.async {
                // Remove the focus on / Deactivate search bar (i.e. remove keyboard and cursor from search bar))
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

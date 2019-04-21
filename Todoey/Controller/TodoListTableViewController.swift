//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 16/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListTableViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Updating the Navigation Bar's UI
    // Cannot be done in viewDidLoad() because TodoListTableViewController might NOT be in the NAVIGATION STACK YET
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let selectedCategory = selectedCategory else { fatalError("Selected category does not exist") }
        
        // Set the navigation bar's title to category name
        title = selectedCategory.name
        
        setupNavBar(withHexCode: selectedCategory.hexColor)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Set nav bar and its elements color property to blue
        setupNavBar(withHexCode: "007AFF")
    }
    
    // MARK: - Navigation Bar
    func setupNavBar(withHexCode hexColor: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist yet") }
        
        // Set the navigation bar's title color to automatically adjust for readability
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: hexColor), isFlat: true) as Any]
        
        // Change the navigation bar's barTintColor (nav bar's background color and status bar)
        navBar.barTintColor = UIColor(hexString: hexColor)
        
        // Change the navigation bar's items (i.e. back button) and bar button item (i.e. add symbol) color to automatically adjust for readability
        // NOTE: IN ORDER TO WORK, NEED TO CHANGE TINT COLOR FOR BAR BUTTON ITEM TO DEFAULT
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: hexColor), isFlat: true)
        
        // Change the search bar's barTintColor (search bar's background color)
        searchBar.barTintColor = UIColor(hexString: hexColor)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = (item.isDone) ? .checkmark : .none
            
            // Change the cell's background color to have a gradient of color depending on the category's color (lighter -> darker)
            // IN ADDITION, AUTOMATICALLY SET THE TEXT LABEL COLOR DEPENDING ON THE BACKGROUND COLOR (I.E. WHITE TEXT COLOR ON BLACK BACKGROUND AND VICE VERSA) TO IMPROVE READABILITY
            if let color = UIColor(hexString: selectedCategory?.hexColor).darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(items!.count))) {
                
                cell.backgroundColor = color
                    
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
            
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = items?[indexPath.row] {
            do {
                try realm.write {
                    selectedItem.isDone = !selectedItem.isDone
                }
            } catch {
                print("Error updating to Realm: \(error)")
            }
        }

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
            
            let newItem = Item(title: textField.text!)
            
            do {
                try self.realm.write {
                    self.realm.add(newItem)
                    self.selectedCategory?.items.append(newItem)
                }
            } catch {
                print("Error saving item: \(error)")
            }
            
            self.tableView.reloadData()
            
        }
        
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // One way to make an optional parameter is by declaring the parameter type as OPTIONAL and provide DEFAULT VALUE of NIL
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData() // Required for refreshing table view when search bar (x) button is pressed
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let itemToBeDeleted = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToBeDeleted)
                }
            } catch {
                print("Error deleting from Realm: \(error)")
            }
            tableView.reloadData()
        }
    }
    
}

// MARK: - Search bar functionality
extension TodoListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
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

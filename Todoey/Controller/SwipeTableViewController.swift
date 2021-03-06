//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 21/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import UIKit
import SwipeCellKit

// *********************************************************************
//           DON'T FORGET TO SELECT THE CELL IN MAIN.STORYBOARD
//           AND UNDER IDENTITY INSPECTOR CUSTOM CLASS:
//  SELECT THE CELL TO SUBCLASS SwipeTableViewCell AND SELECT MODULE SwipeCellKit
//
// *********************************************************************

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion            
            self.deleteModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash-Icon")
        
        return [deleteAction]
    }
    
    // Perform delete action when you swipe to the left edge
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    // MARK: - To be overriden by subclass
    // Delete the row when the user swipes and clicks on the delete button
    func deleteModel(at indexPath: IndexPath) {
    }
    
}

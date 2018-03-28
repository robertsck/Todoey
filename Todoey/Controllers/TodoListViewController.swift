//
//  ViewController.swift
//  Todoey
//
//  Created by Chris Roberts on 3/28/18.
//  Copyright © 2018 Chris Roberts. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [TodoListItem] = [TodoListItem]() {
        didSet {
            //defaults.set(self.itemArray, forKey: "TodoListArray")
            tableView.reloadData()
        }
    }
    
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [TodoListItem] {
            itemArray = items
        } else {
            itemArray.append(TodoListItem(intitle: "Create a New Task", indone: false))
        }
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        newCell.textLabel?.text = item.title
        newCell.accessoryType = item.done ? .checkmark : .none
        return newCell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: - Tableview Delgate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].toggleDone() ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what to do
            if alert.textFields![0].text! != "" {
                self.itemArray.append(TodoListItem(intitle: alert.textFields![0].text!, indone: false))
                //self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}


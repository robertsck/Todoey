//
//  ViewController.swift
//  Todoey
//
//  Created by Chris Roberts on 3/28/18.
//  Copyright © 2018 Chris Roberts. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [String] = ["First Item"] {
        didSet {
            defaults.set(self.itemArray, forKey: "TodoListArray")
            tableView.reloadData()
        }
    }
    
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        newCell.textLabel?.text = itemArray[indexPath.row]
        return newCell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: - Tableview Delgate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
      tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
         
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
                self.itemArray.append(alert.textFields![0].text!)
                //self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}


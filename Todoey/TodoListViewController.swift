//
//  ViewController.swift
//  Todoey
//
//  Created by Chris Roberts on 3/28/18.
//  Copyright © 2018 Chris Roberts. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Todo 1", "Todo 2", "Todo 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}


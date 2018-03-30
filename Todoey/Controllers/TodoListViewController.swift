//
//  ViewController.swift
//  Todoey
//
//  Created by Chris Roberts on 3/28/18.
//  Copyright © 2018 Chris Roberts. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray: [TodoListItem] = [TodoListItem]()
    var selectedCategory : Category? {
        didSet {
            let request : NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            request.predicate = predicate
            loadItems(with: request)
        }
    }
    let trashIcon = UIImage.imageFromSystemBarButton(.trash)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadItems()
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ?
            .checkmark : .none
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            //self.saveItems()
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            success(true)
        }
        deleteAction.image = trashIcon
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    
    //MARK: - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what to do
            
            let newTodoListItem = TodoListItem(context: self.context)
            newTodoListItem.title = alert.textFields![0].text!
            newTodoListItem.done = false
            newTodoListItem.parentCategory = self.selectedCategory
            self.itemArray.append(newTodoListItem)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.itemArray.count-1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
            self.saveItems()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems (with request: NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest(), predicate: NSPredicate? = nil) {
        //let request : NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print ("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        //tableView.reloadData()
    }
    

    
    
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: request.predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

extension UIImage{
    
    class func imageFromSystemBarButton(_ systemItem: UIBarButtonSystemItem, renderingMode:UIImageRenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem], animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return UIImage()
    }
}


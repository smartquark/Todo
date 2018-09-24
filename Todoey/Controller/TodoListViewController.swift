//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Chambers on 19/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//
// test git remote upload
import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard  // for using user defaults which is an interface to the defaults databse for persistence
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
        loadItems()

    }


    //MARK:  - Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        // ternary operator replaces if/else below
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // replaces the if/else below (if it's
        
        // delete items from context
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        saveItems() // commit to persistent store
        
        tableView.deselectRow(at: indexPath, animated: true)   // flashes gray when selected then goes back to white
       
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the uialert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)  // if the text fields contains nil
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")  // defaults is a key:value pair and is saved in the plist file
            self.saveItems()
           
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            print(alertTextField.text!)  // nothing is displayed here because it
            print("now")
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems() {
       
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
    
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
 
    
}

//MARK: - Search bar methods
// group protocol methods together
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text)
        // case and diacretic insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //request.sortDescriptors = [sortDescriptor]
        loadItems(with: request)
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching data from context \(error)")
//        }

        //tableView.reloadData()
       // print("clicked search bar")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            // notify search bar to relinquish status as first responder
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
    }
    
}


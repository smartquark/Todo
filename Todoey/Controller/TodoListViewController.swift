//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Chambers on 19/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//
// test git remote upload
import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{  // if the above selected category is selected with a value
            loadItems()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour {
            
            title = selectedCategory!.name
            
            
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
            // guard if nav controller doesn't exist throw error crash etc
           //let navBarColour = FlatWhite()
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.barTintColor = navBarColour
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.barTintColor = navBarColour
                
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    
    //MARK:  - Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // called for every single cell in table view
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  // inherited from superclass
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
//            if let color = FlatWhite().darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
//                cell.backgroundColor = color              // chameleon framework
//                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
//
//            }
            
            //let catColor = selectedCategory?.colour
            // beneath optional chaining '?.darken'
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color              // chameleon framework
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
            
//            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))")
//            print("version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            // ternary operator replaces if/else below
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
            
        }
        
        return cell
    }
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)   // flashes gray when selected then goes back to white
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the uialert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem  = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error Saving new items: \(error)")
                }
            }
            
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
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                realm.delete(item)
            }
            } catch {
                print("error deleting cell, \(error)")
            }
        }
    }
}
//
////MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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


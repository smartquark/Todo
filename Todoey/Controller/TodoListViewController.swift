//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Chambers on 19/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//
// test git remote upload
import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard  // for using user defaults which is an interface to the defaults databse for persistence
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item()
//        newItem.title = "Quit Smoking"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Quit Drinking"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Teach Charlie how to speak more!"
//        itemArray.append(newItem3)
       
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
//         itemArray.append(newItem3)
        
//         if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        // load the item .plist
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //MARK  - Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        // ternary operator replaces if/else below
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // replaces the if/else below (if it's true it becomes false vice-versa
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//           tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        saveItems()
        //tableView.reloadData()  // forces the tableview to call it's dataqsource method again
        tableView.deselectRow(at: indexPath, animated: true)   // flashes gray when selected then goes back to white
       
    }
    
  //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on the uialert
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
        let encoder = PropertyListEncoder()
        print(dataFilePath!)
        do {
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array, \(error)")
        }
        tableView.reloadData()
    
    }
    
    func loadItems() {
         if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
            
        }
    }
    
}


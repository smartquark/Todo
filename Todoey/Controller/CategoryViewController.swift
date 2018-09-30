//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Matthew D Chambers on 25/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework



class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var categories : Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
       
    }

    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1  // NIL coalescing operator (categories is optional so if nil make it 1)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //cell.backgroundColor = UIColor.randomFlat  // chameleon framework randomflat color
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
           
            cell.backgroundColor = categoryColour // blue color from storyboard
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        
        categories = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
            super.updateModel(at: indexPath)
        
            if let item = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)

                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
            }
        
        //tableView.reloadData()
    }
    
    //MARK: - Add New Cats
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            //colour = ComplementaryFlatColorOf(hexString: "#1D98F6")
            
            self.save(category: newCategory)
          
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField.placeholder = "Create New Item"
            textField = field
           

        }
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // delegate methods for swipecellkit
    
 

}

//MARK: swipe table view delegate methods


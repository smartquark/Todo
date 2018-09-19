//
//  ViewController.swift
//  Todoey
//
//  Created by Matthew Chambers on 19/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Quit Smoking", "Quit Drinking", "Teach and play with Charlie 1hr a day"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    // Mark  - Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    
    
    
}


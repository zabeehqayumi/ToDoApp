//
//  ViewController.swift
//  ToDoApp
//
//  Created by Zabeehullah Qayumi on 9/13/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    
    let done = false
    var itemArray = ["Ali", "Emal", "khan"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //MARK:- Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       print(itemArray[indexPath.row])

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "Please Add Your Favorite Items", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray.append(alertTextField.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Type you item here"
            alertTextField = textField
           
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)

        
    }
    
}









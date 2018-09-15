//
//  ViewController.swift
//  ToDoApp
//
//  Created by Zabeehullah Qayumi on 9/13/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
       let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist")

    let done = false
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Calling Method
        loadItems()

    }
    
    
    //MARK:- Tableview Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //ternary operator
        cell.accessoryType = item.done ==  true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // Calling Method
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)

   

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Please add your fav item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = newTextField.text!
            
            self.itemArray.append(newItem)
            
            //caling method
            
            self.saveItem()
            
    
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "please type here"
            newTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

        
    }
    
    func saveItem(){
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: filePath!)
        }catch{
            print("Could not encode data \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Could not laod data : \(error.localizedDescription)")
            }
        }
    }
    
}









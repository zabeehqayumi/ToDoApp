//
//  CategoryTableViewController.swift
//  ToDoApp
//
//  Created by Zabeehullah Qayumi on 9/16/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var itemCategory = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCategory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = itemCategory[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    // added two new functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "donedone", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = itemCategory[indexPath.row]
        }
        
        
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "Pease Add your Category !", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Category(context: self.context)
            newItem.name = newTextField.text!
            self.itemCategory.append(newItem)
            
            // calling the method
            self.saveItems()
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Please enter your Category"
            newTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Could save the Data \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    func loadItems(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            itemCategory = try context.fetch(request)
        }
        catch{
            print("Could not load from core data \(error.localizedDescription)")
        }
        tableView.reloadData()
        
    }
}











